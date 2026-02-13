---
name: verify-style
description: Code cleanliness — AI-generated slop, naming, dead code, over-engineering, simplification
user-invocable: false
---

# Code Style and Cleanliness

Line-level code quality without changing behavior.

## Slop (AI-Generated Cruft)

**Defensive code** — Try/catch around code that can't fail. Null checks on values that are never null. Fallbacks for impossible cases. Validation of internal values guaranteed by the type system.

**Over-engineering** — Abstractions for one-time operations. Interfaces with single implementations. Factory patterns for simple construction. Configuration for things that will never be configured.

**Verbosity** — Multiple lines that could be one. Intermediate variables that add nothing. Obvious comments that restate the code.

## Messy Code

**Naming** — Unclear names. Inconsistent naming across similar modules. Abbreviations that aren't obvious. Names that lie.

**Structure** — Functions doing multiple things. Files with mixed responsibilities. Duplicated logic. Complex conditionals that could be simplified.

**Dead code** — Unused imports. Unreachable branches. Functions nothing calls. Commented-out code.

## Fix Protocol

Find, fix, test. One issue at a time. If tests fail, revert and note why.

Not architecture review, not larp detection. Don't change behavior. "No issues found" is valid.
