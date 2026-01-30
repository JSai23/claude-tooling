---
name: 7.2-quality
description: Code quality pass - naming, formatting, line-level cleanup
argument-hint: "[files or dirs]"
disable-model-invocation: true
agent: code-cleaner
---
## Target
$ARGUMENTS

---

# Code Quality: Line-Level Cleanup

Improve readability without changing behavior. Fix as you go.

## Focus Areas

### Readability
- Unclear variable and function names
- Inconsistent formatting
- Poor code organization within files
- Missing or inconsistent types

### Patterns
- DRY violations - extract repeated code
- Functions doing multiple things - split them
- Unclear interfaces between modules
- Excessive error checking

### Simplification
- Dead code - remove it
- Complex conditionals - simplify
- Clever code - make it obvious

## Process
1. Find an issue
2. Fix it
3. Run tests
4. If tests fail, revert and note why
5. Next issue

## Rules
- Don't change behavior
- Small changes, one at a time
- Test after each change
- Don't question design (that's /4-quality)

## Success Criteria
Finding nothing to improve is a valid outcome - the code is already clean. The goal is readable code, not finding problems.
