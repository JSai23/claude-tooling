---
name: logging-a
type: action
description: Log decisions, progress, deviations, and discoveries during any workflow phase
argument-hint: "[type: decision|progress|surprise|deviation]"
---

> **Action skill** — Structured logging: decisions, progress, deviations, discoveries.

## Log Entry
$ARGUMENTS

---

Record a structured log entry in the active plan doc or decision log.

## Log Types

### Decision (`decision`)
Record a decision with rationale in `design-docs/plans/{name}/{name}_decisions.md`:

```markdown
## [YYYY-MM-DD] {Decision Title}

Context: {What prompted this decision}
Decision: {What was decided}
Rationale: {Why — include tradeoffs considered}
Impact: {What this changes about the plan or system}
```

### Progress (`progress`)
Add a timestamped entry to the Progress section of the active plan doc:

```markdown
- [YYYY-MM-DD HH:MM] {What was completed or what state we're in}
```

### Surprise (`surprise`)
Record an unexpected discovery in the Surprises section of the active plan doc:

```markdown
### [YYYY-MM-DD] {What was surprising}
Expected: {What we thought would happen}
Actual: {What actually happened}
Implication: {How this affects the plan or approach}
```

### Deviation (`deviation`)
Record a deviation from the plan. Adds to both the decision log and the plan doc:

```markdown
## [YYYY-MM-DD] Deviation: {title}

Original plan: {What the plan doc said}
Actual approach: {What we're doing instead}
Reason: {Why the change was necessary}
Impact: {Effect on remaining milestones}
```

## Process

1. Determine which plan is active (scan `design-docs/plans/` for active plans or locate the active plan in the relevant scope)
2. Determine log type from arguments or ask
3. Gather the relevant information
4. Write the entry to the correct location
5. Confirm what was logged
