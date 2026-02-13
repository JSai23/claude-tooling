---
name: design-format
description: Plan document conventions — frontmatter, structure expectations, decision log format, lifecycle
user-invocable: false
---

# Plan Document Conventions

Plans are foresight artifacts. They describe bounded work with milestones, acceptance criteria, and a defined end state.

## Plan Doc (`plan.md`)

Frontmatter:
```yaml
---
status: draft | active | complete
created: YYYY-MM-DD
updated: YYYY-MM-DD
scope: system | package-name
parent: parent-plan-name    # if nested
---
```

A plan doc should cover:
- **Purpose** — observable outcomes, not implementation details
- **Context** — enough for a fresh session to understand the landscape
- **Approach** — what was chosen, what was considered, why
- **Milestones** — self-contained, observable, ordered by risk, with acceptance criteria and checkboxes
- **Progress** — timestamped entries added during implementation
- **Surprises** — unexpected discoveries

How much of this to include depends on scope. A small fix needs a paragraph. A system redesign needs all of it. Match ceremony to risk.

## Decision Log (`decisions.md`)

Frontmatter:
```yaml
---
plan: plan-name
created: YYYY-MM-DD
---
```

Each entry captures: what prompted the decision, what was decided, why, and what it changes. Use `[YYYY-MM-DD]` headers for each entry. Deviations from the plan are logged here with the original plan, actual approach, reason, and impact on remaining work.

## Plan Index (`index.md`)

A table cataloguing all plans with name, status, date, and scope. Kept at `design-docs/plans/index.md`. Gardener maintains accuracy.

## Lifecycle

1. Planner creates (status: draft → active)
2. Builder updates during implementation (progress, surprises, decisions)
3. Verifier writes verification.md alongside the plan
4. Plan marked complete — becomes historical record
5. Gardener checks for stale active plans
