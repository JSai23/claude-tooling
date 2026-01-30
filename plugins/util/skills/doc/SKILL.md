---
name: doc
description: Generate or update project documentation
argument-hint: "[type: api|howto|arch]"
disable-model-invocation: true
context: fork
agent: doc-writer
---
## Documentation Type
$ARGUMENTS

## Existing Docs
!`find . -name "*.md" -path "*/docs/*" -o -name "README.md" -o -name "ARCHITECTURE.md" 2>/dev/null | head -20`

## Project Structure
!`tldr structure . 2>/dev/null | head -40 || ls -la`

---

Generate or update documentation following strict principles.

## Core Principle: Brevity

Documentation that doesn't get read is useless. Every line must earn its place.

**Before writing, ask:**
- Is this word necessary?
- Is this sentence necessary?
- Is this section necessary?
- Will someone actually read this?

Cut ruthlessly. Then cut more.

## Documentation Types

### 1. API Reference (`api`)
**Auto-generated. Never manually written.**

Extract from code:
- Function signatures with types
- Endpoint definitions with request/response shapes
- Class/interface definitions
- Required vs optional parameters

Format: Generated reference, not prose. Tables and signatures, not paragraphs.

### 2. How-To + Expectations (`howto`)
**Mini-tutorials that set contracts.**

Structure:
```markdown
# How to {do thing}

## What You Need
- {prerequisite}
- {prerequisite}

## Steps
1. {step}
2. {step}

## What the System Expects
- {contract/requirement}
- {contract/requirement}

## Common Mistakes
- {mistake} → {fix}
```

Keep it scannable. Bullet points over prose.

### 3. Architecture (`arch`)
**High-level system design. Must stay current.**

Structure:
```markdown
# Architecture: {component/system}

## Overview
{One paragraph max}

## Components
{Diagram or list with one-line descriptions}

## Data Flow
{How information moves through the system}

## Key Decisions
- {decision}: {why}

## Boundaries
- {what's in scope}
- {what's out of scope}
```

Update this when the system changes. Stale architecture docs are worse than none.

## Process

1. Identify what type of doc is needed
2. Check if it exists and needs update vs creation
3. Write the minimum viable documentation
4. Review every line - cut anything unnecessary
5. **Remind: run `/doc` after significant code changes**

## No Type Specified?

Review ALL existing documentation against current code. Update anything stale. Report what was changed.
