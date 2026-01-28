---
name: 7-deslop
description: Clean up AI slop - remove cruft and unnecessary code
argument-hint: "[files or dirs]"
disable-model-invocation: true
---
## Target
$ARGUMENTS

---

Remove AI-generated cruft from the codebase.

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
- Any comments with emojis or non-text decoration
- Comments that state things that logically if the code were better written would be obvious

## Process
1. Scan for slop patterns
2. Remove each piece
3. Run tests after each removal
4. If tests fail, the "slop" was actually needed - restore it

This is fast, surgical cleanup. Don't refactor - just remove obvious cruft. This is the place where you just simplify what obviously can be simplified and try to get the LOC to drop.
