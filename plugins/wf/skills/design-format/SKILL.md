---
name: design-format
description: Plan document templates — design doc format, decision log format, index format
user-invocable: false
---

# Plan Document Format

Plans are foresight artifacts. They describe bounded work with milestones, acceptance criteria, and a defined end state.

## Plan Doc Template

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
# Plan Index

| Name | Status | Date | Scope |
|------|--------|------|-------|
| {name} | active | YYYY-MM-DD | {system/package} |
```

## Lifecycle

1. Planner creates plan doc (status: draft → active)
2. Builder updates during implementation (progress, surprises, decisions)
3. Verifier writes verification.md alongside the plan
4. Plan marked complete (status: complete) — becomes historical record
5. Gardener checks for stale active plans
