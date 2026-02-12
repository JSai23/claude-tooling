---
name: principles
description: Project-specific golden rules that every agent enforces. Evolves as the team learns.
user-invocable: false
---

# Principles

Golden rules that every agent enforces. These are project-specific and should be kept in sync with `docs/PRINCIPLES.md`.

## How This Skill Works

This is a template. Each project should customize this skill with its actual principles. Start small — add principles as you learn what matters for your codebase.

## Example Principles

These are starting points. Replace with your own as you discover what matters:

### Code Principles
- Write the simplest code that handles the full complex case
- No stubs, TODOs, or placeholders in production code
- Follow existing codebase patterns — consistency over personal preference
- If an abstraction has one implementation, it probably shouldn't be an abstraction

### Testing Principles
- Test behavior, not implementation
- Minimize mocking — mock only at external boundaries
- Tests that fail are information, not failures to hide

### Documentation Principles
- If it's not in the repo, it doesn't exist
- Stale docs are worse than no docs
- Every design decision gets recorded with rationale

### Process Principles
- Deviations from the plan are fine but must be explicit and recorded
- Every milestone has observable acceptance criteria
- Finding no issues is a valid outcome — don't invent problems

## Evolving Principles

Principles are updated when:
- A mistake reveals a missing rule
- A retrospective surfaces a pattern worth encoding
- A principle turns out to be wrong or unhelpful (remove it)

Keep this document short. If a principle needs more than two sentences to explain, it's probably too nuanced for a golden rule.
