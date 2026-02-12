---
name: doc
description: Generate or update project documentation. Types - api, howto, arch.
argument-hint: "[type: api|howto|arch]"
---

## Documentation Type
$ARGUMENTS

---

Generate or update documentation. Every line must earn its place.

## Core Principle: Brevity

Documentation that doesn't get read is useless. Before writing any line:
- Is this word necessary?
- Will someone actually read this?
- Can I say this in fewer words?

Cut ruthlessly. Then cut more.

## Documentation Types

### API Reference (`api`)
Auto-generated from code. Never manually written.
- Function signatures with types
- Endpoint definitions with request/response shapes
- Tables and signatures, not prose

### How-To (`howto`)
Mini-tutorials that set contracts:
```markdown
# How to {do thing}

## What You Need
- {prerequisite}

## Steps
1. {step}
2. {step}

## What the System Expects
- {contract}

## Common Mistakes
- {mistake} → {fix}
```

### Architecture (`arch`)
High-level system design. Must stay current.
```markdown
# Architecture: {component}

## Overview
{One paragraph max}

## Components
{Diagram or list}

## Data Flow
{How information moves}

## Key Decisions
- {decision}: {why}
```

Update this when the system changes. Stale architecture docs are worse than none.

## No Type Specified?

Review ALL existing documentation against current code. Update anything stale. Report what was changed.

## Anti-Patterns
- "In this document, we will explain..." — just explain it
- "It is important to note that..." — just say it
- Repeating information in different words
- Writing for completeness instead of usefulness
