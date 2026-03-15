# Iteration 2 — worker

Timestamp: 2026-03-15T01:27:39Z

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

## [WORKER] 2026-03-15 02:45

### Iteration 2: Reviewer Feedback Fixes

Addressed all three items from reviewer FEEDBACK/DONEXT:

#### 1. BUG FIX: parse_frontmatter YAML `|` handler (Must Fix)
**Problem:** `parse_frontmatter()` in `compile-prompts.py` only handled `>` (folded scalar), not `|` (literal block scalar). The loop skills all used `description: |`, so their compiled descriptions showed the literal pipe character.

**Two-part fix:**
- `parse_frontmatter`: Changed `if val == ">"` to `if val in (">", "|")`. Uses `\n` as join character for `|` (preserves newlines per YAML spec) vs space for `>`.
- `write_agentskill`: Added `desc.replace("\n", "\n  ")` to properly indent multi-line descriptions under the `>` folded scalar in the output YAML. Without this, lines after the first lacked the required 2-space indent.

**Bonus discovery:** The `improve` skill in `plugins/util/` also uses `description: |` — its compiled description was also broken before this fix. Now all four `|`-using skills compile correctly.

#### 2. WORKER_MAX_TURNS comment (Should Fix)
Added a one-line comment above the `WORKER_MAX_TURNS` config default in `run.sh` explaining the intentional deviation from the plan.

#### 3. loop.yaml decision (Optional)
**Decision: Intentionally omitted.** The plan's architecture diagram shows `loop.yaml` in the ephemeral loop directory (`agents/loops/{loop-id}/loop.yaml`). The implementation uses `config.yaml` in the git-committed directory (`.agent-loops/{loop-id}/config.yaml`). Having config in one canonical place avoids drift between two copies. The primer already injects the state directory path, so agents don't need a second config source. This is a valid simplification — one source of truth is better than two.

### Verification
- Full recompile passes: all plugins, all skills, zero issues
- All four `|`-using descriptions render correctly in compiled output
- STOP authority spot-check: worker.md has zero STOP references, session.md correctly restricts STOP to reviewer, reviewer.md has sole STOP authority section
- No regressions in existing `>` descriptions (wf skills unchanged)

## PROGRESS.md

# Progress — plan-remaining

## Status: Complete

All 10 behavioral blocks from `docs/plans/agent-loop-upgrade.md` are fully implemented. All reviewer feedback from iteration 1 has been addressed.

### What was built (iteration 1)

**Block 9: Loop Management Skills** — the only missing block.

Created `plugins/loop/` with three action skills:
- `loop-launch-a` — pre-flight checks, loop setup, tmux launch
- `loop-author-a` — session prompt authoring from repo context
- `loop-observe-a` — cross-repo loop visibility and crash detection

Supporting changes:
- `plugins/loop/.claude-plugin/plugin.json` — plugin manifest
- `tools/compile-prompts.py` — updated to handle skills-only plugins
- `compiled/loop/agentskills/` — compiled skill output

### What was fixed (iteration 2)

1. **BUG: compile-prompts.py `|` block scalar** — `parse_frontmatter` now handles both `>` and `|` YAML scalars. `write_agentskill` properly indents multi-line descriptions. Fixed descriptions for all 3 loop skills + the `improve` skill.
2. **WORKER_MAX_TURNS comment** — added comment in `run.sh` documenting intentional plan deviation.
3. **loop.yaml decision** — documented as intentional omission (single source of truth in `.agent-loops/` config.yaml).

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
| 9. Loop Management Skills | Complete (iteration 1, fixed iteration 2) |
| 10. Archival | Complete (pre-existing) |

## TODO.md

# TODO — plan-remaining

## Iteration 1
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

## Iteration 2 (reviewer feedback)
- [x] Fix parse_frontmatter YAML `|` block scalar handling
- [x] Fix write_agentskill multi-line description indentation
- [x] Recompile and verify all skill descriptions correct
- [x] Add WORKER_MAX_TURNS comment in run.sh
- [x] Document loop.yaml omission decision in MEMORY
- [x] Update state files

