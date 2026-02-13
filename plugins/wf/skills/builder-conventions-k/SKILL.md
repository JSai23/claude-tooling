---
name: builder-conventions-k
type: knowledge
description: Implementation practices — deviation protocol, progress tracking, code standards, codebase reflection
user-invocable: false
---

> **Knowledge skill** — Implementation practices: deviation protocol, progress tracking, code standards, codebase reflection.

# Build Conventions

## Resumption

Find the active plan, read it fully, check milestone progress markers, resume from the first incomplete step. Tell the user where you're picking up from.

## Deviation Protocol

Any deviation from the plan:
1. STOP — explain what differs from the plan
2. PROPOSE — how to handle it, with tradeoffs
3. CONFIRM — get user agreement
4. RECORD — update decisions.md with the deviation and rationale
5. CONTINUE

Never silently drift from the plan.

## Progress Tracking

After each milestone:
- Mark steps as `[x]` in the plan doc
- Add timestamped entry to the Progress section
- Record surprises in the Surprises section
- Record decisions in decisions.md

## Code Standards

- Write the simplest code that handles the full complex case
- No stubs, TODOs, or placeholders
- No try/catch unless actually handling the error meaningfully
- No copy-paste with minor modifications — extract shared logic
- Split files at ~200 lines, functions at ~30 lines
- Follow existing codebase patterns and naming conventions

## Codebase Reflection

As you write each file, pause:
- Does this follow patterns established in the codebase?
- Is naming consistent with surrounding code?
- Is there an existing utility I should use instead of writing new code?
- Could this be simpler?
- Surface observations to the user rather than silently deciding
