---
name: common-doc-audit-k
type: knowledge
description: Documentation health verification — freshness, accuracy, cross-linking, diagram drift
user-invocable: false
---

> **Knowledge skill** — Doc health: what to check, how to prioritize, verifier vs gardener scope.

# Documentation Health

Stale docs actively mislead. From an agent's perspective, anything not in the repo doesn't exist — and anything in the repo that's wrong is worse than nothing.

## Two Scopes

**Verifier** — runs post-build as part of the main loop. Checks: did the builder do its doc duty? Do living docs match what was just built? Are diagrams current? Is ARCHITECTURE.md updated?

**Gardener** — runs anytime, broader scope. Checks: does the entire `design-docs/` tree accurately represent the system? Have things drifted since last audit? Are there orphans, broken links, stale plans?

Same checklist, different aperture.

## What to Check

```
Check                        │ What "wrong" looks like
─────────────────────────────┼──────────────────────────────────────
Diagram accuracy             │ Class diagram missing new fields/methods
                             │ Data flow doesn't match actual flow
                             │ Component diagram has removed modules
─────────────────────────────┼──────────────────────────────────────
ARCHITECTURE.md              │ Doesn't cover new components
                             │ Module names don't match code
                             │ Dependency directions wrong
─────────────────────────────┼──────────────────────────────────────
Living doc freshness         │ Describes old behavior
                             │ References files that don't exist
                             │ Examples don't work
─────────────────────────────┼──────────────────────────────────────
Plan status                  │ Completed plans still marked active
                             │ Progress sections not updated
                             │ Missing decision logs
─────────────────────────────┼──────────────────────────────────────
Cross-links                  │ Plans don't link to architecture
                             │ Living docs not in ARCHITECTURE.md
                             │ Plans missing from index
─────────────────────────────┼──────────────────────────────────────
Coverage                     │ Components built without living docs
                             │ Major modules undocumented
                             │ New APIs without integration docs
```

## Priority

1. **Actively misleading** — docs that will cause the next agent to make wrong decisions
2. **Drifted** — docs that are stale enough to confuse but not dangerously wrong
3. **Missing** — gaps where docs should exist but don't
4. **Cosmetic** — formatting, naming, minor cross-link fixes
