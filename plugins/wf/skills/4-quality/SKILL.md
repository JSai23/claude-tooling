---
name: 4-quality
description: Code design quality - architecture and structure review
argument-hint: "[files or dirs]"
disable-model-invocation: true
context: fork
agent: design-auditor
---
## Code Structure
!`tldr structure . 2>/dev/null | head -80 || echo "tldr not available"`

## Module Layout
!`tldr arch . 2>/dev/null | head -40 || echo ""`

## Target
$ARGUMENTS

---

# Design Quality Review

Question the code's architecture and structure. This is NOT about naming or formatting - it's about fundamental design decisions.

## What to Question

### Class & Type Design
- Why does this class exist?
- Should these be separate types or one?
- Is this inheritance justified or should it be composition?
- Are these methods in the right class?

### Module & Package Structure
- Why is this code in this package?
- Should these modules be split or merged?
- Are the boundaries in the right places?
- Does the directory structure reflect the architecture?

### Dependencies & Coupling
- Why does A depend on B?
- Could this dependency go the other way?
- Is there hidden coupling through shared state?
- Are circular dependencies intentional?

### Abstractions
- Is this abstraction earning its complexity?
- Is this interface premature?
- Should this be simpler and more concrete?

## Output Format

### Section 1: Architecture Diagrams

Start with diagrams that map the current structure:

**Current Class Structure:**
```
┌─────────────┐     ┌─────────────┐
│   ClassA    │────>│   ClassB    │
└─────────────┘     └─────────────┘
```

**Current Module Dependencies:**
```
[module_a] --> [module_b] --> [module_c]
     └──────────────────────────┘
```

**Current Data Flow:**
```
[Input] -> [Process] -> [Output]
```

### Section 2: Design Concerns

For each concern, reference the diagrams:

```
## Concern: {title}

DIAGRAM: See {which diagram above}
OBSERVATION: What the current design does
QUESTION: Why is it this way? What's the tradeoff?
ALTERNATIVE: Different approach to consider
IMPACT: What would change if refactored
```

### Section 3: Refactor Candidates

Prioritized list of potential refactors:

```
1. {Refactor title} (references Diagram X)
   FROM: Current structure
   TO: Proposed structure
   TRADEOFF: What you gain vs what you lose
```

## Success Criteria
Finding no design issues is a valid outcome - it means the architecture is sound. The goal is clean design, not finding problems.

## Not In Scope
- Variable naming, formatting → /7.2-quality
- Removing cruft and slop → /7.1-deslop
- Actual fixes → /0-fix

You are auditing design only. User will decide what to refactor.
