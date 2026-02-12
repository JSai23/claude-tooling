---
name: implementation-plan
description: Knowledge for breaking designs into executable milestones with observable acceptance criteria
user-invocable: false
---

# Implementation Planning

How to break a design into milestones that a builder can execute.

## Milestone Design

Each milestone must be:

### Self-Contained
- Produces something observable after completion
- Doesn't require later milestones to be verifiable
- Can be committed independently

### Observable
Acceptance criteria describe what a human can verify:
- GOOD: "GET /users returns a JSON array of user objects"
- BAD: "User service is implemented"
- GOOD: "Running `npm test` shows 15 passing tests for the auth module"
- BAD: "Auth module has tests"

### Ordered by Risk
- Front-load the riskiest/most uncertain milestones
- Get the hard parts working first
- Leave polish and refinement for later milestones

### Right-Sized
- Too small: overhead of tracking exceeds the value
- Too large: builder works too long without a checkpoint
- Right: 30 minutes to 2 hours of implementation work

## Milestone Format

```markdown
### M1: {descriptive name}

What exists after this milestone that didn't before:
{one sentence describing the observable outcome}

Acceptance criteria:
- {observable verification 1}
- {observable verification 2}

Steps:
- [ ] {concrete step}
- [ ] {concrete step}
- [ ] {concrete step}
```

## Progress Tracking

The builder marks steps with `[x]` as they complete. The Progress section of the design doc gets timestamped entries:

```markdown
## Progress
- [2025-01-15 14:30] M1 complete — API scaffold with health endpoint returning 200
- [2025-01-15 16:00] M2 in progress — user CRUD working, blocked on DB migration
```

## Questions to Ask

- What's the riskiest part? Can we prove it works in M1?
- If we stopped after milestone N, would we have something useful?
- Are any milestones dependent on each other in ways not captured?
- What's the rollback plan if a milestone fails?
