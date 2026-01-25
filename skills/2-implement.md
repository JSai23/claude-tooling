---
name: 2-implement
description: Execute the agreed plan with real code
disable-model-invocation: true
---
Execute the agreed plan step-by-step.

## Core Principles

### Follow the Plan
- Work through the plan sequentially
- **Any deviation requires discussion** - if the plan doesn't cover something, or you're unclear, STOP and discuss before continuing
- Note deviations explicitly when they occur

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
