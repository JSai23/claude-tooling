---
name: 8-production
description: Production readiness check
disable-model-invocation: true
context: fork
agent: validator
---
## Git Context
- Branch: !`git branch --show-current 2>/dev/null`
- Uncommitted changes: !`git status --short 2>/dev/null`

## Project Files
!`ls -la 2>/dev/null | head -20`

## Check Target
$ARGUMENTS

---

# Production Readiness Checklist

Verify each item with EVIDENCE. Don't assert - prove.

## Required Checks

### Tests
- [ ] Test suite passes - RUN the tests, show output
- [ ] No skipped tests - Search for skip markers
- [ ] Coverage is reasonable - Show coverage report if available

### Security
- [ ] No hardcoded secrets - `grep -r "password\|secret\|api_key\|token" --include="*.py" --include="*.ts" --include="*.js"`
- [ ] No debug endpoints - Search for `/debug`, `/test`, `if DEBUG`
- [ ] Input validation present - Show validation code

### Error Handling
- [ ] Errors are handled, not swallowed - Show error handling code
- [ ] User-facing errors are clear - Show error messages
- [ ] Logging present for debugging - Show log statements

### Dependencies
- [ ] Dependencies are pinned - Check requirements.txt, package.json
- [ ] No unused dependencies - Compare imports to dependency list
- [ ] No vulnerable dependencies - Run audit if available

### Documentation
- [ ] README exists and is current
- [ ] API endpoints documented
- [ ] Setup instructions work

## Output Format
```
[PASS|FAIL|SKIP] Check description
  EVIDENCE: What you did and found
  (If FAIL) ISSUE: What needs fixing
```

Return checklist with evidence. User will run /0-fix for failures.
