---
name: architecture
description: Project-specific system map — domains, layers, dependencies, entry points. Updated as system evolves.
user-invocable: false
---

# Architecture

This skill provides the project's system map. It should be kept in sync with `docs/ARCHITECTURE.md`.

## How This Skill Works

This is a template. Each project should customize this skill with its actual architecture. The content below provides the structure — fill it in with project-specific details.

## System Overview

{One paragraph describing what this system does and its primary components.}

## Domain Map

{List of domains/modules with one-line descriptions:}

```
domain-a/    — {what it does}
domain-b/    — {what it does}
shared/      — {what it does}
```

## Layer Structure

{If the project uses layers, document them:}

```
[Entry Points]  → [Services]  → [Repositories]  → [Storage]
     ↓                ↓
[Middleware]     [Domain Logic]
```

## Dependency Rules

{What can depend on what:}
- Services depend on repositories, never the reverse
- Domain logic has no external dependencies
- Entry points wire everything together

## Key Entry Points

{Where an agent should start when trying to understand the system:}

- Main entry: {path}
- Configuration: {path}
- Routes/API definitions: {path}
- Core domain logic: {path}

## Conventions

{Patterns agents should follow:}
- File naming: {convention}
- Module organization: {convention}
- Error handling: {convention}
- Testing: {convention}
