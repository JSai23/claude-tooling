# Objective

Complete everything in `docs/plans/agent-loop-upgrade.md` that has not been built yet. The plan is the source of truth — read it thoroughly, then read everything in `agents-src/` to understand what already exists. The delta between plan and implementation is your work.

Do not ask what to build. The plan tells you. Diff the plan against the codebase and build what's missing.

## Context

The plan covers 10 behavioral blocks. Most of Blocks 1-7 and Block 10 have been implemented in `agents-src/`. What's likely missing includes (but is not limited to — verify by reading the plan):

- **Block 9: Loop management skills** — `loop-launch-a`, `loop-author-a`, `loop-observe-a` as installable Claude Code plugin skills. These go in `plugins/` following the existing plugin structure in this repo. Read `plugins/` to understand how skills and agents are structured. Read the plan's section 9 for what each skill does.
- **Any gaps in existing blocks** — the plan may specify behaviors that were partially implemented or missed. Verify each block against the plan.

The plugin structure in this repo uses:
- `plugins/{name}/skills/{skill-name}/SKILL.md` for skills
- `plugins/{name}/agents/{agent-name}.md` for agents
- `compiled/` for compiled output (run `uv run tools/compile-prompts.py` after changes)

## Behavior Targets

When this is done, every behavioral block in the plan should be fully implemented. The reviewer will verify each block against the plan text.

## Constraints

- Read the plan before starting. Read the existing code before writing new code.
- Follow existing patterns in `plugins/` for skill/agent structure.
- After creating or modifying any plugin agent or skill, run `uv run tools/compile-prompts.py` to recompile.
- Commit frequently.
