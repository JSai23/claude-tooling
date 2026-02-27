#!/bin/bash
set -euo pipefail

# =============================================================================
# Agent Loop Runner
# Run from the root directory of the project you want sessions in.
#
# Usage:
#   ./agents/run.sh
#   ./agents/run.sh --max-iter 5
#   WORKER_SPEC=planner.md REVIEWER_SPEC=plan-reviewer.md ./agents/run.sh
#
# Expects:
#   agents/prompts/session.md        — shared base
#   agents/prompts/worker.md         — worker primitive
#   agents/prompts/reviewer.md       — reviewer primitive
#   agents/session/SESSION_WORKER.md — session-specific worker instructions
#   agents/session/SESSION_REVIEWER.md — session-specific reviewer instructions
#
# Optional:
#   WORKER_SPEC   — specialization filename in agents/prompts/ (e.g., planner.md)
#   REVIEWER_SPEC — specialization filename in agents/prompts/ (e.g., plan-reviewer.md)
# =============================================================================

# --- Config ---
WORKER_RUNTIME="${WORKER_RUNTIME:-claude}"     # claude or codex
REVIEWER_RUNTIME="${REVIEWER_RUNTIME:-codex}"  # claude or codex
WORKER_SPEC="${WORKER_SPEC:-}"                 # specialization file in agents/prompts/
REVIEWER_SPEC="${REVIEWER_SPEC:-}"             # specialization file in agents/prompts/
MAX_ITERATIONS="${MAX_ITERATIONS:-10}"
WORKER_MAX_TURNS="${WORKER_MAX_TURNS:-30}"
REVIEWER_MAX_TURNS="${REVIEWER_MAX_TURNS:-20}"

# --- Paths (relative to project root) ---
AGENTS_DIR="./agents"
PROMPTS_DIR="./agents/prompts"
SCRIPTS_DIR="./agents/session"
LOG_DIR="./agents/.script_logs"

# --- Parse CLI args ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --max-iter) MAX_ITERATIONS="$2"; shift 2 ;;
    --worker-runtime) WORKER_RUNTIME="$2"; shift 2 ;;
    --reviewer-runtime) REVIEWER_RUNTIME="$2"; shift 2 ;;
    --worker-spec) WORKER_SPEC="$2"; shift 2 ;;
    --reviewer-spec) REVIEWER_SPEC="$2"; shift 2 ;;
    --worker-turns) WORKER_MAX_TURNS="$2"; shift 2 ;;
    --reviewer-turns) REVIEWER_MAX_TURNS="$2"; shift 2 ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
done

# --- Validate ---
for f in "$PROMPTS_DIR/session.md" "$PROMPTS_DIR/worker.md" "$PROMPTS_DIR/reviewer.md"; do
  if [[ ! -f "$f" ]]; then
    echo "MISSING: $f"
    exit 1
  fi
done

if [[ ! -f "$SCRIPTS_DIR/SESSION_WORKER.md" ]]; then
  echo "MISSING: $SCRIPTS_DIR/SESSION_WORKER.md — write your worker session instructions first."
  exit 1
fi

if [[ ! -f "$SCRIPTS_DIR/SESSION_REVIEWER.md" ]]; then
  echo "MISSING: $SCRIPTS_DIR/SESSION_REVIEWER.md — write your reviewer session instructions first."
  exit 1
fi

# --- Setup ---
SESSION_ID="$(date +%Y%m%d_%H%M%S)"
SESSION_LOG_DIR="$LOG_DIR/$SESSION_ID"
mkdir -p "$SESSION_LOG_DIR" "$AGENTS_DIR/archive"

MASTER_LOG="$SESSION_LOG_DIR/session.log"

log() {
  local msg="[$(date '+%H:%M:%S')] $1"
  echo "$msg" | tee -a "$MASTER_LOG"
}

# --- Compose system prompt ---
# Concatenates: session.md + primitive (worker/reviewer) + optional specialization
compose_system_prompt() {
  local primitive="$1"  # worker.md or reviewer.md
  local spec="$2"       # specialization filename or empty

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
}

# --- Run a single agent turn ---
run_agent() {
  local role="$1"       # "worker" or "reviewer"
  local runtime="$2"    # "claude" or "codex"
  local primitive="$3"  # worker.md or reviewer.md
  local spec="$4"       # specialization filename or empty
  local max_turns="$5"
  local iter="$6"
  local padded_iter
  padded_iter="$(printf '%03d' "$iter")"

  local turn_log="$SESSION_LOG_DIR/${role}_${padded_iter}.log"
  local system_prompt_file
  system_prompt_file="$(mktemp)"
  compose_system_prompt "$primitive" "$spec" > "$system_prompt_file"

  log "--- $role turn $iter ($runtime) ---"
  log "System prompt: $primitive${spec:+ + $spec}"

  local exit_code=0
  local role_upper
  role_upper="$(echo "$role" | tr '[:lower:]' '[:upper:]')"

  if [[ "$runtime" == "claude" ]]; then
    claude -p \
      --dangerously-skip-permissions \
      --system-prompt-file "$system_prompt_file" \
      --max-turns "$max_turns" \
      --output-format text \
      "Begin. Read agents/session/SESSION_${role_upper}.md for your session instructions." \
      2>&1 | tee -a "$turn_log" "$MASTER_LOG" || exit_code=$?

  elif [[ "$runtime" == "codex" ]]; then
    codex exec \
      --full-auto \
      "$(cat "$system_prompt_file")

Begin. Read agents/session/SESSION_${role_upper}.md for your session instructions." \
      2>&1 | tee -a "$turn_log" "$MASTER_LOG" || exit_code=$?

  else
    log "ERROR: Unknown runtime '$runtime'"
    rm -f "$system_prompt_file"
    return 1
  fi

  rm -f "$system_prompt_file"

  if [[ $exit_code -ne 0 ]]; then
    log "WARNING: $role exited with code $exit_code"
  fi

  return $exit_code
}

# --- Main loop ---
log "========================================="
log "Session $SESSION_ID started"
log "Worker:   $WORKER_RUNTIME (spec: ${WORKER_SPEC:-none})"
log "Reviewer: $REVIEWER_RUNTIME (spec: ${REVIEWER_SPEC:-none})"
log "Max iterations: $MAX_ITERATIONS"
log "========================================="

for i in $(seq 1 "$MAX_ITERATIONS"); do
  # --- Worker turn ---
  run_agent "worker" "$WORKER_RUNTIME" "worker.md" "$WORKER_SPEC" "$WORKER_MAX_TURNS" "$i"

  if [[ -f "$AGENTS_DIR/STOP.txt" || -f "$AGENTS_DIR/STOP" ]]; then
    log "STOP file found after worker turn $i. Ending session."
    break
  fi

  # --- Reviewer turn ---
  run_agent "reviewer" "$REVIEWER_RUNTIME" "reviewer.md" "$REVIEWER_SPEC" "$REVIEWER_MAX_TURNS" "$i"

  if [[ -f "$AGENTS_DIR/STOP.txt" || -f "$AGENTS_DIR/STOP" ]]; then
    log "STOP file found after reviewer turn $i. Ending session."
    break
  fi

  log "Iteration $i complete."
done

log "========================================="
log "Session $SESSION_ID finished."
log "========================================="
