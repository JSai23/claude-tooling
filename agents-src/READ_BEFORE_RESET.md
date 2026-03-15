# Read Before Reset

This file is for any agent (human or LLM) about to reset the `agents/` directory — whether starting a new loop, switching tasks, or cleaning up after a finished run.

## Before You Reset

### 1. Check for active loops

Look in `agents/loops/` for active loop directories. Each loop has its own isolated workspace — don't delete one loop's state while another is running.

```bash
ls agents/loops/
```

### 2. Verify git-committed intelligence

Completed loops should have their intelligence committed to `.agent-loops/{loop-id}/`. Check that the permanent record exists before cleaning up the ephemeral workspace:

```bash
ls .agent-loops/
```

### 3. Archive if needed

Completed loop workspaces are automatically moved to `agents/archive/{loop-id}/` by `run.sh`. If a loop was interrupted, manually archive it:

```bash
mv agents/loops/{loop-id} agents/archive/{loop-id}
```

### 4. Verify symlinks

If using symlink distribution, verify the links point to the current tooling:

```bash
ls -la agents/prompts agents/run.sh
```

If stale, re-run setup:
```bash
~/claude-tooling/agents-src/setup.sh
```

### 5. Move deliverables out of agents/

The `agents/` directory is gitignored. Nothing here is version-controlled. If the loop produced deliverables (plans, guides, specs), move them to the appropriate version-controlled directory before resetting.

## Directory Layout

```
agents/                          # gitignored — loop workspace
├── READ_BEFORE_RESET.md         # this file (keep it)
├── prompts/                     # symlinked to claude-tooling/agents-src/prompts
├── run.sh                       # symlinked to claude-tooling/agents-src/run.sh
├── loop-log.sh                  # symlinked to claude-tooling/agents-src/loop-log.sh
├── stream-filter.jq             # symlinked to claude-tooling/agents-src/stream-filter.jq
├── overrides/                   # per-repo prompt additions (local)
├── loops/                       # per-loop isolated workspaces
│   └── {loop-id}/
│       ├── session/             # SESSION_WORKER.md, SESSION_REVIEWER.md
│       ├── state/               # MEMORY, PROGRESS, TODO, FEEDBACK, DONEXT, STOP
│       └── .script_logs/
├── .loop-log.jsonl              # unified tracking log (all loops in this repo)
└── archive/                     # completed loop workspaces

.agent-loops/                    # version-controlled — permanent loop history
└── {loop-id}/
    ├── config.yaml              # loop configuration snapshot
    ├── prompts/                 # committed session prompts
    ├── iterations/              # per-iteration state snapshots
    └── summary.md               # loop outcome summary
```

## Rules

- **Never version-control agents/.** It's in .gitignore for a reason.
- **.agent-loops/ IS version-controlled.** This is the permanent record.
- **Don't delete active loops.** Check `agents/loops/` before cleaning.
- **Verify symlinks after tooling updates.** Or re-run `setup.sh`.
- **Always move deliverables.** If it matters, it belongs in a tracked directory.
