# Agent Loop v2 — Usage Guide

## Quick Start

### 1. Set up in your project

From your project root:

```bash
~/claude-tooling/agents-src/setup.sh
```

This creates `agents/` with symlinks to `claude-tooling` (auto-updates when tooling changes). Use `--copy` if you need a standalone copy instead.

### 2. Write session prompts

Create a loop directory and write session prompts:

```bash
mkdir -p agents/loops/my-task/session
```

Write `agents/loops/my-task/session/SESSION_WORKER.md`:
```markdown
# Objective
Build X that does Y. Read `src/foo.md` before starting.

## Behavior Targets
1. Users can do A
2. System handles B correctly

## Constraints
- Use existing patterns in `src/`
```

Write `agents/loops/my-task/session/SESSION_REVIEWER.md`:
```markdown
# Review Brief
Reviewing progress toward: X that does Y

## What to Verify
- Behavior targets are met
- Tests pass

## Done Condition
Write STOP.txt when all targets are implemented and tested.
```

See `agents/prompts/loop-author.md` for the full guide on writing effective session prompts.

### 3. Launch the loop

```bash
./agents/run.sh --loop-id my-task
```

The loop automatically launches in a **tmux session** named `loop-my-task`. If tmux isn't available, it runs in the foreground with a warning.

### 4. Monitor and attach

```bash
# Attach to a running loop
tmux attach -t loop-my-task

# Detach without stopping: Ctrl+B, then D

# List all tmux sessions (all running loops)
tmux ls
```

## Configuration

All flags can also be set via environment variables.

| Flag | Default | Description |
|------|---------|-------------|
| `--loop-id NAME` | auto-generated | Human-readable loop identifier |
| `--max-iter N` | 5 | Maximum worker/reviewer iterations |
| `--worker-spec FILE` | none | Specialization file (e.g., `planner.md`, `python.md`) |
| `--reviewer-spec FILE` | none | Specialization file for reviewer |
| `--worker-runtime CLI` | claude | `claude` or `codex` |
| `--reviewer-runtime CLI` | claude | `claude` or `codex` |
| `--start-with ROLE` | worker | Start with `worker` or `reviewer` |
| `--claude-effort LEVEL` | medium | `low`, `medium`, `high` |
| `--pr-per-iteration` | off | Auto-PR each iteration to a loop branch |

### Examples

```bash
# Planning loop with planner specialization, 3 iterations
./agents/run.sh --loop-id plan-auth --worker-spec planner.md --max-iter 3

# High-effort coding loop
./agents/run.sh --loop-id build-parser --claude-effort high

# Loop with PR-per-iteration tracking
./agents/run.sh --loop-id refactor-api --pr-per-iteration
```

## How It Works

### Loop lifecycle

```
1. run.sh starts → creates loop dir, launches in tmux
2. Commits session prompts to .agent-loops/{loop-id}/prompts/
3. Writes loop_start to tracking log + registry
4. For each iteration:
   a. Worker runs → reads state files → does work → updates MEMORY/PROGRESS/TODO
   b. Iteration snapshot committed to .agent-loops/{loop-id}/iterations/
   c. Reviewer runs → reads state + work → writes FEEDBACK/DONEXT
   d. Iteration snapshot committed
   e. STOP check (only after reviewer)
5. Loop ends → summary committed, workspace archived
```

### Key rules

- **Only the reviewer can stop.** The worker never writes STOP.txt.
- **Each loop is isolated.** State files live in `agents/loops/{loop-id}/state/`. Parallel loops don't interfere.
- **Agents know their paths.** The primer injects the state directory path — agents read/write `{state_dir}/MEMORY.md`, etc.

### State files

| File | Written by | Purpose |
|------|-----------|---------|
| `MEMORY.md` | Worker | Append-only decision log |
| `PROGRESS.md` | Worker | Point-in-time status snapshot |
| `TODO.md` | Worker | Living task list |
| `FEEDBACK.md` | Reviewer | Full review and course correction |
| `DONEXT.md` | Reviewer | Directive for next iteration |
| `STOP.txt` | Reviewer only | Ends the loop |

## Observability

### Tracking log (per-repo)

`agents/.loop-log.jsonl` — JSONL events for every loop lifecycle point:

```bash
# See all events
cat agents/.loop-log.jsonl | jq .

# See just loop starts/ends
cat agents/.loop-log.jsonl | jq 'select(.event == "loop_start" or .event == "loop_end")'
```

### Cross-repo registry

`~/.claude-loops/registry.jsonl` — all loops across all repos:

```bash
# What's running now? (start events without matching end)
jq -s 'group_by(.loop_id) | map(select(length == 1 and .[0].event == "start")) | .[][] ' ~/.claude-loops/registry.jsonl

# All loops in a specific repo
jq 'select(.repo | contains("myproject"))' ~/.claude-loops/registry.jsonl

# Attach to a running loop
jq -r 'select(.event == "start") | "tmux attach -t \(.tmux_session)"' ~/.claude-loops/registry.jsonl
```

### Git-committed intelligence

`.agent-loops/{loop-id}/` is version-controlled — the permanent record of what happened:

```
.agent-loops/my-task/
├── config.yaml              # loop configuration
├── prompts/                 # session prompts used
├── iterations/
│   ├── 001_worker.md        # state after worker iter 1
│   ├── 001_reviewer.md      # state after reviewer iter 1
│   └── ...
└── summary.md               # loop outcome
```

## PR-Per-Iteration Branching

When `--pr-per-iteration` is enabled:

```
your-branch (base)
  └── loop/my-task (loop branch — human reviews this)
       ├── loop/my-task/iter-001
       ├── loop/my-task/iter-002
       └── ...
```

Each iteration auto-PRs and squash-merges back to the loop branch. The human reviews the loop branch when the loop is done.

## Per-Repo Overrides

Place additional prompt content in `agents/overrides/`:

| File | Effect |
|------|--------|
| `agents/overrides/session.md` | Appended to session prompt (all agents) |
| `agents/overrides/worker.md` | Appended to worker prompt |
| `agents/overrides/reviewer.md` | Appended to reviewer prompt |

Use these for project-specific rules, conventions, or constraints that apply to every loop in the repo.

## Archival

When a loop completes:
1. Final summary committed to `.agent-loops/{loop-id}/summary.md` (permanent, in git)
2. Workspace moved from `agents/loops/{loop-id}/` to `agents/archive/{loop-id}/` (ephemeral, gitignored)

The git-committed tier is the source of truth. The archive is a convenience — it can be cleaned at will.

## Specializations

Available worker specializations in `agents/prompts/`:

| File | Use for |
|------|---------|
| `planner.md` | Writing system or execution plans |
| `python.md` | Python development |
| `rust.md` | Rust development |

Pass via `--worker-spec planner.md`. Reviewer specializations work the same way with `--reviewer-spec`.
