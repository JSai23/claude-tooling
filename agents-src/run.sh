#!/bin/bash
set -euo pipefail

# Traps are set after loop-log.sh is sourced (see cleanup function below)

# =============================================================================
# Agent Loop Runner (v2)
# Orchestrates worker/reviewer agent loops with per-loop isolation, tracking,
# tmux integration, git-committed intelligence, and optional PR-per-iteration.
#
# Usage:
#   ./agents/run.sh --loop-id auth-refactor
#   ./agents/run.sh --loop-id fix-parser --max-iter 3
#   ./agents/run.sh --loop-id feature --pr-per-iteration
#
# Expects:
#   agents/prompts/session.md          — shared session control
#   agents/prompts/worker.md           — worker primitive
#   agents/prompts/reviewer.md         — reviewer primitive
#
# Session prompts are in the loop directory:
#   agents/loops/{loop-id}/session/SESSION_WORKER.md
#   agents/loops/{loop-id}/session/SESSION_REVIEWER.md
#
# Optional:
#   WORKER_SPEC   — specialization filename in agents/prompts/
#   REVIEWER_SPEC — specialization filename in agents/prompts/
# =============================================================================

# --- Resolve script directory (follows symlinks) ---
SCRIPT_SOURCE="${BASH_SOURCE[0]}"
while [[ -L "$SCRIPT_SOURCE" ]]; do
  SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" && pwd)"
  SCRIPT_SOURCE="$(readlink "$SCRIPT_SOURCE")"
  [[ "$SCRIPT_SOURCE" != /* ]] && SCRIPT_SOURCE="$SCRIPT_DIR/$SCRIPT_SOURCE"
done
SCRIPT_DIR="$(cd -P "$(dirname "$SCRIPT_SOURCE")" && pwd)"

# --- Config defaults ---
WORKER_RUNTIME="${WORKER_RUNTIME:-claude}"
REVIEWER_RUNTIME="${REVIEWER_RUNTIME:-claude}"
WORKER_SPEC="${WORKER_SPEC:-}"
REVIEWER_SPEC="${REVIEWER_SPEC:-}"
MAX_ITERATIONS="${MAX_ITERATIONS:-5}"
WORKER_MAX_TURNS="${WORKER_MAX_TURNS:-}"
REVIEWER_MAX_TURNS="${REVIEWER_MAX_TURNS:-}"
START_WITH="${START_WITH:-worker}"
CLAUDE_EFFORT="${CLAUDE_EFFORT:-medium}"
CODEX_EFFORT="${CODEX_EFFORT:-high}"
LOOP_ID=""
PR_PER_ITERATION=false

# --- Paths ---
AGENTS_BASE_DIR="./agents"
PROMPTS_DIR="./agents/prompts"

# Save original args before parsing (needed for tmux re-exec)
ORIGINAL_ARGS=("$@")

# --- Parse CLI args ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --loop-id) LOOP_ID="$2"; shift 2 ;;
    --max-iter) MAX_ITERATIONS="$2"; shift 2 ;;
    --worker-runtime) WORKER_RUNTIME="$2"; shift 2 ;;
    --reviewer-runtime) REVIEWER_RUNTIME="$2"; shift 2 ;;
    --worker-spec) WORKER_SPEC="$2"; shift 2 ;;
    --reviewer-spec) REVIEWER_SPEC="$2"; shift 2 ;;
    --worker-turns) WORKER_MAX_TURNS="$2"; shift 2 ;;
    --reviewer-turns) REVIEWER_MAX_TURNS="$2"; shift 2 ;;
    --start-with) START_WITH="$2"; shift 2 ;;
    --claude-effort) CLAUDE_EFFORT="$2"; shift 2 ;;
    --codex-effort) CODEX_EFFORT="$2"; shift 2 ;;
    --pr-per-iteration) PR_PER_ITERATION=true; shift ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
done

# --- Generate loop-id if not provided ---
if [[ -z "$LOOP_ID" ]]; then
  LOOP_ID="loop_$(date +%Y%m%d_%H%M%S)"
fi

# --- Loop directory setup ---
LOOP_DIR="${AGENTS_BASE_DIR}/loops/${LOOP_ID}"
STATE_DIR="${LOOP_DIR}/state"
SESSION_DIR="${LOOP_DIR}/session"
LOG_DIR="${LOOP_DIR}/.script_logs"

# --- Git-committed intelligence directory ---
GIT_LOOP_DIR=".agent-loops/${LOOP_ID}"

# --- Source the logging helper ---
export LOOP_ID
export AGENTS_BASE_DIR
source "$SCRIPT_DIR/loop-log.sh" 2>/dev/null || source "$(dirname "$0")/loop-log.sh" 2>/dev/null || {
  # Inline fallback if loop-log.sh not found alongside script
  log_event() { :; }
  registry_event() { :; }
  echo "WARNING: loop-log.sh not found, tracking disabled"
}

# --- Crash cleanup trap ---
# Writes loop_end/registry events on catchable signals so tracking logs aren't orphaned.
# SIGKILL is uncatchable — the observe skill's liveness check handles that case.
cleanup() {
  log_event "loop_end" "$(jq -nc \
    --argjson iters "${ITERATIONS_COMPLETED:-0}" \
    '{iterations_completed: $iters, stop_reason: "crash"}')"
  registry_event "end" "$(jq -nc \
    --argjson iters "${ITERATIONS_COMPLETED:-0}" \
    --arg tmux "${TMUX_SESSION:-}" \
    '{iterations: $iters, stop_reason: "crash", tmux_session: $tmux}')"
}
trap 'cleanup; trap - INT; kill -INT 0' INT
trap 'cleanup; trap - TERM; kill -TERM 0' TERM

# --- tmux auto-wrap ---
# If not already inside tmux, re-launch inside a named tmux session.
if [[ -z "${TMUX:-}" ]] && command -v tmux &>/dev/null; then
  TMUX_SESSION="loop-${LOOP_ID}"
  echo "Launching in tmux session: $TMUX_SESSION"
  echo "Attach with: tmux attach -t '$TMUX_SESSION'"

  # Rebuild the command with original args + auto-generated loop-id if needed
  REEXEC_ARGS=()
  LOOP_ID_IN_ARGS=false
  for arg in "${ORIGINAL_ARGS[@]}"; do
    REEXEC_ARGS+=("$arg")
    [[ "$arg" == "--loop-id" ]] && LOOP_ID_IN_ARGS=true
  done
  if [[ "$LOOP_ID_IN_ARGS" == "false" ]]; then
    REEXEC_ARGS+=("--loop-id" "$LOOP_ID")
  fi

  exec tmux new-session -d -s "$TMUX_SESSION" \
    "$(printf '%q ' "$0" "${REEXEC_ARGS[@]}")" \; \
    attach -t "$TMUX_SESSION"
elif [[ -z "${TMUX:-}" ]]; then
  # tmux not available, running in foreground
  TMUX_SESSION=""
  echo "WARNING: tmux not found. Loop will run in foreground (non-detachable)."
fi
# Inside tmux: session name is set by the tmux environment; use it or default empty
TMUX_SESSION="${TMUX_SESSION:-}"

# --- Validate prompts ---
for f in "$PROMPTS_DIR/session.md" "$PROMPTS_DIR/worker.md" "$PROMPTS_DIR/reviewer.md"; do
  if [[ ! -f "$f" ]]; then
    echo "MISSING: $f"
    exit 1
  fi
done

# --- Create loop directory structure ---
mkdir -p "$STATE_DIR" "$SESSION_DIR" "$LOG_DIR" "$AGENTS_BASE_DIR/archive"

# --- Check for session prompts ---
# If session prompts don't exist in the loop dir, check the legacy location
if [[ ! -f "$SESSION_DIR/SESSION_WORKER.md" ]]; then
  if [[ -f "$AGENTS_BASE_DIR/session/SESSION_WORKER.md" ]]; then
    cp "$AGENTS_BASE_DIR/session/SESSION_WORKER.md" "$SESSION_DIR/SESSION_WORKER.md"
    echo "Copied SESSION_WORKER.md from legacy location"
  else
    echo "MISSING: $SESSION_DIR/SESSION_WORKER.md — write your worker session instructions first."
    exit 1
  fi
fi

if [[ ! -f "$SESSION_DIR/SESSION_REVIEWER.md" ]]; then
  if [[ -f "$AGENTS_BASE_DIR/session/SESSION_REVIEWER.md" ]]; then
    cp "$AGENTS_BASE_DIR/session/SESSION_REVIEWER.md" "$SESSION_DIR/SESSION_REVIEWER.md"
    echo "Copied SESSION_REVIEWER.md from legacy location"
  else
    echo "MISSING: $SESSION_DIR/SESSION_REVIEWER.md — write your reviewer session instructions first."
    exit 1
  fi
fi

if [[ "$START_WITH" != "worker" && "$START_WITH" != "reviewer" ]]; then
  echo "ERROR: --start-with must be 'worker' or 'reviewer', got '$START_WITH'"
  exit 1
fi

if ! command -v jq &>/dev/null; then
  echo "ERROR: jq is required. Install with: brew install jq (macOS) or apt install jq (Linux)"
  exit 1
fi

# --- Session setup ---
SESSION_ID="$(date +%Y%m%d_%H%M%S)"
SESSION_LOG_DIR="$LOG_DIR/$SESSION_ID"
mkdir -p "$SESSION_LOG_DIR"

MASTER_LOG="$SESSION_LOG_DIR/session.log"

log() {
  local msg="[$(date '+%H:%M:%S')] $1"
  echo "$msg" | tee -a "$MASTER_LOG"
}

# --- Resolve the stream-filter.jq path ---
STREAM_FILTER=""
for candidate in "$AGENTS_BASE_DIR/stream-filter.jq" "$SCRIPT_DIR/stream-filter.jq"; do
  if [[ -f "$candidate" ]]; then
    STREAM_FILTER="$candidate"
    break
  fi
done
if [[ -z "$STREAM_FILTER" ]]; then
  echo "WARNING: stream-filter.jq not found, raw JSON output will be shown"
fi

# --- Compose system prompt ---
compose_system_prompt() {
  local primitive="$1"
  local spec="$2"

  cat "$PROMPTS_DIR/session.md"
  echo ""
  echo "---"
  echo ""
  cat "$PROMPTS_DIR/$primitive"

  if [[ -n "$spec" && -f "$PROMPTS_DIR/$spec" ]]; then
    echo ""
    echo "---"
    echo ""
    cat "$PROMPTS_DIR/$spec"
  fi

  # Append per-repo overrides if they exist
  local override_base
  override_base="$(basename "$primitive" .md)"
  if [[ -f "$AGENTS_BASE_DIR/overrides/${override_base}.md" ]]; then
    echo ""
    echo "---"
    echo ""
    cat "$AGENTS_BASE_DIR/overrides/${override_base}.md"
  fi

  # Always append session override if present
  if [[ -f "$AGENTS_BASE_DIR/overrides/session.md" ]]; then
    echo ""
    echo "---"
    echo ""
    cat "$AGENTS_BASE_DIR/overrides/session.md"
  fi
}

# --- Compose the session primer (the -p prompt argument) ---
compose_primer() {
  local role_upper="$1"
  local iter="$2"
  local session_file="$SESSION_DIR/SESSION_${role_upper}.md"

  # Inject the state directory path so agents know where their files are
  echo "# Loop Context"
  echo ""
  echo "Your state directory is \`${STATE_DIR}/\`. All state files (MEMORY.md, PROGRESS.md, TODO.md, FEEDBACK.md, DONEXT.md, STOP.txt) live there."
  echo "Read and write them at \`${STATE_DIR}/MEMORY.md\`, \`${STATE_DIR}/TODO.md\`, etc."
  echo ""
  echo "---"
  echo ""

  cat "$session_file"
  echo ""
  echo "---"
  echo ""
  echo "You are on iteration ${iter} of ${MAX_ITERATIONS}. Begin."
}

# --- Run a single agent turn ---
run_agent() {
  local role="$1"
  local runtime="$2"
  local primitive="$3"
  local spec="$4"
  local max_turns="$5"
  local iter="$6"
  local padded_iter
  padded_iter="$(printf '%03d' "$iter")"

  local turn_log="$SESSION_LOG_DIR/${role}_${padded_iter}.log"

  local system_prompt_file
  system_prompt_file="$(mktemp)"
  compose_system_prompt "$primitive" "$spec" > "$system_prompt_file"

  local role_upper
  role_upper="$(echo "$role" | tr '[:lower:]' '[:upper:]')"

  local primer
  primer="$(compose_primer "$role_upper" "$iter")"

  log "--- $role turn $iter ($runtime) ---"
  log "System prompt: $primitive${spec:+ + $spec}"
  log "Loop dir: $LOOP_DIR"

  local start_time
  start_time="$(date +%s)"

  # Log iteration start
  log_event "iteration_start" "$(jq -nc --argjson iter "$iter" --arg role "$role" '{iteration: $iter, role: $role}')"

  local exit_code=0

  if [[ "$runtime" == "claude" ]]; then
    CLAUDE_CODE_EFFORT_LEVEL="$CLAUDE_EFFORT" claude -p \
      --dangerously-skip-permissions \
      --append-system-prompt-file "$system_prompt_file" \
      ${max_turns:+--max-turns "$max_turns"} \
      --output-format stream-json \
      --verbose \
      "$primer" \
      2>>"$turn_log" | \
      tee -a "$turn_log" | \
      if [[ -n "$STREAM_FILTER" ]]; then
        jq --unbuffered -rj -f "$STREAM_FILTER"
      else
        cat
      fi || exit_code=$?

  elif [[ "$runtime" == "codex" ]]; then
    codex exec \
      --full-auto \
      -c model_reasoning_effort="$CODEX_EFFORT" \
      "$(cat "$system_prompt_file")

${primer}" \
      2>&1 | tee -a "$turn_log" || exit_code=$?

  else
    log "ERROR: Unknown runtime '$runtime'"
    rm -f "$system_prompt_file"
    return 1
  fi

  rm -f "$system_prompt_file"

  local end_time
  end_time="$(date +%s)"
  local duration=$((end_time - start_time))

  # Log iteration end
  log_event "iteration_end" "$(jq -nc \
    --argjson iter "$iter" \
    --arg role "$role" \
    --argjson duration "$duration" \
    --argjson exit_code "$exit_code" \
    '{iteration: $iter, role: $role, duration_s: $duration, exit_code: $exit_code}')"

  if [[ $exit_code -ne 0 ]]; then
    log "WARNING: $role exited with code $exit_code"
  fi

  return $exit_code
}

# --- Check for STOP (only after reviewer turns) ---
check_stop() {
  local role="$1"
  local iter="$2"

  # Only check STOP after reviewer turns — the worker cannot stop
  if [[ "$role" != "reviewer" ]]; then
    return 1
  fi

  if [[ -f "$STATE_DIR/STOP.txt" || -f "$STATE_DIR/STOP" ]]; then
    log "STOP file found after reviewer turn $iter. Ending session."
    return 0
  fi
  return 1
}

# --- Git-committed intelligence: commit iteration snapshot ---
commit_iteration_snapshot() {
  local iter="$1"
  local role="$2"
  local padded_iter
  padded_iter="$(printf '%03d' "$iter")"

  local snapshot_dir="${GIT_LOOP_DIR}/iterations"
  mkdir -p "$snapshot_dir"

  local snapshot_file="${snapshot_dir}/${padded_iter}_${role}.md"

  {
    echo "# Iteration ${iter} — ${role}"
    echo ""
    echo "Timestamp: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
    echo ""

    if [[ -f "$STATE_DIR/MEMORY.md" ]]; then
      echo "## MEMORY.md"
      echo ""
      cat "$STATE_DIR/MEMORY.md"
      echo ""
    fi

    if [[ -f "$STATE_DIR/PROGRESS.md" ]]; then
      echo "## PROGRESS.md"
      echo ""
      cat "$STATE_DIR/PROGRESS.md"
      echo ""
    fi

    if [[ -f "$STATE_DIR/TODO.md" ]]; then
      echo "## TODO.md"
      echo ""
      cat "$STATE_DIR/TODO.md"
      echo ""
    fi

    if [[ "$role" == "reviewer" ]]; then
      if [[ -f "$STATE_DIR/FEEDBACK.md" ]]; then
        echo "## FEEDBACK.md"
        echo ""
        cat "$STATE_DIR/FEEDBACK.md"
        echo ""
      fi
      if [[ -f "$STATE_DIR/DONEXT.md" ]]; then
        echo "## DONEXT.md"
        echo ""
        cat "$STATE_DIR/DONEXT.md"
        echo ""
      fi
    fi
  } > "$snapshot_file"

  # Skip pre-commit hooks — orchestrator cannot handle interactive hooks
  git add "$snapshot_file" 2>>"$MASTER_LOG" && \
    git commit -m "loop(${LOOP_ID}): iteration ${iter} ${role} snapshot" --no-verify 2>>"$MASTER_LOG" || \
    log "WARNING: Failed to commit iteration snapshot for iter $iter $role"
}

# --- Git-committed intelligence: commit session prompts at start ---
commit_loop_start() {
  local prompts_dest="${GIT_LOOP_DIR}/prompts"
  mkdir -p "$prompts_dest"

  cp "$SESSION_DIR/SESSION_WORKER.md" "$prompts_dest/" 2>/dev/null || true
  cp "$SESSION_DIR/SESSION_REVIEWER.md" "$prompts_dest/" 2>/dev/null || true

  # Save config snapshot
  {
    echo "loop_id: ${LOOP_ID}"
    echo "started: $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
    echo "max_iterations: ${MAX_ITERATIONS}"
    echo "worker_runtime: ${WORKER_RUNTIME}"
    echo "reviewer_runtime: ${REVIEWER_RUNTIME}"
    echo "worker_spec: ${WORKER_SPEC:-none}"
    echo "reviewer_spec: ${REVIEWER_SPEC:-none}"
    echo "start_with: ${START_WITH}"
    echo "pr_per_iteration: ${PR_PER_ITERATION}"
    echo "branch: $(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')"
  } > "${GIT_LOOP_DIR}/config.yaml"

  # Skip pre-commit hooks — orchestrator cannot handle interactive hooks
  git add "$GIT_LOOP_DIR" 2>>"$MASTER_LOG" && \
    git commit -m "loop(${LOOP_ID}): start — commit session prompts and config" --no-verify 2>>"$MASTER_LOG" || \
    log "WARNING: Failed to commit loop start for ${LOOP_ID}"
}

# --- Git-committed intelligence: commit summary at end ---
commit_loop_end() {
  local stop_reason="$1"
  local iterations_completed="$2"

  local summary_file="${GIT_LOOP_DIR}/summary.md"
  {
    echo "# Loop Summary: ${LOOP_ID}"
    echo ""
    echo "- **Completed:** $(date -u '+%Y-%m-%dT%H:%M:%SZ')"
    echo "- **Iterations:** ${iterations_completed}"
    echo "- **Stop reason:** ${stop_reason}"
    echo ""

    if [[ -f "$STATE_DIR/TODO.md" ]]; then
      echo "## Final TODO State"
      echo ""
      cat "$STATE_DIR/TODO.md"
      echo ""
    fi

    if [[ -f "$STATE_DIR/MEMORY.md" ]]; then
      echo "## Key Decisions (from MEMORY.md)"
      echo ""
      # Extract section headers as a summary
      grep -E '^##' "$STATE_DIR/MEMORY.md" 2>/dev/null || echo "(no sections found)"
      echo ""
    fi
  } > "$summary_file"

  # Skip pre-commit hooks — orchestrator cannot handle interactive hooks
  git add "$summary_file" 2>>"$MASTER_LOG" && \
    git commit -m "loop(${LOOP_ID}): end — ${stop_reason} after ${iterations_completed} iterations" --no-verify 2>>"$MASTER_LOG" || \
    log "WARNING: Failed to commit loop end summary for ${LOOP_ID}"
}

# --- PR-per-iteration support ---
LOOP_BRANCH=""
BASE_BRANCH=""

setup_pr_per_iteration() {
  if [[ "$PR_PER_ITERATION" != "true" ]]; then
    return
  fi

  BASE_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  LOOP_BRANCH="loop/${LOOP_ID}"

  # Create the loop branch from current branch
  git checkout -b "$LOOP_BRANCH" 2>/dev/null || {
    log "Loop branch $LOOP_BRANCH already exists, checking out"
    git checkout "$LOOP_BRANCH"
  }

  log "PR-per-iteration enabled. Loop branch: $LOOP_BRANCH (base: $BASE_BRANCH)"
}

start_iteration_branch() {
  local iter="$1"
  if [[ "$PR_PER_ITERATION" != "true" ]]; then
    return
  fi

  local padded_iter
  padded_iter="$(printf '%03d' "$iter")"
  local iter_branch="${LOOP_BRANCH}/iter-${padded_iter}"

  git checkout -b "$iter_branch" 2>/dev/null || {
    log "Iteration branch $iter_branch already exists, checking out"
    git checkout "$iter_branch"
  }
}

end_iteration_branch() {
  local iter="$1"
  if [[ "$PR_PER_ITERATION" != "true" ]]; then
    return
  fi

  local padded_iter
  padded_iter="$(printf '%03d' "$iter")"
  local iter_branch="${LOOP_BRANCH}/iter-${padded_iter}"

  # Push and create PR
  git push origin "$iter_branch" 2>/dev/null || {
    log "WARNING: Failed to push $iter_branch"
    return
  }

  if command -v gh &>/dev/null; then
    local pr_url
    pr_url=$(gh pr create \
      --base "$LOOP_BRANCH" \
      --head "$iter_branch" \
      --title "Loop ${LOOP_ID} — Iteration ${iter}" \
      --body "Automated iteration branch from agent loop." \
      2>/dev/null) || true

    if [[ -n "$pr_url" ]]; then
      log "PR created: $pr_url"
      # Auto-merge with squash
      gh pr merge "$pr_url" --squash --auto 2>/dev/null || {
        log "WARNING: Auto-merge failed for $pr_url"
      }
    fi
  else
    log "WARNING: gh CLI not found, skipping PR creation"
  fi

  # Return to loop branch
  git checkout "$LOOP_BRANCH" 2>/dev/null || true
  git pull origin "$LOOP_BRANCH" 2>/dev/null || true
}

# --- Archive loop workspace on completion ---
archive_loop() {
  if [[ -d "$LOOP_DIR" ]]; then
    local archive_dest="${AGENTS_BASE_DIR}/archive/${LOOP_ID}"
    log "Archiving loop workspace to $archive_dest"
    mv "$LOOP_DIR" "$archive_dest" 2>/dev/null || {
      log "WARNING: Failed to archive loop directory"
      return
    }
    # Log dir moved — use echo directly since MASTER_LOG path is now stale
    echo "[$(date '+%H:%M:%S')] Archive complete."
  fi
}

# =============================================================================
# Main loop
# =============================================================================

log "========================================="
log "Loop $LOOP_ID started"
log "Worker:   $WORKER_RUNTIME (spec: ${WORKER_SPEC:-none}, effort: $CLAUDE_EFFORT)"
log "Reviewer: $REVIEWER_RUNTIME (spec: ${REVIEWER_SPEC:-none}, effort: $CODEX_EFFORT)"
log "Start with: $START_WITH"
log "Max iterations: $MAX_ITERATIONS"
log "Loop dir: $LOOP_DIR"
log "State dir: $STATE_DIR"
log "PR-per-iteration: $PR_PER_ITERATION"
log "========================================="

# Write loop start events
log_event "loop_start" "$(jq -nc \
  --arg branch "$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')" \
  --argjson max_iter "$MAX_ITERATIONS" \
  --arg worker_runtime "$WORKER_RUNTIME" \
  --arg reviewer_runtime "$REVIEWER_RUNTIME" \
  --arg start_with "$START_WITH" \
  --argjson pr_per_iter "$( [[ "$PR_PER_ITERATION" == "true" ]] && echo "true" || echo "false" )" \
  '{branch: $branch, config: {max_iterations: $max_iter, worker_runtime: $worker_runtime, reviewer_runtime: $reviewer_runtime, start_with: $start_with, pr_per_iteration: $pr_per_iter}}')"

registry_event "start" "$(jq -nc --arg tmux "$TMUX_SESSION" '{tmux_session: $tmux}')"

# Commit session prompts to git
commit_loop_start

# Set up PR-per-iteration if enabled
setup_pr_per_iteration

STOP_REASON="max_iterations"
ITERATIONS_COMPLETED=0

for i in $(seq 1 "$MAX_ITERATIONS"); do
  ITERATIONS_COMPLETED=$i

  # Start iteration branch if PR-per-iteration
  start_iteration_branch "$i"

  if [[ "$START_WITH" == "reviewer" ]]; then
    run_agent "reviewer" "$REVIEWER_RUNTIME" "reviewer.md" "$REVIEWER_SPEC" "$REVIEWER_MAX_TURNS" "$i" || true
    commit_iteration_snapshot "$i" "reviewer"
    if check_stop "reviewer" "$i"; then
      STOP_REASON="reviewer"
      end_iteration_branch "$i"
      break
    fi

    run_agent "worker" "$WORKER_RUNTIME" "worker.md" "$WORKER_SPEC" "$WORKER_MAX_TURNS" "$i" || true
    commit_iteration_snapshot "$i" "worker"
  else
    run_agent "worker" "$WORKER_RUNTIME" "worker.md" "$WORKER_SPEC" "$WORKER_MAX_TURNS" "$i" || true
    commit_iteration_snapshot "$i" "worker"

    run_agent "reviewer" "$REVIEWER_RUNTIME" "reviewer.md" "$REVIEWER_SPEC" "$REVIEWER_MAX_TURNS" "$i" || true
    commit_iteration_snapshot "$i" "reviewer"
    if check_stop "reviewer" "$i"; then
      STOP_REASON="reviewer"
      end_iteration_branch "$i"
      break
    fi
  fi

  # End iteration branch (PR + merge back)
  end_iteration_branch "$i"

  log "Iteration $i complete."
done

# --- Loop end ---
log "========================================="
log "Loop $LOOP_ID finished. Reason: $STOP_REASON. Iterations: $ITERATIONS_COMPLETED."
log "========================================="

# Commit final summary
commit_loop_end "$STOP_REASON" "$ITERATIONS_COMPLETED"

# Write loop end events
log_event "loop_end" "$(jq -nc \
  --argjson iters "$ITERATIONS_COMPLETED" \
  --arg reason "$STOP_REASON" \
  '{iterations_completed: $iters, stop_reason: $reason}')"

registry_event "end" "$(jq -nc \
  --argjson iters "$ITERATIONS_COMPLETED" \
  --arg reason "$STOP_REASON" \
  --arg tmux "$TMUX_SESSION" \
  '{iterations: $iters, stop_reason: $reason, tmux_session: $tmux}')"

# Archive the loop workspace
archive_loop
