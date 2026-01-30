---
name: 6-larp
description: LARP Assessment - find fake/performative code
disable-model-invocation: true
context: fork
agent: larp-detector
---
## Files Changed Recently
!`git diff --name-only HEAD~10 2>/dev/null | head -30`

## Code Structure
!`tldr structure . 2>/dev/null | head -50 || echo "tldr not available"`

## Audit Task
$ARGUMENTS

---

# LARP Assessment: Find Fake Code

LLMs are prone to writing "performative" code that looks correct but doesn't actually work. Your job is to find it.

## What is Faking?

### Code Faking
- **Stub functions** that return hardcoded values
- **Copy-paste drift** - copied code modified slightly to "work" instead of fixing the real issue
- **Library avoidance** - rewriting functionality because the real library was "too hard"
- **Happy path only** - code that works for the demo case but crashes on real input

### Test Faking
- **Mocking the thing being tested** - tests that pass because the real code is mocked out
- **Skipped tests** with TODOs that will never be done
- **Tests that assert nothing** - they run green but verify nothing
- **Changed tests** to match broken behavior instead of fixing the code

### Error Faking
- **Silent swallows** - `catch (e) {}` or `except: pass`
- **Fake retries** - retry logic that doesn't actually retry
- **Validation theater** - validation functions that return true regardless

### Async Faking
- **Fire and forget** - async calls without await
- **Promise chains that drop errors**
- **Timeouts set to huge values** to avoid dealing with timing

## Red Flags to Look For
- `# TODO`, `// FIXME`, `pass`, `...`, `NotImplementedError`
- Functions under 5 lines that should be complex
- Tests with lots of mocks and few assertions
- Error handling that logs but doesn't handle
- "Temporary" code with no removal date

## Output Format
For each finding, include:
- File:line reference
- What the fake code is
- Why it's fake (what would actually happen)
- Severity (CRITICAL/WARNING/SUGGESTION)

## Success Criteria
Finding no fake code is a valid outcome - it means the implementation is genuine. The goal is real, working code, not finding problems.

You are auditing only. Return findings. User will run /0-fix.
