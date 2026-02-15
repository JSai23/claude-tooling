---
name: planner-implementation-k
type: knowledge
description: How to write implementation plans — code structure, module layout, component connections, with execution blocks at the end
user-invocable: false
---

> **Knowledge skill** — Implementation planning: system shape, code structure, interfaces, then execution blocks.

# Implementation Planning

An implementation plan describes what the code will look like and how the pieces connect. It reads top-down: system first, structure second, execution blocks last.

## Document Flow

```
┌─────────────────────────────────────────────┐
│  1. System diagrams                         │  ← reader sees the whole picture
│     Data flows, component layout,           │
│     how this fits into existing system       │
├─────────────────────────────────────────────┤
│  2. Code structure                          │  ← reader understands what gets built
│     Modules, libraries, utilities,          │
│     how components connect, key interfaces  │
├─────────────────────────────────────────────┤
│  3. Key decisions & tradeoffs               │  ← reader understands why
│     What was chosen, what was rejected,     │
│     what remains uncertain                  │
├─────────────────────────────────────────────┤
│  4. Execution blocks (if needed)            │  ← reader knows the work
│     Verifiable chunks, risk-ordered,        │
│     only when plan size warrants it         │
└─────────────────────────────────────────────┘
```

Never invert this. A plan that starts with task breakdowns before showing the system is unreadable.

## System Diagrams

Even implementation plans need visuals. Show:
- How new code fits into the existing system
- Data flow through the implementation
- Module/package/component boundaries
- Dependency directions

These aren't decorative — they're the primary communication. Prose supports diagrams, not the other way around.

## Code Structure

The core of an implementation plan. Describe:
- What modules exist and what each one does
- How components, utilities, and libraries connect
- Key interfaces and contracts between pieces
- Where new code lives relative to existing code

Code snippets are expected but surgical — signatures, type shapes, critical algorithms. Not full implementations.

```
GOOD                                    BAD
────────────────────────────────        ────────────────────────────
Function signatures / type defs         Full function implementations
Key struct/class shapes                 Boilerplate setup code
Critical algorithm pseudocode           Every helper and utility
Interface contracts                     Import statements
```

## Execution Blocks

Not every plan needs these. A clear design with good diagrams and structure may be enough on its own. Add execution blocks when:
- The plan is large enough that a builder needs ordering guidance
- There are risk points that should be tackled first
- Dependencies between pieces create a required sequence
- The user asks for them

When you do include blocks, each should be:
- **Verifiable** — produces something observable, not "service is implemented"
- **Right-sized** — meaningful progress, not too granular
- **Risk-ordered** — hardest and most uncertain parts first

Blocks go at the bottom of the plan. They're an appendix to the design, not the plan itself.
