---
name: verify-quality
description: Quality verification framework — dimensions, severity levels, grading criteria
user-invocable: false
---

# Quality Standards

## Verification Dimensions

**Design quality** — Are abstractions earning their complexity? Dependencies pointing right? Module boundaries in the right places? Hidden coupling?

**Code integrity** — Is the code genuine or performative? Do tests verify real behavior? Does error handling actually handle errors?

**Code cleanliness** — Unnecessary defensive code? Over-engineered abstractions? Clear naming? Dead code?

**Production readiness** — Tests pass? No hardcoded secrets? Errors handled? Dependencies pinned?

## Finding Severity

**Critical** (must fix) — Crashes, data loss, security vulnerabilities. Fake code that will fail in production. Missing error handling for common failure modes.

**Warning** (should fix) — Design issues that will cause problems at scale. Inconsistencies that will confuse future sessions. Tests that don't verify real behavior.

**Suggestion** (consider) — Readability improvements. Minor naming inconsistencies. Simplification opportunities.

## Grading

- **A**: Clean, well-tested, good design. No critical or warning findings.
- **B**: Mostly clean. Minor warnings, no criticals.
- **C**: Functional but has warnings that should be addressed.
- **D**: Has critical issues or significant design concerns.
- **F**: Fake code, missing tests, or fundamental design problems.

Finding no issues is valid. Don't invent problems. Be specific — every finding needs path, line, description.

## Production Readiness Checks

Every check follows: state what you're checking, run the actual command, show the output, render verdict with evidence.

- **Functionality**: Tests pass (run them), no skipped tests, critical paths traced
- **Security**: No hardcoded secrets (grep for password/secret/api_key/token), no debug endpoints, input validation present
- **Stability**: Errors handled not swallowed, no silent failures, appropriate logging
- **Dependencies**: Pinned versions, lock files present, audit for known vulnerabilities

## Output Format

```
### [PASS|FAIL] {Check name}
COMMAND: what you ran
OUTPUT: what you saw
VERDICT: Pass/Fail — brief reason
```

Overall verdict: READY or NOT READY. Don't pass checks you didn't actually run.
