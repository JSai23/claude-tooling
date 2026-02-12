---
name: doc-standards
description: Knowledge for documentation maintenance — freshness criteria, cross-linking, what well-maintained docs look like
user-invocable: false
---

# Documentation Standards

What well-maintained documentation looks like and how to keep it that way.

## Core Principle

From an agent's perspective, anything not in the repository doesn't exist. Stale docs are worse than no docs — they actively mislead future sessions.

## Documentation Health Criteria

### Freshness
A doc is stale when:
- It describes behavior the code no longer implements
- It references files, modules, or functions that no longer exist
- Its examples don't work
- Its architecture diagrams don't match the current system shape

### Completeness
A doc is incomplete when:
- Active designs are missing from `docs/designs/index.md`
- `docs/ARCHITECTURE.md` doesn't cover a major system component
- Design docs are missing decision logs for significant decisions
- Quality scores haven't been updated after recent changes

### Cross-Linking
Documents should reference each other:
- Design docs link to the relevant architecture sections
- Architecture map references active designs that modify it
- Quality scores reference the verification that produced them
- Principles reference the design decisions that inspired them

## What to Check

### Design Index (`docs/designs/index.md`)
- Every active design has an entry
- No entries for designs that don't exist
- Status field is accurate (active/complete)

### Architecture (`docs/ARCHITECTURE.md`)
- Reflects actual system shape
- Module/service names match real code
- Dependency directions are accurate

### Quality Scores (`docs/QUALITY.md`)
- Scores reflect recent verification results
- No domains missing that have been built
- Last reviewed dates are reasonable

### Active Designs
- All milestones marked complete should be archived to `completed/`
- Progress sections should be current
- No orphaned decision logs

## Cleanup Priority

1. Things that will mislead future agent sessions (highest)
2. Things that have drifted enough to cause confusion
3. Quick wins (stale entries, dead links)
4. Cosmetic improvements (lowest)
