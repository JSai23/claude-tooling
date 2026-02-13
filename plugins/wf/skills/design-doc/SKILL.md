---
name: design-doc
description: Generate or update agent design documentation — living docs, architecture, principles
argument-hint: "[scope or topic]"
---

## Target
$ARGUMENTS

---

Generate or update agent design documentation. These are internal docs that agents create and maintain — not external/user-facing docs.

## Core Principle: Brevity

Every line must earn its place. Documentation that doesn't get read is useless. Cut ruthlessly.

## Frontmatter

All agent docs use YAML frontmatter for metadata.

### Plan docs (`plan.md`)

```yaml
---
status: draft | active | complete
created: YYYY-MM-DD
updated: YYYY-MM-DD
scope: system | package-name
parent: parent-plan-name    # if nested
---
```

### Living docs

```yaml
---
created: YYYY-MM-DD
updated: YYYY-MM-DD
plans:
  - plan-that-created-this
  - plan-that-modified-this
---
```

The `plans` field links a living doc back to the plans that shaped it. This is how you trace why something exists.

### Decision logs (`decisions.md`)

```yaml
---
plan: plan-name
created: YYYY-MM-DD
---
```

## Dates

- `created` — when the doc was first written
- `updated` — when the doc was last meaningfully changed (not cosmetic edits)
- Entries within docs use `[YYYY-MM-DD]` or `[YYYY-MM-DD HH:MM]` for timestamps
- Agents should update the `updated` field whenever they modify content

## What to Write

When invoked, assess what's needed:
- If a specific topic/scope is given, create or update that living doc
- If no argument, review existing agent docs against current code — update stale content, report changes
- For architecture-level docs, update `docs/ARCHITECTURE.md`
- For component/service docs, write near the code they describe

## Anti-Patterns
- Writing docs about code that doesn't exist yet (that's a plan, not a living doc)
- Repeating information available in the code itself
- Templates filled in mechanically — write what's actually useful, skip sections that add nothing
- "In this document, we will explain..." — just explain it
