---
name: planner-design-k
type: knowledge
description: How to think about design — product outcomes, system architecture, code structure, tradeoffs
user-invocable: false
---

> **Knowledge skill** — Design thinking framework: product outcomes, system architecture, code structure, tradeoffs.

# Design Thinking

## Product Level

Start from the user, not the code:
- What problem are we solving? (Not what feature are we building)
- What can they do after that they couldn't before?
- What does "done" look like? Frame as observable behaviors, not implementation details.
- What's in scope, what's explicitly out, what's deferred?

## System Level

When the change affects boundaries, data flow, or integration points:
- What are the core entities and how do they relate?
- Where does this fit in the existing system topology?
- Does it cross or create boundaries?
- How does data enter, transform, store, and get read?
- What external systems does this touch? What happens when they're unavailable?
- What's the blast radius if this fails?

Diagram before prose. Show component relationships, data flow, sequences, boundaries.

## Code Level

When designing how code should be structured:
- What modules will exist and what's each one's responsibility?
- Which modules depend on which? Are dependencies pointing toward stability?
- Is every abstraction earning its complexity? Would functions suffice instead of classes?
- Are interfaces minimal — exposing only what's needed?

Prefer the boring obvious solution. Three similar functions is often better than a premature abstraction.

## Tradeoffs

Every major decision should present 2-3 realistic approaches:
- What each offers and costs
- Your recommendation with rationale
- What unknowns remain

Frame as tradeoffs, not pros/cons lists. Every choice trades something for something else.

## Questions That Cut Through

- What's the simplest version that solves the problem?
- What happens if we don't do this?
- Are we designing for a hypothetical future or the current need?
- What changes if we need to scale this 10x?
- Are we coupling things that should be independent?
