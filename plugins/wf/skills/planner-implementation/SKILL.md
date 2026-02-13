---
name: planner-implementation
description: How to break design into executable milestones — sequencing, acceptance criteria, risk ordering
user-invocable: false
---

# Implementation Planning

How to take a design and break it into work a builder can execute.

## Milestone Design

Each milestone must be:

**Self-contained** — produces something observable. Doesn't require later milestones to be verifiable. Can be committed independently.

**Observable** — acceptance criteria describe what a human can verify:
- GOOD: "GET /users returns a JSON array of user objects"
- BAD: "User service is implemented"

**Risk-ordered** — front-load the riskiest, most uncertain milestones. Get the hard parts working first.

**Right-sized** — 30 minutes to 2 hours of implementation work. Too small is tracking overhead, too large is working blind.

## Sequencing Questions

- What's the riskiest part? Can we prove it works in M1?
- If we stopped after milestone N, would we have something useful?
- Are any milestones dependent on each other in ways not captured?
- What's the rollback plan if a milestone fails?

## Implementation Details

Implementation-level detail normally belongs at the lowest plan level. For nested plans, the parent defines vision and ordering — child plans define the concrete steps and code structure.

For small features, design and implementation may combine into a single document. For larger efforts, separate the system design plan from per-component implementation plans.
