---
name: verify-design
description: Architecture review in hindsight — what to question, dependency analysis, abstraction assessment
user-invocable: false
---

# Design Review

Evaluating code architecture in hindsight — now that it's built, does the structure make sense?

## What to Question

**Type and class design** — Why does this class exist? Would functions suffice? Should these be separate types or one? Is inheritance justified?

**Module structure** — Why is this code in this package? Should modules be split or merged? Are boundaries in the right places? Does directory structure reflect architecture?

**Dependencies** — Why does A depend on B? Could it be inverted? Hidden coupling through shared state? Circular dependencies? Dependencies pointing toward stability?

**Abstractions** — Earning their complexity? More than one implementation? Interface premature? Would concrete code be clearer?

## Approach

Diagrams first. Show module dependencies, data flow, layer structure. Reference diagrams in every finding.

Format findings as:
- OBSERVATION: What the current design does
- QUESTION: Why is it this way?
- ALTERNATIVE: Different approach to consider
- IMPACT: What would change

Not naming/formatting (that's style). Not fake code (that's larp). Sound architecture is the goal, not findings.
