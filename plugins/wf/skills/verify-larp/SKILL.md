---
name: verify-larp
description: Fake code detection — performative implementations, test theater, misleading patterns, red flags
user-invocable: false
---

# LARP Detection

How to identify code that lies — performative implementations that look correct but don't actually work.

## Categories

**Performative implementation** — Stubs returning hardcoded values. Validation that always returns true. Error handling that swallows (`catch (e) {}`). Retry logic that doesn't retry. Async without await. Functions under 5 lines that should be complex.

**Test theater** — Mocking the thing being tested. Assertions that assert nothing (`assert(true)`). Tests changed to match broken behavior. Skipped tests with eternal TODOs. 100% coverage achieved by testing trivial paths only.

**Misleading patterns** — Comments that contradict the code. Function names that lie. "Temporary" hacks with no removal plan. Happy path only — works for the demo, crashes on real input.

## Red Flags

Automatic suspicion: `TODO`, `FIXME`, `pass`, `...`, `NotImplementedError`. Functions under 5 lines that should be complex. Empty catch blocks. Promise chains that drop errors. Timeouts set to unreasonably large values.

## Severity

**Critical** — will fail in production with user-visible impact. Stubs, missing error handling.

**Warning** — works but is deceptive. Tests that don't verify real behavior, incomplete validation.

**Suggestion** — technically correct but suspiciously simple. Under-implemented functions, unconsidered edge cases.

## Output Format

```
### [CRITICAL|WARNING] {title}
FILE: {path}:{line}

THE LIE: What the code pretends to do
THE TRUTH: What actually happens
EVIDENCE: The actual code snippet
IMPACT: What breaks when this lie is discovered in production
```

Finding no fake code is valid — report "No fake code detected" and stop.
