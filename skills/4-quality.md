---
name: 4-quality
description: Code quality pass - refactoring and cleanup
argument-hint: "[files or dirs]"
disable-model-invocation: true
---
## Target
$ARGUMENTS

---

Improve code quality without changing behavior. The code should feel simpler and more understandeable after this. This comes first so to remove noise from further clean up, testing etc.

## Focus Areas

### Readability
- Clear variable and function names
- Consistent formatting
- Logical code organization
- Strongly type all code and reuse types as much as possible - types tell stories

### Patterns
- DRY - extract repeated code (but don't over-abstract)
- Single responsibility - one function, one job
- Clear interfaces between modules
- Remove fallbacks, excessive error checking and type checking

### Simplification
- Remove dead code
- Simplify complex conditionals
- Replace clever code with obvious code

## Rules
- **Don't change behavior** - this is refactoring, not feature work
- **Run tests after each change** - ensure nothing breaks
- **Small commits** - each refactor should be one logical change

If you find a bug during refactoring, note it and continue. Don't fix bugs here - that's for /0-fix. The reasoning for that is we must verify bugs and be sure of them before we start changing code. If you are unsure about a quality related decision ask.
