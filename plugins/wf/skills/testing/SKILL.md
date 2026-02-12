---
name: testing
description: Knowledge for test quality assessment — what good tests look like, anti-patterns, coverage priorities
user-invocable: false
---

# Testing Standards

How to assess test quality and write tests that actually verify behavior.

## Testing Philosophy

Tests define behavior. Reading the test suite should tell you what the system does without reading the implementation.

### Test Real Behavior
- Test actual code paths, not mocked abstractions
- Minimize mocking — mock only external services at boundaries
- If you must mock, mock at the boundary, not the internals
- Tests should exercise the same code path production uses

### Coverage Priorities
1. Happy path — normal successful operation
2. Error cases — what happens when things fail
3. Edge cases — boundary conditions, empty inputs, large inputs
4. Integration — components working together

### Test Structure
```
Given: {what state exists before}
When: {what operation is performed}
Then: {what should be true after}
```

### Naming
Test names should read as behavior descriptions:
- GOOD: "returns 401 when token is expired"
- BAD: "test_auth_middleware"
- GOOD: "ignores duplicate entries without error"
- BAD: "test_dedup"

## Anti-Patterns

### Tests That Lie
- Mocking the thing being tested
- Tests that always pass regardless of implementation
- Assertions that assert nothing (`assert true`)
- Tests changed to match broken behavior

### Tests That Waste
- Testing implementation details (private methods, internal state)
- Testing that the language works (`assert 1 + 1 == 2`)
- Excessive mocking that disconnects test from reality
- Testing every getter/setter with no behavioral significance

### Tests That Mislead
- Skipped tests with eternal TODOs
- Tests with names that don't match what they test
- Test suites where failure messages don't help debug

## Test Failure Philosophy

Tests that fail are valuable information. They tell you the implementation doesn't match the expected behavior. Don't "fix" the test to match broken code — fix the code or surface the discrepancy.

Listing failing tests is better than hiding them.
