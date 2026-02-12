---
name: code-style
description: Knowledge for code style and cleanliness review — slop detection, naming, formatting, dead code, simplification
user-invocable: false
---

# Code Style and Cleanliness

How to evaluate and fix line-level code quality without changing behavior.

## What is Slop (AI-Generated Cruft)

### Defensive Code
- Try/catch around code that can't fail
- Null checks on values that are never null
- Type assertions that are always true
- Fallbacks for impossible cases
- Validation of internal values that are guaranteed by the type system

### Over-Engineering
- Abstractions for one-time operations
- Interfaces with single implementations
- Factory patterns for simple construction
- Dependency injection for things that never change
- Configuration for things that will never be configured

### Verbosity
- Multiple lines that could be one
- Intermediate variables that add nothing
- Repeated code that could be a loop or extracted function
- Obvious comments that restate the code (`// increment i`)

## What is Messy Code

### Naming
- Unclear variable and function names
- Inconsistent naming across similar modules
- Abbreviations that aren't obvious
- Names that lie about what they contain

### Structure
- Functions doing multiple things
- Files with mixed responsibilities
- Duplicated logic across files
- Complex conditionals that could be simplified or extracted

### Dead Code
- Unused imports
- Unreachable branches
- Functions nothing calls
- Commented-out code

## Fix Protocol

1. Find an issue
2. Fix it
3. Run tests
4. If tests pass — move on
5. If tests fail — revert, note why it couldn't be fixed

Small changes. One at a time. Test after each.

## What Code Style Is NOT

- Not architecture review (don't question module boundaries)
- Not larp detection (don't hunt for fake code)
- Don't change behavior
- "No issues found" is a valid outcome
