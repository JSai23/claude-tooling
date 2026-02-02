---
name: 8-review
description: Final review - high-level alignment and production readiness
---
## Review Target
$ARGUMENTS

---

# Final Review: Alignment + Production Readiness

Two goals: verify high-level understanding alignment, then check production readiness.

## Part 1: High-Level Alignment (Primary Focus)

Ask the user questions to verify your understanding of the big picture.

Use diagrams and visuals to test understanding - they reveal misalignment faster than words.

### Architecture Questions (use diagrams)
```
"Does this architecture match your vision?

┌─────────────────────────────────────┐
│              API Layer              │
├─────────────────────────────────────┤
│  ┌─────────┐  ┌─────────┐          │
│  │ Service │  │ Service │          │
│  │    A    │  │    B    │          │
│  └────┬────┘  └────┬────┘          │
│       └──────┬─────┘               │
│              v                      │
│       ┌─────────────┐              │
│       │  Data Layer │              │
│       └─────────────┘              │
└─────────────────────────────────────┘
"
```

### System Fit Questions (use flow diagrams)
```
"Is this how the change fits into the existing system?

[Existing Code] ──> [NEW: Your Change] ──> [Existing Code]
       │                    │
       v                    v
   [Shared DB]         [Shared DB]
"
```

### Design Decision Questions (use comparisons)
```
"I chose Option A over Option B:

Option A (chosen):     Option B (rejected):
[X] ─> [Y] ─> [Z]      [X] ─> [YZ combined]

Reason: Separation of concerns

Do you agree with this tradeoff?
"
```

### Question Density (per cycle)
- 3-5 architecture questions
- 2-3 system fit questions
- 2-3 design decision questions

Use AskUserQuestion tool for each group.

### This is a Cycle

Keep asking until alignment is confirmed:

1. Ask questions
2. Listen to answers
3. If corrected → ask follow-up questions about the correction
4. **Repeat until no more surprises**

Stop when answers confirm understanding. Keep going when answers reveal gaps.

## Part 2: Production Readiness (Secondary)

Quick checks after alignment is confirmed:

- [ ] Tests pass
- [ ] No hardcoded secrets
- [ ] Errors handled appropriately
- [ ] No TODOs or loose ends

## Output Format

```
## Alignment Summary
- Architecture: {confirmed | needs correction}
- System Fit: {confirmed | needs correction}
- Design Decisions: {confirmed | needs correction}

## Corrections Needed
{list any misalignments discovered}

## Production Readiness
[PASS|FAIL] {quick summary}

## Ready to Ship?
{yes | no - with reason}
```

## Success Criteria
Full alignment and all checks passing is the goal. Keep cycling questions until you get there. Questions reveal understanding, not problems.
