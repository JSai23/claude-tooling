# Read Before Reset

This file is for any agent (human or LLM) about to reset the `agents/` directory — whether starting a new loop, switching tasks, or cleaning up after a finished run.

## Before You Reset

### 1. Archive everything

Move ALL current state files and session prompts into an archive directory:

```
agents/archive/{what_the_loop_was_for}_{YYYYMMDD_HHMM}/
```

Example:
```
agents/archive/plan_v3_corrections_20260310_0430/
```

Archive these files (if they exist):
- `MEMORY.md`, `PROGRESS.md`, `TODO.md`
- `FEEDBACK.md`, `DONEXT.md`
- `CORRECTIONS.md`
- `STOP.txt`
- `session/SESSION_WORKER.md`, `session/SESSION_REVIEWER.md`
- `HUMAN.md`
- `.script_logs/` (move the whole directory)
- Any other loop-specific files

**Do NOT delete old prompts or state files.** Archive them. The archive is the history of how we got here.

### 2. Update tooling from claude-tooling

Before starting a new loop, sync the latest prompts and run script from the tooling repo:

```bash
# Find claude-tooling — normally a sibling of the current project or at ~/claude-tooling
TOOLING_DIR="$(find "$(dirname "$PWD")" ~/claude-tooling -maxdepth 0 -name 'claude-tooling' -type d 2>/dev/null | head -1)"

if [ -z "$TOOLING_DIR" ]; then
    echo "WARNING: claude-tooling not found. Check ~/claude-tooling or sibling directories."
else
    echo "Syncing from: $TOOLING_DIR"
    cp "$TOOLING_DIR/agents-src/prompts/"*.md agents/prompts/
    cp "$TOOLING_DIR/agents-src/run.sh" agents/run.sh
    cp "$TOOLING_DIR/agents-src/stream-filter.jq" agents/stream-filter.jq 2>/dev/null
    echo "Tooling updated."
fi
```

### 3. Move deliverables out of agents/

The `agents/` directory is gitignored. Nothing here is version-controlled. If the loop produced deliverables (plans, guides, specs), move them to the appropriate version-controlled directory before resetting.

Deliverables go to whatever version-controlled directory the project uses for this work (e.g., `agent_pred/`, `docs/`, `specs/`). Check the project's CLAUDE.md or README for conventions.

## Directory Layout

```
agents/                          # gitignored — loop workspace
├── READ_BEFORE_RESET.md         # this file (keep it)
├── prompts/                     # copied from claude-tooling
│   ├── session.md
│   ├── worker.md
│   ├── reviewer.md
│   ├── planner.md
│   └── python.md
├── run.sh                       # loop orchestrator
├── session/                     # session-specific prompts
│   ├── SESSION_WORKER.md
│   └── SESSION_REVIEWER.md
├── archive/                     # archived loop state
│   └── {name}_{timestamp}/
├── MEMORY.md                    # loop state (created by agents)
├── PROGRESS.md
├── TODO.md
├── FEEDBACK.md
├── DONEXT.md
└── ...
```

## Rules

- **Never version-control agents/.** It's in .gitignore for a reason.
- **Never delete without archiving.** Every loop's state is valuable context.
- **Always sync tooling.** Stale prompts cause stale loops.
- **Always move deliverables.** If it matters, it belongs in a tracked directory.
