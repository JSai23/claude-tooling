---
name: logging
description: Log decisions, progress, deviations, and discoveries during any workflow phase
argument-hint: "[type: decision|progress|surprise|deviation]"
---

## Log Entry
$ARGUMENTS

---

Record a structured log entry in the active design doc or decision log.

## Log Types

### Decision (`decision`)
Record a decision with rationale in `docs/designs/{name}/decisions.md`:

```markdown
## [YYYY-MM-DD] {Decision Title}

Context: {What prompted this decision}
Decision: {What was decided}
Rationale: {Why — include tradeoffs considered}
Impact: {What this changes about the plan or system}
```

### Progress (`progress`)
Add a timestamped entry to the Progress section of the active design doc:

```markdown
- [YYYY-MM-DD HH:MM] {What was completed or what state we're in}
```

### Surprise (`surprise`)
Record an unexpected discovery in the Surprises section of the active design doc:

```markdown
### [YYYY-MM-DD] {What was surprising}
Expected: {What we thought would happen}
Actual: {What actually happened}
Implication: {How this affects the plan or approach}
```

### Deviation (`deviation`)
Record a deviation from the plan. Adds to both the decision log and the design doc:

```markdown
## [YYYY-MM-DD] Deviation: {title}

Original plan: {What the design doc said}
Actual approach: {What we're doing instead}
Reason: {Why the change was necessary}
Impact: {Effect on remaining milestones}
```

## Process

1. Determine which design doc is active (check `docs/designs/index.md`)
2. Determine log type from arguments or ask
3. Gather the relevant information
4. Write the entry to the correct location
5. Confirm what was logged

## No Active Design?

If there's no active design doc, create a standalone log at `docs/log.md`. This captures decisions and discoveries that happen outside the formal design workflow.
