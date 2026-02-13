---
name: gardener-standards
description: Documentation health — freshness criteria, completeness checks, cross-linking, cleanup priorities
user-invocable: false
---

# Documentation Standards

What well-maintained agent docs look like and how to keep them that way.

## Core Principle

From an agent's perspective, anything not in the repository doesn't exist. Stale docs actively mislead future sessions.

## Health Criteria

**Freshness** — stale when: describes behavior code no longer implements, references files that don't exist, examples don't work, diagrams don't match reality.

**Completeness** — incomplete when: active plans missing from index, ARCHITECTURE.md doesn't cover major components, plans missing decision logs, components built without living docs.

**Cross-linking** — plans link to architecture, ARCHITECTURE.md references active plans, living docs link to the plans that created them, principles reference inspiring decisions.

## What to Check

- Plan index: every active plan has an entry, no phantom entries, accurate statuses
- ARCHITECTURE.md: reflects actual system, module names match code, dependency directions accurate
- Living docs: describe current system, live near what they describe, referenced from ARCHITECTURE.md
- Active plans: completed ones should be marked complete, progress sections current

## Cleanup Priority

1. Things that mislead future agent sessions (highest)
2. Things that have drifted enough to cause confusion
3. Quick wins (stale entries, dead links)
4. Cosmetic improvements (lowest)
