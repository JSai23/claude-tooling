---
name: doc-standards
description: Knowledge for documentation maintenance — freshness criteria, cross-linking, what well-maintained docs look like
user-invocable: false
---

# Documentation Standards

What well-maintained agent docs look like and how to keep them that way.

## Core Principle

From an agent's perspective, anything not in the repository doesn't exist. Stale docs are worse than no docs — they actively mislead future sessions.

## Health Criteria

### Freshness
A doc is stale when:
- It describes behavior the code no longer implements
- It references files, modules, or functions that no longer exist
- Its examples don't work
- Its diagrams don't match the current system shape

### Completeness
Agent docs are incomplete when:
- Active plans are missing from `docs/plans/index.md`
- `docs/ARCHITECTURE.md` doesn't cover a major system component
- Plans are missing decision logs for significant decisions
- A component was built or significantly changed but has no living doc

### Cross-Linking
Documents should reference each other:
- Plans link to relevant architecture sections
- ARCHITECTURE.md references active plans that modify it
- Living docs link to the plans that created them
- Principles reference the decisions that inspired them

## What to Check

### Plan Index (`docs/plans/index.md`)
- Every active plan has an entry
- No entries for plans that don't exist
- Status field is accurate (draft/active/complete)

### Architecture (`docs/ARCHITECTURE.md`)
- Reflects actual system shape
- Module/service names match real code
- Dependency directions are accurate
- Links to deeper living docs where they exist

### Living Docs
- Describe the current system, not a past version
- Live near what they describe (locality principle)
- Are referenced from ARCHITECTURE.md when system-level

### Active Plans
- Plans with all milestones complete should be marked complete
- Progress sections should be current
- No orphaned decision logs

## Cleanup Priority

1. Things that will mislead future agent sessions (highest)
2. Things that have drifted enough to cause confusion
3. Quick wins (stale entries, dead links)
4. Cosmetic improvements (lowest)
