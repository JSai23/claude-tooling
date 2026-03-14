# Session Control — All Agents

## Agent Model

There are exactly two primitive agent types: **worker** and **reviewer**. Every agent is one or the other. Specializations (planner, executor, etc.) layer on top — they add domain knowledge but do not change the fundamental role.

## You Are One of Many

You may be the first agent in this session or the twentieth. You do not know. Before doing any work, you must orient yourself:

1. **Check what exists.** Look in your state directory for MEMORY.md, TODO.md, PROGRESS.md, FEEDBACK.md, DONEXT.md. If they exist, previous agents have been here. (Your primer tells you the exact state directory path.)
2. **Search memory.** Use `rg` or `grep` on MEMORY.md for keywords related to your task. Other agents logged their rationale, decisions, and discoveries there. Learn from them.
3. **Understand current state.** Read PROGRESS.md for where things stand. Read TODO.md for what remains. Only after you understand the current state should you begin work.

## The Loop

1. State files in your state directory provide continuity, orientation, and prompting.
2. A continuous loop alternates **worker** → **reviewer** → **worker** → ...
3. The loop runs until the **reviewer** writes `STOP.txt`. Only the reviewer can stop the loop.
4. Each iteration is a headless instance — one starts as the other finishes.

## Stopping

**Only the reviewer may write STOP.txt.** The worker never stops the loop — it works until the reviewer is satisfied. If you are a worker, you do not have STOP authority.

## HUMAN.md — Escalation to Humans

`agents/HUMAN.md` is for communicating with the human operator when you are **truly blocked**. This is NOT for questions you can figure out, decisions you can make, or uncertainties you can research.

Use it ONLY when:
- You lack permissions to access something
- A resource is genuinely unavailable
- You hit an external blocker you cannot resolve
- Something is fundamentally ambiguous and no amount of research will clarify it

Format:
```
## [WORKER] 2025-02-28 12:30

Blocked: cannot access the database credentials needed for integration tests.
Looked in .env, .env.example, and config/. Nothing present.
Need: database connection string or instructions on how to set up local test DB.
```

After writing to HUMAN.md in your state directory, if you are a **reviewer** and genuinely blocked, **write STOP.txt**. If you are a **worker**, write to HUMAN.md and continue working on whatever else you can. The human will respond with a `## [HUMAN]` section. The next agent will see it.

Do NOT keep working in circles when blocked. Stop cleanly.

## Run Directory

Agents place their state files in their state directory — a gitignored workspace that is scoped to the current loop. Each loop has its own isolated state directory.

## File Archiving Convention

When a file needs archiving (e.g., previous FEEDBACK.md before writing a new one), use sequential numbering in an `archive/` subdirectory within your state directory:

```
{state_dir}/archive/FEEDBACK_001.md
{state_dir}/archive/DONEXT_001.md
```

If unaddressed content remains in the file being archived, carry it forward into the new version.
