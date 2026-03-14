#!/bin/bash
# loop-log.sh — Append JSONL events to the unified tracking log and optional registry.
#
# Usage:
#   source loop-log.sh
#   log_event "loop_start" '{"branch":"main","config":{...}}'
#   log_event "iteration_start" '{"iteration":1,"role":"worker"}'
#
# Requires: LOOP_ID, AGENTS_BASE_DIR (parent of loops/) to be set.
# Optional: REGISTRY_FILE for cross-repo registry writes.

_log_file() {
  echo "${AGENTS_BASE_DIR:-.}/agents/.loop-log.jsonl"
}

# log_event EVENT_NAME [EXTRA_JSON]
# Writes a JSONL line with event, loop_id, timestamp, and merged extra fields.
log_event() {
  local event="$1"
  local extra="${2:-{\}}"
  local ts
  ts="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  local log_file
  log_file="$(_log_file)"

  # Build base JSON, then merge extra fields
  local base
  base=$(jq -nc \
    --arg event "$event" \
    --arg loop_id "${LOOP_ID:-unknown}" \
    --arg ts "$ts" \
    '{event: $event, loop_id: $loop_id, ts: $ts}')

  local merged
  merged=$(echo "$base" | jq -c --argjson extra "$extra" '. + $extra')

  echo "$merged" >> "$log_file"
}

# registry_event EVENT_NAME [EXTRA_JSON]
# Writes to the cross-repo registry at ~/.claude-loops/registry.jsonl
registry_event() {
  local event="$1"
  local extra="${2:-{\}}"
  local ts
  ts="$(date -u '+%Y-%m-%dT%H:%M:%SZ')"
  local registry="${REGISTRY_FILE:-$HOME/.claude-loops/registry.jsonl}"

  mkdir -p "$(dirname "$registry")"

  local repo_path
  repo_path="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
  local branch
  branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')"

  local base
  base=$(jq -nc \
    --arg event "$event" \
    --arg loop_id "${LOOP_ID:-unknown}" \
    --arg ts "$ts" \
    --arg repo "$repo_path" \
    --arg branch "$branch" \
    --arg pid "$$" \
    '{event: $event, loop_id: $loop_id, ts: $ts, repo: $repo, branch: $branch, pid: ($pid | tonumber)}')

  local merged
  merged=$(echo "$base" | jq -c --argjson extra "$extra" '. + $extra')

  echo "$merged" >> "$registry"
}
