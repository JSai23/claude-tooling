---
name: loop-launch-a
type: action
description: |
  Pre-flight checks and launch for agent loops. Validates branch state, session prompts,
  creates loop directory structure, and launches run.sh in a tmux session.
  Use when the user wants to start a new agent loop in the current repo.
argument-hint: "[loop-id] [description of the task]"
---

> **Action skill** — Pre-flight, setup, and launch for agent loops.

## Input
$ARGUMENTS

---

Launch an agent loop in the current repo. This skill handles everything from validation to tmux launch.

## Pre-Flight Checks

Run these checks before launching. If any fail, report the issue and stop — do not launch a broken loop.

### 1. Git State

```bash
# Check for uncommitted changes
git status --porcelain
```

- If there are uncommitted changes, warn the user. Uncommitted work can be lost or cause conflicts during the loop.
- Suggest committing or stashing before launch.

### 2. Branch State

```bash
# What branch are we on?
git rev-parse --abbrev-ref HEAD
```

- Note the current branch — this becomes the base branch for the loop.

### 3. Existing Loops

```bash
# Check for active loops in this repo
ls agents/loops/ 2>/dev/null
```

- If other loops are running, warn about potential conflicts (especially if on the same branch).
- Check `~/.claude-loops/registry.jsonl` for start events without matching end events in this repo.

### 4. Tooling Setup

```bash
# Verify agents/ directory exists with required files
ls agents/prompts/session.md agents/prompts/worker.md agents/prompts/reviewer.md agents/run.sh 2>/dev/null
```

- If `agents/` is not set up, run the setup script:
  ```bash
  ~/claude-tooling/agents-src/setup.sh
  ```
- If setup script is not available, tell the user to set up the agents directory first.

## Loop ID

Derive the loop-id from the user's input:
- If the user provided a loop-id, use it directly
- If the user described a task, derive a short kebab-case slug (e.g., "fix auth flow" → `fix-auth-flow`)
- Append timestamp: `{slug}_{YYYYMMDD_HHMM}` (e.g., `fix-auth-flow_20260315_1430`)

## Session Prompts

Check if session prompts exist for this loop:

```bash
ls agents/loops/{loop-id}/session/SESSION_WORKER.md agents/loops/{loop-id}/session/SESSION_REVIEWER.md 2>/dev/null
```

If they don't exist:
1. Ask the user if they want to write them now or have you generate them
2. If generating, invoke the `loop-author-a` skill with the task description
3. If writing manually, create the directory structure and tell them where to write:
   ```
   agents/loops/{loop-id}/session/SESSION_WORKER.md
   agents/loops/{loop-id}/session/SESSION_REVIEWER.md
   ```

## Launch

Once pre-flight passes and session prompts exist:

```bash
# Launch the loop
./agents/run.sh --loop-id {loop-id} [additional flags]
```

`run.sh` automatically wraps itself in a tmux session named `loop-{loop-id}`.

### Additional Flags

Ask the user or infer from context:
- `--max-iter N` — default is 5
- `--worker-spec FILE` — specialization (e.g., `planner.md`, `python.md`, `rust.md`)
- `--pr-per-iteration` — enable PR-per-iteration branching
- `--claude-effort LEVEL` — `low`, `medium` (default), or `high`

## Post-Launch Output

After launching, tell the user:

1. The tmux session name: `loop-{loop-id}`
2. How to attach: `tmux attach -t loop-{loop-id}`
3. How to detach without stopping: `Ctrl+B`, then `D`
4. How to check status: point them to the `loop-observe-a` skill
5. Where state files will live: `agents/loops/{loop-id}/state/`
6. Where git-committed history will be: `.agent-loops/{loop-id}/`

## Common Patterns

| User says | What to do |
|-----------|-----------|
| "Start a loop for X" | Full pre-flight → generate prompts → launch |
| "Launch loop {id}" | Pre-flight → check prompts exist → launch |
| "Resume loop {id}" | Check if loop dir exists, session prompts present → launch with existing dir |
