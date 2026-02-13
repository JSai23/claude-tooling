---
name: doc-a
type: action
description: Generate or update standard code documentation — docstrings, rustdoc, API references, READMEs
argument-hint: "[type: api | howto | arch]"
---

> **Action skill** — Generate and update standard code documentation: docstrings, rustdoc, API refs, how-tos.

## Target
$ARGUMENTS

---

Generate or update standard code documentation. This is user-facing documentation that lives alongside the code — not agent design docs (those live in `design-docs/`).

## Core Principle: Brevity

Every line must earn its place. Documentation that doesn't get read is useless. Cut ruthlessly.

## Documentation Types

### API Documentation

Auto-generated from code. Your job is to ensure the source annotations are complete and correct — not to write separate docs.

- **Python**: Docstrings (Google or NumPy style, match existing convention). Module, class, and public function level.
- **Rust**: `///` doc comments on public items. Include `# Examples` sections for non-obvious usage. `//!` for module-level docs.
- **TypeScript/JavaScript**: JSDoc on exported functions, interfaces, and classes.
- **Go**: Package comments and exported symbol comments.

What makes good API docs:
- First line is a complete sentence describing what it does (not how)
- Parameters documented with types and constraints
- Return values documented with possible states (including errors)
- Examples for anything non-obvious
- No implementation details — those change

What to skip:
- Obvious getters/setters — `get_name` doesn't need "Gets the name"
- Private/internal functions unless logic is non-obvious
- Re-documenting what the type system already enforces

### How-To Guides

Scannable steps with contracts. Written for humans who want to accomplish a specific task.

Structure:
1. One sentence: what this guide helps you do
2. Prerequisites (if any)
3. Numbered steps — each step is one action with one observable result
4. Common pitfalls (if they exist)

Place near the code they describe. A `README.md` in the relevant package/directory, or a dedicated `docs/` folder for multi-step workflows.

### Architecture Documentation

High-level system maps for orientation. These describe what exists and how it connects — not why (that's in `design-docs/`).

- Component diagrams showing boundaries and data flow
- Entry points and key paths through the system
- Dependency relationships
- Where to find things

Keep current or delete. Stale architecture docs are worse than none.

## When Invoked

Assess what's needed based on arguments:

- **`api`** — Audit and improve inline documentation (docstrings, doc comments) for the specified scope. Add missing docs on public APIs, fix inaccurate descriptions, add examples where useful.
- **`howto`** — Create or update a how-to guide for the specified topic. Scan existing code to extract the actual steps.
- **`arch`** — Create or update architecture documentation. Read the actual code structure, don't guess.
- **No argument** — Survey the project for documentation gaps. Report what's missing or stale, prioritized by impact.

## Anti-Patterns

- Writing docs about code that doesn't exist yet
- Repeating what the type signature already says
- "In this document, we will explain..." — just explain it
- Documenting internal implementation details in public API docs
- READMEs that describe aspirational features instead of current behavior
