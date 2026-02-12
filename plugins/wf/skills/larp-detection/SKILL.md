---
name: larp-detection
description: Knowledge for identifying fake/performative code — what to look for, red flags, severity assessment
user-invocable: false
---

# LARP Detection

How to identify code that lies — performative implementations that look correct but don't actually work.

## Categories of Fake Code

### Performative Implementation
- Stub functions returning hardcoded values
- Validation that always returns true
- Error handling that swallows and ignores (`catch (e) {}`, `except: pass`)
- Retry logic that doesn't actually retry
- Async calls without await
- Copy-paste with cosmetic changes pretending to be a real implementation
- Functions under 5 lines that should be complex

### Test Theater
- Mocking the thing being tested
- Assertions that assert nothing meaningful (`assert(true)`)
- Tests changed to match broken behavior instead of fixing the code
- Skipped tests with eternal TODOs
- Tests with lots of mocks and few assertions
- 100% coverage achieved by testing trivial paths only

### Misleading Patterns
- Comments that contradict the code
- Function names that lie about what they do
- "Temporary" hacks with no removal plan
- Library avoidance — rewriting functionality because the real library was "too hard"
- Happy path only — works for the demo, crashes on real input

## Red Flags

Automatic suspicion triggers:
- `TODO`, `FIXME`, `pass`, `...`, `NotImplementedError`
- Functions under 5 lines that should be complex
- Error handling that logs but doesn't handle
- `catch` blocks that are empty or only log
- Promise chains that drop errors
- Timeouts set to unreasonably large values

## Severity Assessment

**Critical**: Code that will fail in production and cause user-visible impact. Stubs returning hardcoded values, missing error handling for common failure modes.

**Warning**: Code that works but is deceptive. Tests that don't verify real behavior, validation that's incomplete, retry logic that doesn't cover real failure cases.

**Suggestion**: Code that's technically correct but suspiciously simple. Functions that seem under-implemented, edge cases not considered.
