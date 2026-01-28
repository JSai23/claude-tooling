---
name: 2-implement
description: Execute the agreed plan with real code
argument-hint: "{planname}[/NN] [focus]"
disable-model-invocation: true
---
## Existing Plans
!`ls -d plans/*/ 2>/dev/null | while read d; do echo "- $(basename $d)"; done || echo "No plans yet - run /1-plan first"`

## Focus
$ARGUMENTS

---

Execute the agreed plan step-by-step.

## Plan Loading
Parse $ARGUMENTS to find plan:
- `{planname}` → Load `plans/{planname}/scope.md`
- `{planname}/NN` → Load `plans/{planname}/NN_*.md` (e.g., `myplan/01`)
- If no planname, list existing plans and ask

Read the plan file before starting implementation.

## Plan Dump
If the plan document from plan mode hasn't been saved to disk yet, save it first:
- Master plan → `plans/{planname}/scope.md`
- Sub-plan → `plans/{planname}/NN_{name}.md` (next available number)
- Create directory: `mkdir -p plans/{planname}`

Determine master vs sub-plan from the user's `/1-plan` invocation (did they use `--sub` or not).

## Core Principles

### Follow the Plan
- Work through the plan sequentially
- **Any deviation requires discussion** - if the plan doesn't cover something, or you're unclear, STOP and discuss before continuing
- Note deviations explicitly when they occur

### Deviation Tracking
When you must deviate from the plan:
1. STOP and explain why deviation is needed
2. Get user confirmation
3. Document in `plans/{planname}/deviation_{scope|NN}.md`:
```markdown
## [YYYY-MM-DD] Deviation: {title}

### Original Plan
{what the plan said}

### Actual Implementation
{what you did instead}

### Reason
{why the change was necessary}

### Impact
{effect on other sub-plans, if any}
```

### Progress Tracking
After completing each step:
- Mark the step as `[x]` in the plan file
- This allows `/3-continue` to see progress

### Simplicity in Complexity
- Write the **simplest code** that handles the **full complex case**
- Avoid clever abstractions - prefer straightforward logic
- If code is hard to read, it's wrong, so use descriptive names for functions, variables, classes etc

### Break Things Up
- **Big is bad** - large files, large functions, large commits
- Split files when they exceed ~200 lines
- Split functions when they exceed ~30 lines
- Split problems into smaller, testable pieces

### What Belongs Here vs Later
- **Here (implement):** Core logic, data structures, primary happy path
- **Later (/4-quality):** Refactoring, naming improvements, pattern cleanup
- **Later (/5-test):** Test coverage, edge case tests
- Don't gold-plate. Get working code first.

## Anti-Patterns to Avoid
- No stubs, TODOs, or placeholders
- No try/catch unless actually handling the error
- No "we'll fix this later" comments
- No copy-paste with minor modifications

If you encounter blockers, stop and discuss. Don't work around problems silently.
