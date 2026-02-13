---
name: build-conventions
description: Knowledge for implementation — coding standards, deviation protocol, progress tracking, testing philosophy
user-invocable: false
---

# Build Conventions

How to implement from a plan doc.

## Resumption Protocol

1. Check `docs/plans/` for the active plan
2. Read the full plan doc — purpose, approach, milestones
3. Check milestone progress markers (`[x]` vs `[ ]`)
4. Resume from the first incomplete step
5. Tell the user where you're picking up from

## Deviation Protocol

Any deviation from the plan requires:

1. STOP — explain what you're encountering that differs from the plan
2. PROPOSE — how to handle it, with tradeoffs
3. CONFIRM — get user agreement before proceeding
4. RECORD — update `decisions.md` with the deviation and rationale
5. CONTINUE — proceed with the agreed approach

Never silently drift from the plan.

## Progress Tracking

After completing each milestone:
- Mark steps as `[x]` in the plan doc
- Add timestamped entry to the Progress section
- Record any surprises in the Surprises section
- Record any decisions in `decisions.md`

## Testing Philosophy

Tests are part of implementation, not a separate phase.

- Test real behavior, not mocked abstractions
- Minimize mocking — mock only at external service boundaries
- If you must mock, mock at the boundary, not the internals
- Given/When/Then structure
- Happy path first, then error cases, then edge cases
- Tests define behavior — they should read as specifications
- Tests that fail are valuable information. List them, don't silently "fix" the expectation.

## Code Standards

- Write the simplest code that handles the full complex case
- No stubs, TODOs, or placeholders
- No try/catch unless actually handling the error meaningfully
- No copy-paste with minor modifications — extract shared logic
- Split files at ~200 lines, functions at ~30 lines
- Follow existing codebase patterns and naming conventions

## File-by-File Reflection

As you write each file, pause:
- Does this follow patterns established in the codebase?
- Is naming consistent with surrounding code?
- Is there an existing utility I should use instead of writing new code?
- Could this be simpler?
- Surface observations to the user rather than silently deciding
