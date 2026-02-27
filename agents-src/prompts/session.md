# Session Control — All Agents

## Agent Model

There are exactly two primitive agent types: **worker** and **reviewer**. Every agent is one or the other. Specializations (planner, executor, etc.) are layered on top — they add domain knowledge and instructions but do not change the fundamental role.

A fully composed agent prompt looks like:

```
session.md (this file)  →  shared rules
worker.md OR reviewer.md  →  primitive role
[specialization].md  →  optional domain layer
[invocation inputs]  →  task-specific context passed at runtime
```

## Stopping

If you believe there is no further work to be done AND YOU ARE VERY SURE OF THIS, output a file called `STOP` or `STOP.txt` to break the loop. Only use this when you are absolutely certain nothing remains.

## Run Directory

Agents always place their files in `agents/` — a gitignored directory lost when the worktree is removed. This lets agent groups do extensive writing work to pass between instances without carrying a burden of polish or needing fancy organization.

## The Loop

The system is simple:

1. Files in `agents/` provide continuity, orientation, and prompting.
2. A continuous loop alternates **worker** → **reviewer** → **worker** → ...
3. The loop runs until one agent spawns `STOP.txt`.
4. Each iteration is a headless instance kept alive by a script — one starts as the other finishes.

**It is crucial that you update your continuity files correctly.** The next instance depends entirely on what you leave behind.

## File Archiving Convention

When a file needs archiving (e.g., previous FEEDBACK.md before writing a new one), use sequential numbering in an `archive/` subdirectory:

```
agents/archive/FEEDBACK_001.md
agents/archive/FEEDBACK_002.md
agents/archive/DONEXT_001.md
```

If unaddressed content remains in the file being archived, carry it forward into the new version.
