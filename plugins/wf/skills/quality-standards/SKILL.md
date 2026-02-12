---
name: quality-standards
description: Knowledge for quality verification — grading criteria, review dimensions, finding categorization
user-invocable: false
---

# Quality Standards

How to assess and score code quality across multiple dimensions.

## Verification Dimensions

### Design Quality (design-auditor)
- Are abstractions earning their complexity?
- Are dependencies pointing the right direction?
- Are module boundaries in the right places?
- Is there hidden coupling?

### Code Integrity (larp-detector)
- Is the code genuine or performative?
- Do tests actually verify behavior?
- Does error handling actually handle errors?
- Are there stubs or hardcoded values pretending to be real?

### Code Cleanliness (code-cleaner)
- Is there unnecessary defensive code?
- Are there over-engineered abstractions?
- Is naming clear and consistent?
- Is there dead code?

### Production Readiness (production-reviewer)
- Do tests pass?
- Are there hardcoded secrets?
- Are errors handled appropriately?
- Are dependencies pinned?

## Finding Severity

### Critical (must fix)
- Crashes, data loss, security vulnerabilities
- Fake code that will fail in production
- Missing error handling for common failure modes

### Warning (should fix)
- Design issues that will cause problems at scale
- Inconsistencies that will confuse future sessions
- Tests that don't actually verify behavior

### Suggestion (consider)
- Readability improvements
- Minor naming inconsistencies
- Opportunities for simplification

## Quality Scoring

Track quality per domain/area in `docs/QUALITY.md`:

```markdown
# Quality Scores

| Domain | Grade | Last Reviewed | Notes |
|--------|-------|---------------|-------|
| auth   | B     | 2025-01-15    | Solid design, minor naming issues |
| api    | A     | 2025-01-15    | Clean and well-tested |
```

Grades:
- **A**: Clean, well-tested, good design. No critical or warning findings.
- **B**: Mostly clean. Minor warnings, no criticals.
- **C**: Functional but has warnings that should be addressed.
- **D**: Has critical issues or significant design concerns.
- **F**: Fake code, missing tests, or fundamental design problems.

## Rules

- Finding no issues is valid. Don't invent problems.
- Be specific. Every finding needs path, line, description.
- Distinguish severity honestly. Not everything is critical.
