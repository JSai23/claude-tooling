---
name: 9-review
description: Review the completed work
disable-model-invocation: true
context: fork
agent: auditor
---
## Recent Changes
!`git log --oneline -10 2>/dev/null`

## Diff Since Start
!`git diff main...HEAD --stat 2>/dev/null | tail -20 || git diff HEAD~10 --stat | tail -20`

## Files Changed
!`git diff main...HEAD --name-only 2>/dev/null | head -30 || git diff HEAD~10 --name-only | head -30`

## Review Target
$ARGUMENTS

---

# Code Review: Final Assessment

Review the completed work for quality and completeness.

## Review Checklist

### Does It Work?
- Does the code do what was asked?
- Are there obvious bugs?
- Have edge cases been handled?

### Is It Maintainable?
- Can someone else understand this code?
- Is it well-organized?
- Are there clear boundaries between components?

### Is It Complete?
- Are all requirements addressed?
- Is error handling complete?
- Are there loose ends or TODOs?

### What Could Be Better?
- Performance concerns?
- Security considerations?
- Simpler approaches?

## Output Format
0. **Blocking Problems**: Anything that should stop the overall task from being done.
1. **Summary**: Overall assessment (1-2 sentences)
2. **Strengths**: What was done well
3. **Issues**: Problems found (with file:line)
4. **Suggestions**: Non-critical improvements

You are reviewing only. Return assessment. User will run /0-fix if needed.
