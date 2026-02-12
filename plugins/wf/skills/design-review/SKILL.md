---
name: design-review
description: Knowledge for reviewing code architecture — what to question, dependency analysis, abstraction assessment
user-invocable: false
---

# Design Review

How to evaluate code architecture in hindsight — now that it's built, does the structure make sense?

## What to Question

### Class and Type Design
- Why does this class exist? Would functions suffice?
- Should these be separate types or one?
- Is this inheritance justified or should it be composition?
- Are these methods in the right class?

### Module and Package Structure
- Why is this code in this package?
- Should these modules be split or merged?
- Are the boundaries in the right places?
- Does the directory structure reflect the architecture?

### Dependencies and Coupling
- Why does A depend on B? Could it be inverted?
- Is there hidden coupling through shared state?
- Are there circular dependencies?
- Are dependencies pointing toward stability?

### Abstractions
- Is this abstraction earning its complexity?
- Does it have more than one implementation? Will it ever?
- Is this interface premature?
- Would concrete code be clearer?

## Diagram-First Analysis

Always start with diagrams before prose:

```
Module dependencies:  [A] --> [B] --> [C]
Data flow:            [Input] -> [Transform] -> [Sink]
Layer structure:      [Entry] -> [Service] -> [Repo] -> [Storage]
```

Reference diagrams in every finding.

## Finding Format

```
OBSERVATION: What the current design does
QUESTION: Why is it this way? What's the tradeoff?
ALTERNATIVE: Different approach to consider
IMPACT: What would change if refactored
```

## What Design Review Is NOT

- Not naming or formatting (that's code style)
- Not hunting for fake code (that's larp detection)
- Not removing slop (that's code cleanliness)
- It's OK to find nothing wrong. Sound architecture is the goal, not findings.
