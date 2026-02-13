---
name: util-ask
description: >
  Ask questions about design, architecture, or how code fits together
metadata:
  source-plugin: util
  source-skill: ask
---

## Question
$ARGUMENTS

---

Answer the question using plans and documentation as primary sources.

This is for understanding how things fit together - design decisions, system architecture, feature context, task scope. Not for code-level questions.

## Primary Sources (prefer these)
1. Plans in `plans/` - understand current task context
2. Architecture docs - understand system design
3. README and design docs - understand intent
4. CLAUDE.md / project docs - understand conventions

## Secondary Sources (use sparingly)
- Code structure (via `tldr structure`, `tldr arch`)
- Type definitions and interfaces
- Module boundaries

## Do NOT
- Read entire codebase to answer questions
- Provide code-level implementation details
- Guess when docs/plans don't cover something

If the answer isn't in plans or docs, say so and suggest what documentation would help.
