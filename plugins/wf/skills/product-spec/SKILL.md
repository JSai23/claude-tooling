---
name: product-spec
description: Knowledge for thinking about product specifications — user outcomes, acceptance criteria, scope definition
user-invocable: false
---

# Product Specification Thinking

When planning work, start from the product level before diving into technical design.

## What to Define

### User Outcomes
- Who is affected by this change?
- What can they do after that they couldn't before?
- What observable difference will exist?
- How will we know it's working? (Not "tests pass" — what does the user see?)

### Acceptance Criteria
Frame as observable behaviors, not implementation details:
- GOOD: "The API returns a 401 when the token is expired"
- BAD: "The auth middleware checks token expiry"
- GOOD: "Page load completes in under 2 seconds with 1000 items"
- BAD: "We add pagination"

### Scope
Be explicit about what's in and out:
- What this change DOES include
- What this change DOES NOT include (and why)
- What's deferred to future work (and why that's safe)

## Questions to Ask

- What problem are we actually solving? (Not what feature are we building)
- What's the simplest version that solves the problem?
- What happens if we don't do this?
- Are there users who will be negatively affected?
- How do we verify success beyond "it works"?
