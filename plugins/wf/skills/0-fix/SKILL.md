---
name: 0-fix
description: Fix all remaining issues from audits
argument-hint: "[issue or area]"
disable-model-invocation: true
---
## Focus
$ARGUMENTS

---

Systematically fix everything outstanding.

## Process

### 1. Gather Issues
List every open issue from:
- /4-quality design concerns
- /6-larp findings
- /7.1-deslop findings
- /7.2-quality findings
- /8-review failures

### 2. Analyze Each Issue
Before fixing, understand:
- **Why was it written this way?** - The original author (probably you) had a reason
- **Is the issue real?** - Sometimes "issues" are intentional tradeoffs
- **What's the actual fix?** - Not a workaround, the real solution
- **Think in Tradeoffs** - Once you know the issue, think about the tradeoffs related to the fix and explain them to the user. If there is a clear fix just explain that if the issue is nuanced explain solutions in terms of tradeoffs.

### 3. Prioritize
- CRITICAL first (crashes, data loss)
- WARNING second (bugs, edge cases)
- SUGGESTION last (improvements)

### 4. Fix Completely
For each issue:
1. Understand the root cause
2. Implement the fix
3. Verify with actual execution (not just "looks right")
4. Run tests to check for regressions
5. Move to next issue

### 5. Don't Introduce New Issues
- Don't "fix" by adding workarounds
- Don't skip tests to make them pass
- Don't disable checks to make them green

## Rules
- One issue at a time
- Verify each fix before moving on
- If a fix creates new problems, reconsider the approach
- Don't mark complete until zero issues remain

Same standards: production code, no stubs, no TODOs.
