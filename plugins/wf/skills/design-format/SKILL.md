---
name: design-format
description: The design doc template, repo structure conventions, and catalogue format
user-invocable: false
---

# Design Doc Format

Design docs are first-class artifacts. They live in the repository, are updated during implementation, and are archived after completion.

## Repository Structure

```
docs/
├── designs/
│   ├── index.md                  # Catalogue of all designs
│   ├── {feature-name}/
│   │   ├── design.md             # The living design doc
│   │   └── decisions.md          # Decision log
│   └── completed/
│       └── {feature-name}/       # Archived after shipping
├── ARCHITECTURE.md               # System map (updated when system shape changes)
├── PRINCIPLES.md                 # Golden rules (updated as team learns)
└── QUALITY.md                    # Per-domain quality grades
```

## Design Doc Template

```markdown
# {Feature Name}

## Status
{draft | active | complete}

## Purpose
{What changes for the user. Observable outcomes, not implementation details.}

## Context
{Enough for a fresh session to understand the landscape.
Relevant file paths, existing patterns, constraints, prior art.}

## Approach

### Chosen: {approach name}
{Description of the approach and why it was chosen.}

### Considered: {alternative name}
{Why this wasn't chosen. What tradeoff made it less suitable.}

## Milestones

### M1: {name}
What exists after: {observable outcome}

Acceptance:
- {criterion}

Steps:
- [ ] {step}

### M2: {name}
...

## Progress
{Timestamped entries added during implementation}

## Surprises
{Unexpected discoveries during implementation}
```

## Decision Log Template (decisions.md)

```markdown
# Decisions: {Feature Name}

## [YYYY-MM-DD] {Decision Title}

Context: {What prompted this decision}
Decision: {What was decided}
Rationale: {Why — include tradeoffs considered}
Impact: {What this changes about the plan}
```

## Index Template (index.md)

```markdown
# Design Index

| Name | Status | Date | Domain |
|------|--------|------|--------|
| {name} | active | YYYY-MM-DD | {domain} |
```

## Lifecycle

1. Planner creates design doc (status: draft → active)
2. Builder updates during implementation (progress, surprises, decisions)
3. Verifier reviews the result
4. Design archived to `completed/` (status: complete)
5. Gardener checks for staleness
