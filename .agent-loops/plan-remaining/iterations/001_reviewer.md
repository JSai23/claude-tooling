# Iteration 1 — reviewer

Timestamp: 2026-03-15T01:23:53Z

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

## FEEDBACK.md

# Feedback — Iteration 1 Review

## Big Picture

The overall approach is solid. All 10 behavioral blocks from the plan have implementation, and the implementation is cohesive — the files work together as a system. The worker correctly identified that Block 9 was the only missing piece and built it as a separate `plugins/loop/` plugin, which is the right structural choice given the existing compilation infrastructure. The three skills (launch, author, observe) cover the plan's spec for loop management.

The core loop (`run.sh`) is well-structured — it handles isolation, tracking, tmux wrapping, branching, git-committed intelligence, and archival all within a single cohesive script. The prompts are properly updated for reviewer-only STOP authority. The distribution layer (setup.sh) handles both symlink and copy modes with override support.

No architectural problems. No over-engineering. The system is appropriately simple for what it does.

## Specific Issues

### 1. BUG: Compiled skill descriptions are broken (all three loop skills)

**Severity: Must fix.**

All three compiled skills in `compiled/loop/agentskills/` have `|` as their description instead of the actual text:

```yaml
# compiled/loop/agentskills/loop-loop-launch-a/SKILL.md
name: loop-loop-launch-a
description: >
  |
```

**Root cause:** `parse_frontmatter()` in `tools/compile-prompts.py` handles YAML `>` (folded scalar) but not `|` (literal block scalar). The source skills use `description: |` syntax. When `val == "|"`, it falls through to the `else` branch and stores the literal pipe character.

**Fix:** Add a `|` handler in `parse_frontmatter` alongside the existing `>` handler. For `|`, join with `\n` instead of spaces (that's the YAML spec difference — `>` folds newlines into spaces, `|` preserves them). For description fields specifically, either joining method is fine.

```python
# Current (line 41):
if val == ">":
# Should be:
if val in (">", "|"):
    join_char = " " if val == ">" else "\n"
    ...
    fm[key] = join_char.join(p for p in parts if p)
```

### 2. Missing `loop.yaml` in ephemeral loop directory

**Severity: Minor — note and decide.**

The plan's architecture diagram (Section 2) explicitly shows `loop.yaml` in `agents/loops/{loop-id}/`. The implementation creates `config.yaml` in `.agent-loops/{loop-id}/` (git-committed) but nothing in the ephemeral loop workspace.

This matters if an agent inside the loop wants to read its own configuration (e.g., "how many iterations am I configured for?"). Currently, agents would need to look at the git-committed dir, which is less discoverable.

**Decision needed:** Either add `loop.yaml` to the loop dir, or document that the git-committed `config.yaml` is the single source of configuration. Both are valid — just be explicit.

### 3. `WORKER_MAX_TURNS` not removed

**Severity: Cosmetic.**

The plan says `WORKER_MAX_TURNS` should be "removed entirely." The implementation keeps it as a CLI arg (`--worker-turns`) and config default (empty string). The worker's MEMORY.md acknowledges this and argues empty = no limit is behaviorally equivalent.

The worker is right — this is functionally the same. But dead config options are confusing for future readers. If it's intentionally kept for flexibility, add a comment explaining why it diverges from the plan.

### 4. PR-per-iteration is inline, not a hook script

**Severity: Not an issue — reasonable deviation.**

The plan specifies `agents-src/hooks/pr-per-iteration.sh` as a separate hook script. The implementation has it inline in `run.sh`. The worker correctly notes this is simpler and functionally equivalent. I agree — a separate hook script for one feature that's tightly coupled to the iteration lifecycle would be unnecessary indirection. The inline approach is better.

## What I Verified Was Correct

| Block | Verdict | Key Evidence |
|-------|---------|-------------|
| 1. Core Loop Hardening | **Complete** | `MAX_ITERATIONS=5`, `REVIEWER_RUNTIME=claude`, `check_stop` only after reviewer turns, session.md/worker.md have no STOP references, reviewer.md has sole STOP authority |
| 2. Loop Isolation | **Complete** | Per-loop dirs under `agents/loops/{loop-id}/`, `STATE_DIR`/`SESSION_DIR`/`LOG_DIR` all scoped to loop, `compose_primer` injects state dir path into agent context |
| 3. Tracking Log | **Complete** | `loop-log.sh` with `log_event`/`registry_event`, JSONL format, all four event types (loop_start, iteration_start, iteration_end, loop_end), proper field coverage |
| 4. Distribution Layer | **Complete** | `setup.sh` with symlinks + `--copy` fallback, `overrides/` directory created and consumed by `compose_system_prompt`, `READ_BEFORE_RESET.md` updated for new structure |
| 5. Branching & PR | **Complete** | `--pr-per-iteration` flag, `setup_pr_per_iteration`/`start_iteration_branch`/`end_iteration_branch` functions, branch hierarchy matches plan, `gh pr create` + auto-merge |
| 6. Git Intelligence | **Complete** | `.agent-loops/{loop-id}/` structure, `commit_loop_start` (prompts + config), `commit_iteration_snapshot` (state files as self-contained snapshots), `commit_loop_end` (summary) |
| 7. Loop Author Guide | **Complete** | `agents-src/prompts/loop-author.md` with 4-section anatomy, templates for both worker and reviewer, common mistakes table, reviewer prompt conventions |
| 8. Cross-Repo Registry | **Complete** | `~/.claude-loops/registry.jsonl`, `registry_event` writes start/end with repo/branch/pid/tmux_session, `mkdir -p` ensures dir exists |
| 9. Loop Management Skills | **Complete (with description bug)** | Three skills compile and have correct content. Descriptions in compiled output are broken (issue #1 above) |
| 10. Archival | **Complete** | Two-tier model: git-committed `.agent-loops/` + ephemeral `agents/archive/`, `archive_loop` function in `run.sh` moves completed workspace, `commit_loop_end` writes permanent record |

## Compilation

All plugins compile successfully. No line limit violations. The loop plugin correctly produces standalone skills (no agents to compile).

## DONEXT.md

# DONEXT — Iteration 1

## Must Fix

1. **Fix `parse_frontmatter` in `compile-prompts.py` to handle YAML `|` block scalar syntax.** The `>` handler at line 41 should also match `|`. Use `\n` as the join character for `|` (vs space for `>`). Then recompile and verify all three loop skill descriptions appear correctly in the compiled output.

## Should Fix

2. **Add a comment to `WORKER_MAX_TURNS` in `run.sh`** explaining it's kept for flexibility despite the plan saying "removed entirely." One line is enough: `# Kept for optional use; empty default = no limit (plan specified removal but flexibility is useful)`.

## Optional

3. **Decide on `loop.yaml`** in the ephemeral loop dir. Either create it (mirror of the git-committed config.yaml) or add a note in the worker MEMORY about why it was intentionally omitted. The plan shows it, the implementation skips it — document the divergence.

