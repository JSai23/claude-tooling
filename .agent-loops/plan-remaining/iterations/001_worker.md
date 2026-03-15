# Iteration 1 — worker

Timestamp: 2026-03-15T01:20:05Z

## MEMORY.md

## [WORKER] 2026-03-15 02:20

### Assessment: Plan vs Implementation

Read all 10 behavioral blocks in `docs/plans/agent-loop-upgrade.md` and diffed against `agents-src/` and `plugins/`.

**Blocks 1-8 and 10: Fully implemented in agents-src/**
- Block 1 (Core Loop Hardening): run.sh has MAX_ITERATIONS=5, all-Claude defaults, reviewer-only STOP. session.md and worker.md have no STOP references. reviewer.md has sole STOP authority section.
- Block 2 (Loop Isolation): Per-loop dirs under agents/loops/{loop-id}/, state isolation via STATE_DIR.
- Block 3 (Tracking Log): loop-log.sh with log_event and registry_event functions.
- Block 4 (Distribution): setup.sh with symlinks + copy fallback, overrides support.
- Block 5 (Branching & PR): --pr-per-iteration flag, branch creation, auto-PR inline in run.sh. Plan mentions a separate hooks/pr-per-iteration.sh but the inline approach is functionally equivalent and simpler.
- Block 6 (Git-committed Intelligence): commit_loop_start, commit_iteration_snapshot, commit_loop_end in run.sh. .agent-loops/ structure.
- Block 7 (Loop Author Guide): prompts/loop-author.md with full anatomy, templates, common mistakes.
- Block 8 (Cross-Repo Registry): registry_event in loop-log.sh writes to ~/.claude-loops/registry.jsonl.
- Block 10 (Archival): archive_loop function moves workspace to agents/archive/{loop-id}/.

**Block 9 (Loop Management Skills): Missing — built in this iteration**

Created three skills as a new `loop` plugin:
- `plugins/loop/skills/loop-launch-a/SKILL.md` — pre-flight checks, tooling validation, loop-id derivation, session prompt verification, tmux launch, post-launch instructions
- `plugins/loop/skills/loop-author-a/SKILL.md` — reads repo context (CLAUDE.md, git history, structure), writes SESSION_WORKER.md and SESSION_REVIEWER.md following loop-author guide anatomy
- `plugins/loop/skills/loop-observe-a/SKILL.md` — reads registry + tracking log, lists running/completed/crashed loops, verifies tmux liveness, writes synthetic end events for crashes, shows attach commands

### Design Decisions

1. **New `loop` plugin vs adding to `util`:** Created separate `plugins/loop/` because loop management is a distinct concern from general utilities. Follows the existing pattern where `wf`, `vault`, and `util` are each separate plugins.

2. **Skills-only plugin:** The loop plugin has no agents — only action skills. The compile script was updated to handle this case (previously it skipped plugins without `agents/`).

3. **Compile script fix:** Modified `tools/compile-prompts.py` to check for skills-only plugins instead of requiring agents/ directory. This allows `compiled/loop/agentskills/` to be generated.

4. **Skill structure:** All three skills follow the existing `-a` (action) naming convention and include frontmatter with name, type, description, and argument-hint. Content follows the pattern from existing skills like `improve` and `logging-a`.

### Minor Gap Note

The plan mentions `WORKER_MAX_TURNS` should be "removed entirely" but run.sh still accepts it as a CLI arg (empty by default). This is behavioral equivalent since empty = no limit. Not changing since it's a valid flexibility to keep.

## PROGRESS.md

# Progress — plan-remaining

## Status: Complete

All 10 behavioral blocks from `docs/plans/agent-loop-upgrade.md` are now implemented.

### What was built this iteration

**Block 9: Loop Management Skills** — the only missing block.

Created `plugins/loop/` with three action skills:
- `loop-launch-a` — pre-flight checks, loop setup, tmux launch
- `loop-author-a` — session prompt authoring from repo context
- `loop-observe-a` — cross-repo loop visibility and crash detection

Supporting changes:
- `plugins/loop/.claude-plugin/plugin.json` — plugin manifest
- `tools/compile-prompts.py` — updated to handle skills-only plugins
- `compiled/loop/agentskills/` — compiled skill output

### Block coverage

| Block | Status |
|-------|--------|
| 1. Core Loop Hardening | Complete (pre-existing) |
| 2. Loop Isolation | Complete (pre-existing) |
| 3. Tracking Log | Complete (pre-existing) |
| 4. Distribution Layer | Complete (pre-existing) |
| 5. Branching & PR | Complete (pre-existing) |
| 6. Git-committed Intelligence | Complete (pre-existing) |
| 7. Loop Author Guide | Complete (pre-existing) |
| 8. Cross-Repo Registry | Complete (pre-existing) |
| 9. Loop Management Skills | Complete (this iteration) |
| 10. Archival | Complete (pre-existing) |

## TODO.md

# TODO — plan-remaining

- [x] Read plan document thoroughly
- [x] Read all existing agents-src/ files
- [x] Read existing plugin structure for patterns
- [x] Diff plan against implementation — identify gaps
- [x] Create loop plugin structure (plugin.json)
- [x] Create loop-launch-a skill
- [x] Create loop-author-a skill
- [x] Create loop-observe-a skill
- [x] Fix compile-prompts.py for skills-only plugins
- [x] Run compile-prompts.py — verify all skills compile
- [x] Write state files (MEMORY, PROGRESS, TODO)

