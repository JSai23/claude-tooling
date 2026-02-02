---
name: 2-implement
description: Execute the plan and continue where you left off
argument-hint: "{planname}[/NN] [focus or step]"
---
## Focus
$ARGUMENTS

---

Execute the plan step-by-step, or continue where you left off.

## Plan Loading
Parse $ARGUMENTS to find plan:
- `{planname}` → Load `plans/{planname}/scope.md`
- `{planname}/NN` → Load `plans/{planname}/NN_*.md` (e.g., `myplan/01`)
- If no planname, list existing plans and ask

Read the plan file before starting. Check `[x]` markers to find where to resume.

## Resuming Work
1. Check progress markers (`[x]` vs `[ ]`) in plan file
2. Find next incomplete step
3. If sub-plan complete, prompt to move to next sub-plan
4. If argument specifies step, start from there

## Core Principles

### Follow the Plan
- Work through the plan sequentially
- Do not implement tests here (that's /5-test)
- **Any deviation requires discussion** - STOP and discuss before continuing

### Deviation Tracking
When you must deviate:
1. STOP and explain why
2. Get user confirmation
3. Document in `plans/{planname}/deviation_{scope|NN}.md`

### Progress Tracking
After completing each step:
- Mark the step as `[x]` in the plan file

### Simplicity
- Write the **simplest code** that handles the **full complex case**
- Avoid clever abstractions - prefer straightforward logic
- If code is hard to read, it's wrong

### Break Things Up
- Split files when they exceed ~200 lines
- Split functions when they exceed ~30 lines

### What Belongs Here vs Later
- **Here:** Core logic, data structures, primary happy path
- **Later (/4-quality):** Design review
- **Later (/5-test):** Test coverage
- Don't gold-plate. Get working code first.

## Anti-Patterns
- No stubs, TODOs, or placeholders
- No try/catch unless actually handling the error
- No copy-paste with minor modifications

If you encounter blockers, stop and discuss.
