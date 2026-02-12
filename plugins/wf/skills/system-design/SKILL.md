---
name: system-design
description: Knowledge for thinking about system-level design — domains, boundaries, data flow, integration points
user-invocable: false
---

# System Design Thinking

When the change affects system-level concerns — service boundaries, data flow, integration points, domain model — apply this thinking.

## What to Analyze

### Domain Model
- What are the core entities/concepts?
- How do they relate to each other?
- Where are the aggregate boundaries?
- What language does the domain use? (Use it consistently)

### Service/Module Boundaries
- Where does this change fit in the existing system topology?
- Does it cross existing boundaries?
- Should it create new boundaries?
- What's the blast radius if this module fails?

### Data Flow
Diagram how information moves:
- Where does data enter the system?
- What transformations happen?
- Where does it get stored?
- Who reads it and when?
- What are the consistency requirements?

### Integration Points
- What external systems does this touch?
- What are their contracts? (APIs, message formats, protocols)
- What happens when they're unavailable?
- What are the latency/throughput characteristics?

## Diagrams to Draw

Always use diagrams before prose for system design:

```
Component diagram:  [A] --depends on--> [B] --calls--> [C]
Data flow:          [Source] -> [Transform] -> [Sink]
Sequence:           Client -> API -> Service -> DB
Boundary:           ┌─── Domain ───┐  ┌─── Infra ───┐
```

## Questions to Ask

- Does this change introduce a new boundary or cross an existing one?
- What's the failure mode? What happens when X is down?
- How does data get from A to B? Show the full path.
- Are we coupling things that should be independent?
- What changes if we need to scale this 10x?
