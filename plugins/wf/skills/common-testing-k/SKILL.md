---
name: common-testing-k
type: knowledge
description: Testing philosophy — what good tests look like, anti-patterns, coverage priorities, naming
user-invocable: false
---

> **Knowledge skill** — Testing philosophy, coverage priorities, naming conventions, anti-patterns.

# Testing Standards

Tests define behavior. Reading the test suite should tell you what the system does without reading the implementation.

## Philosophy

- Test actual code paths, not mocked abstractions
- Minimize mocking — mock only external services at boundaries
- Tests should exercise the same code path production uses
- Tests that fail are valuable information — don't "fix" the test to match broken code

## Coverage Priorities

1. Happy path — normal successful operation
2. Error cases — what happens when things fail
3. Edge cases — boundary conditions, empty inputs, large inputs
4. Integration — components working together

## Structure and Naming

Given/When/Then structure. Names read as behavior descriptions:
- GOOD: "returns 401 when token is expired"
- BAD: "test_auth_middleware"

## Anti-Patterns

**Tests that lie** — mocking the thing being tested, assertions that assert nothing, tests changed to match broken behavior.

**Tests that waste** — testing implementation details, testing that the language works, excessive mocking that disconnects from reality.

**Tests that mislead** — skipped tests with eternal TODOs, names that don't match what they test, failure messages that don't help debug.
