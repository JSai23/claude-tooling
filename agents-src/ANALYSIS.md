# Agent Loop System

## The Primitive

One primitive: **boss + worker**. The reviewer is the boss. The worker executes. That's the only relationship in the system.

It's 1:1 because there's no strong argument for N workers sharing one reviewer — if you need more parallelism, spawn more pairs. Each pair gets its own `agents/` directory, its own continuity files, its own loop. Pairs don't coordinate with each other. Scale horizontally, not vertically.

## Prompt Composition

Every agent invocation is layers concatenated into one system prompt:

```
session.md              shared rules (stopping, archiving, iteration pacing)
    +
worker.md OR reviewer.md    primitive role (what to read, what to write)
    +
[specialization].md         optional domain layer (planner.md, executor.md, ...)
```

Task-specific context lives in `agents/session/` and is read by the agent at runtime, not baked into the system prompt.

| Agent | = | Primitive | + Specialization |
|-------|---|-----------|------------------|
| Plan writer | | worker | planner.md |
| Plan reviewer | | reviewer | (review focus in SESSION_REVIEWER.md) |
| Code executor | | worker | executor.md |
| Code reviewer | | reviewer | (review focus in SESSION_REVIEWER.md) |

Specializations compose onto primitives. They add domain process (planning phases, coding conventions) but don't change the fundamental role. New specialization = new `.md` file in `prompts/`, same loop, same runner.

## The Loop

```
run.sh
  │
  ├─► Worker turn (headless claude -p or codex exec)
  │     reads:  SESSION_WORKER.md, FEEDBACK.md, DONEXT.md, MEMORY.md, TODO.md
  │     writes: code/plan edits, MEMORY.md, PROGRESS.md, TODO.md
  │
  │   STOP? ──► exit
  │
  ├─► Reviewer turn (headless claude -p or codex exec)
  │     reads:  SESSION_REVIEWER.md, everything the worker left behind
  │     writes: FEEDBACK.md, DONEXT.md
  │
  │   STOP? ──► exit
  │
  └─► repeat (up to MAX_ITERATIONS)
```

Each turn is a fresh headless invocation. Agents are ephemeral — they read files, do work, write files, die. The next agent picks up from the files.

## Continuity Files

The only state that survives between turns:

| File | Owner | Purpose |
|---|---|---|
| `MEMORY.md` | Worker | Append-only log — discoveries, decisions, bugs |
| `PROGRESS.md` | Worker | Point-in-time snapshot of where the effort stands |
| `TODO.md` | Worker | Living task list |
| `FEEDBACK.md` | Reviewer | Advisory — suggestions, questions, opinions |
| `DONEXT.md` | Reviewer | Directive — "do this next" |
| `STOP.txt` | Either | Kills the loop |

Old FEEDBACK/DONEXT get archived with sequential numbering (`archive/FEEDBACK_001.md`, etc.) before being overwritten.

## Session Setup

Before running, you create task-specific files in `agents/session/`:

| File | Required | Purpose |
|---|---|---|
| `SESSION_WORKER.md` | yes | What the worker should do — task, file paths, constraints, methodology |
| `SESSION_REVIEWER.md` | yes | What the reviewer should focus on — review criteria, plan file, stop conditions |
| `MANIFESTO.md` | for planner | What the software does and why |
| `USER_THOUGHTS.md` | for planner | How you think it should work |

The runner script validates the two SESSION files exist before starting. Everything else is referenced by the specialization prompts but not hard-validated.

## Iteration Pacing

The runner passes `"You are on iteration X of Y"` to each agent. `session.md` tells agents to use this:

- **Early iterations** (1-2): highest-priority items only
- **Middle iterations**: remaining items in priority order
- **Final iteration**: consistency and completeness, no new large changes, write STOP if done

## Running

```bash
cd /path/to/project

# Planner loop (worker=claude, reviewer=codex by default)
WORKER_SPEC=planner.md agents/run.sh

# Both claude, 5 iterations max
WORKER_SPEC=planner.md REVIEWER_RUNTIME=claude agents/run.sh --max-iter 5

# Custom turn limits
agents/run.sh --worker-turns 40 --reviewer-turns 15
```

### Configuration

| Env / Flag | Default | Purpose |
|---|---|---|
| `WORKER_RUNTIME` / `--worker-runtime` | `claude` | CLI to run worker (`claude` or `codex`) |
| `REVIEWER_RUNTIME` / `--reviewer-runtime` | `codex` | CLI to run reviewer |
| `WORKER_SPEC` / `--worker-spec` | none | Specialization file in `prompts/` |
| `REVIEWER_SPEC` / `--reviewer-spec` | none | Specialization file in `prompts/` |
| `MAX_ITERATIONS` / `--max-iter` | 10 | Loop cap |
| `WORKER_MAX_TURNS` / `--worker-turns` | 30 | Max agentic turns per worker invocation |
| `REVIEWER_MAX_TURNS` / `--reviewer-turns` | 20 | Max agentic turns per reviewer invocation |

## Directory Layout

```
agents/
├── run.sh                          runner script
├── prompts/
│   ├── session.md                  shared rules
│   ├── worker.md                   worker primitive
│   ├── reviewer.md                 reviewer primitive
│   ├── planner.md                  specialization: plan writing
│   └── headless-reference.md       CLI reference (claude -p, codex exec)
├── session/
│   ├── SESSION_WORKER.md           task instructions for worker
│   ├── SESSION_REVIEWER.md         task instructions for reviewer
│   ├── MANIFESTO.md                what & why (planner input)
│   └── USER_THOUGHTS.md            how (planner input)
├── MEMORY.md                       worker continuity (append-only)
├── PROGRESS.md                     worker continuity (overwrite)
├── TODO.md                         worker continuity (living list)
├── FEEDBACK.md                     reviewer output (current)
├── DONEXT.md                       reviewer output (current)
├── archive/                        old FEEDBACK/DONEXT with sequential numbering
└── .script_logs/                   session transcripts
```

The entire `agents/` directory is gitignored. It's ephemeral working state, lost when the worktree is removed.
