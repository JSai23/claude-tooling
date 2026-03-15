---
name: loop-observe-a
type: action
description: |
  Cross-repo visibility for agent loops. Lists running, completed, and crashed loops.
  Reads the registry and per-repo tracking logs. Shows tmux attach commands.
  Use when checking what loops are active, what ran recently, or loop details.
argument-hint: "[running | completed | details {loop-id} | all]"
---

> **Action skill** — Cross-repo loop observability: running, completed, crashed, details.

## Input
$ARGUMENTS

---

Provide visibility into agent loops across all repos. This skill reads the cross-repo registry and per-repo tracking logs.

## Data Sources

### Cross-repo registry
```
~/.claude-loops/registry.jsonl
```
Each line is a JSON event with: `event` (start/end), `loop_id`, `ts`, `repo`, `branch`, `pid`, `tmux_session`, and for end events: `iterations`, `stop_reason`.

### Per-repo tracking log
```
agents/.loop-log.jsonl
```
Detailed lifecycle events: `loop_start`, `iteration_start`, `iteration_end`, `loop_end`.

### Git-committed history
```
.agent-loops/{loop-id}/
```
Permanent record: config, session prompts, iteration snapshots, summary.

## Commands

### List Running Loops

Find `start` events without matching `end` events, then verify liveness.

```bash
# Find potentially running loops
jq -s '
  group_by(.loop_id) |
  map(select(
    (map(select(.event == "start")) | length) >
    (map(select(.event == "end")) | length)
  )) |
  .[] | map(select(.event == "start")) | .[-1]
' ~/.claude-loops/registry.jsonl 2>/dev/null
```

For each candidate, verify the tmux session is alive:

```bash
tmux has-session -t "{tmux_session}" 2>/dev/null && echo "ALIVE" || echo "DEAD"
```

**If tmux session is dead but no end event exists:** the loop crashed. Write a synthetic end event:

```bash
# Detect and handle crashed loops
jq -nc \
  --arg event "end" \
  --arg loop_id "{loop_id}" \
  --arg ts "$(date -u '+%Y-%m-%dT%H:%M:%SZ')" \
  --arg repo "{repo}" \
  --arg branch "{branch}" \
  --arg tmux "{tmux_session}" \
  '{event: $event, loop_id: $loop_id, ts: $ts, repo: $repo, branch: $branch, stop_reason: "crashed", tmux_session: $tmux}' \
  >> ~/.claude-loops/registry.jsonl
```

**Output format for running loops:**

```
RUNNING LOOPS
─────────────
Loop: {loop_id}
  Repo:    {repo}
  Branch:  {branch}
  Started: {ts}
  tmux:    {tmux_session}
  Attach:  tmux attach -t {tmux_session}
```

### List Completed Loops

Filter for loops that have both start and end events.

```bash
# All completed loops
jq -s '
  group_by(.loop_id) |
  map(select(
    (map(select(.event == "end")) | length) > 0
  )) |
  .[] |
  {
    loop_id: .[0].loop_id,
    repo: (map(select(.event == "start")) | .[0].repo),
    branch: (map(select(.event == "start")) | .[0].branch),
    started: (map(select(.event == "start")) | .[0].ts),
    ended: (map(select(.event == "end")) | .[-1].ts),
    iterations: (map(select(.event == "end")) | .[-1].iterations),
    stop_reason: (map(select(.event == "end")) | .[-1].stop_reason)
  }
' ~/.claude-loops/registry.jsonl 2>/dev/null
```

Support filters:
- **By repo:** `select(.repo | contains("{path}"))`
- **By branch:** `select(.branch == "{branch}")`
- **By date:** `select(.started > "{date}")`
- **By stop reason:** `select(.stop_reason == "reviewer" or .stop_reason == "crashed")`

### Show Loop Details

For a specific loop-id, gather all available information:

1. **Registry data** — start/end events, timing, stop reason
2. **Per-repo log** — iteration-level detail (durations, exit codes)
   ```bash
   jq 'select(.loop_id == "{loop-id}")' agents/.loop-log.jsonl 2>/dev/null
   ```
3. **Git-committed history** — if `.agent-loops/{loop-id}/` exists:
   ```bash
   cat .agent-loops/{loop-id}/config.yaml
   cat .agent-loops/{loop-id}/summary.md
   ls .agent-loops/{loop-id}/iterations/
   ```

**Output format:**

```
LOOP DETAILS: {loop-id}
──────────────────────
Repo:       {repo}
Branch:     {branch}
Started:    {start_ts}
Ended:      {end_ts}
Duration:   {duration}
Iterations: {count}
Stop reason: {reason}

ITERATION TIMELINE
──────────────────
  Iter 1 worker:   142s (exit 0)
  Iter 1 reviewer: 89s  (exit 0)
  Iter 2 worker:   201s (exit 0)
  ...

GIT HISTORY
───────────
  .agent-loops/{loop-id}/
  ├── config.yaml
  ├── prompts/
  ├── iterations/ ({n} snapshots)
  └── summary.md
```

### Detect Crashed Loops

Scan for start events without end events where the tmux session no longer exists:

```bash
# For each "running" loop, check tmux
for session in $(jq -rs '
  group_by(.loop_id) |
  map(select(
    (map(select(.event == "start")) | length) >
    (map(select(.event == "end")) | length)
  )) |
  .[] | map(select(.event == "start")) | .[-1] | .tmux_session
' ~/.claude-loops/registry.jsonl 2>/dev/null); do
  if ! tmux has-session -t "$session" 2>/dev/null; then
    echo "CRASHED: $session"
  fi
done
```

For crashed loops: write a synthetic end event with `stop_reason: "crashed"` and report to the user.

## Responding to User Queries

| User asks | What to do |
|-----------|-----------|
| "What loops are running?" | List running loops with attach commands |
| "What loops ran this week?" | List completed loops filtered by date |
| "Show me the last loop" | Details for the most recent loop |
| "Show me loop {id}" | Full details for that loop |
| "Any crashed loops?" | Run crash detection, report and clean up |
| "What's happening on {repo}?" | Filter by repo path |
| "How do I attach to {loop}?" | Show `tmux attach -t {session}` command |

## Edge Cases

- **Registry doesn't exist:** No loops have been run yet. Tell the user.
- **Empty registry:** Same as above.
- **Repo tracking log missing:** Loop was run from a different directory or log was cleaned.
- **Git history missing:** Loop completed before git-committed intelligence was added, or `.agent-loops/` was removed.
