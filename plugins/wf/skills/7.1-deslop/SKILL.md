---
name: 7.1-deslop
description: Clean up AI slop - remove cruft and unnecessary code
argument-hint: "[files or dirs]"
disable-model-invocation: true
agent: code-cleaner
---
## Target
$ARGUMENTS

---

# Deslop: Remove AI-Generated Cruft

Clean up unnecessary code. Fix as you go.

## What is Slop?

### Defensive Code
- Try/catch around code that can't fail
- Null checks on values that are never null
- Type assertions that are always true
- Fallbacks for impossible cases

### Over-Engineering
- Abstractions for one-time operations
- Interfaces with single implementations
- Factory patterns for simple construction
- Dependency injection for things that never change

### Verbosity
- Multiple lines that could be one
- Intermediate variables that add nothing
- Repeated code that could be a loop

### Comments
- Obvious comments (`// increment i`)
- Comments that repeat the code
- Outdated comments that don't match code
- Overly verbose docstrings on simple functions
- Any comments with emojis

## Process
1. Find slop
2. Remove it
3. Run tests
4. If tests fail, restore it and note why
5. Next issue

## Success Criteria
Finding no slop is a valid outcome - the code is already clean. The goal is cruft-free code, not finding problems.
