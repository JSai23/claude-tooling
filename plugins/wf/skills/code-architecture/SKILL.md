---
name: code-architecture
description: Knowledge for thinking about code-level architecture — modules, layers, dependencies, patterns, tradeoffs
user-invocable: false
---

# Code Architecture Thinking

When designing how code should be structured — module layout, dependency direction, patterns, abstractions.

## What to Design

### Module Structure
- What files/modules will exist?
- What is each module's single responsibility?
- How do they compose?
- What's the directory layout?

### Dependency Direction
- Which modules depend on which?
- Are dependencies pointing toward stability (concrete depends on abstract)?
- Are there cycles? If so, how to break them?
- What's the dependency graph? (Draw it)

### Patterns and Abstractions
For every pattern or abstraction, ask: is this earning its complexity?

- Does this abstraction have more than one implementation?
- Will it have more than one implementation in the foreseeable future?
- Is the indirection making the code harder to follow?
- Could we use a simpler, more concrete approach?

Prefer the boring obvious solution. Three similar functions is often better than a premature abstraction.

### Interface Design
- What does each module expose?
- What does it hide?
- Are the interfaces minimal? (Only what's needed, nothing more)
- Do they work at the right level of abstraction?

## Tradeoff Patterns

When presenting architecture options, frame as tradeoffs:

```
Approach A: {name}
  + {benefit}
  + {benefit}
  - {cost}
  Complexity: {low/medium/high}

Approach B: {name}
  + {benefit}
  - {cost}
  - {cost}
  Complexity: {low/medium/high}
```

## Questions to Ask

- Why is this a class instead of a function?
- Why are these methods grouped together?
- Is this the right layer for this logic?
- What's the simplest structure that works?
- Are we designing for a hypothetical future or the current need?
