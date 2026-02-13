# Frontmatter Schemas — Complete Reference

Every note gets frontmatter. These are the exact YAML schemas for each type.

## Standard Note

```yaml
---
type: note
created: 2025-01-21
status: draft
tags: [seed]
---
```

Required: `type`, `created`, `tags`
Optional: `status` (draft, refining — omit for stable)

## MOC (Map of Content)

```yaml
---
type: moc
level: 0
created: 2025-01-21
---
```

- `level: 0` — Main area/project MOC (L0)
- `level: 1` — Sub-MOC (L1), only when 15+ notes cluster

MOCs don't use tags or status. They're structural, not content.

## Project Brief

```yaml
---
type: project
status: active
created: 2025-02-05
goal: "Ship v1 of polymarket framework"
deadline: 2025-03-15
---
```

- `status`: `active` | `paused` | `blocked`
- `goal`: One-sentence project objective
- `deadline`: Target completion date
- When archiving, add archive fields (see below)

## Inbox Dump

```yaml
---
type: dump
created: 2025-02-05
status: draft
tags: [seed]
filing-hint: "ai-dev-ecosystem"
context: "Raw thoughts about agent memory patterns"
---
```

Raw brain dump. Always `status: draft`. Default tag `#seed`.

## Inbox Note (from Writer)

```yaml
---
type: note
created: 2025-02-05
status: draft
tags: [thread]
filing-hint: "polymarket-framework"
context: "From discussion about market pricing models. Updates thinking on price discovery."
---
```

Structured note from interactive writing session. Intent fields help the librarian file it.

## Inbox Synthesis (from Thinker)

```yaml
---
type: note
created: 2025-02-05
status: draft
tags: [insight]
filing-hint: "prediction-markets"
context: "Synthesized from discussion about prediction market efficiency. Draws on [[note-1]], [[note-2]]."
source: thinker
---
```

Synthesis from a thinking session. `source: thinker` signals the librarian to handle with care — may update MOC thesis.

## Inbox Edit

```yaml
---
type: edit
targets:
  - 2-Areas/ai-dev-ecosystem/2025-01-21_agentic-learnings.md
created: 2025-02-05
---
```

- `targets`: Array of file paths to update
- Body contains the edits to apply
- After processing: apply edits to targets, archive the edit note

## Inbox Clip

```yaml
---
type: clip
created: 2025-02-05
tags: [tool]
filing-hint: "resource/long-form"
---
```

External content capture. Usually routes to `3-Resources/` during processing.

## Archive Additions

When archiving any note, preserve original frontmatter and add:

```yaml
archived: 2025-02-05
archived-from: 2-Areas/ai-dev-ecosystem
archive-reason: superseded
```

- `archived`: Date of archival
- `archived-from`: Original location path
- `archive-reason`: `superseded` | `completed` | `stale` | `abandoned`

## Intent Fields Reference

These fields are set by the writer/thinker and stripped by the librarian during filing:

| Field | Purpose | Values |
|-------|---------|--------|
| `filing-hint` | Suggested destination | Area name, project name, "resource", "resource/subfolder", "unsure" |
| `context` | Freeform context | What prompted this, what it relates to, why it matters |
| `source` | Who created it | `thinker` (writer notes don't need this — they're the default) |

## Status Field Reference

Note maturity (replaces old `#draft`/`#working` tags):

| Value | Meaning |
|-------|---------|
| `draft` | Raw, incomplete, brain dump |
| `refining` | Being actively worked on, structure emerging |
| (omitted) | Stable, reliable, settled |

## Tag Vocabulary Reference

| Tag | Role |
|-----|------|
| `#seed` | Raw spark — early idea, observation, needs development |
| `#thread` | Developing narrative — part of bigger picture |
| `#tool` | Applicable method — framework, technique, mental model |
| `#question` | Open gap — unresolved question |
| `#insight` | Crystallized understanding — key takeaway |

## Validation Rules

1. Every note MUST have `type` and `created` fields
2. Every non-MOC, non-project note SHOULD have `tags` field
3. Only 5 tags: `#seed`, `#thread`, `#tool`, `#question`, `#insight`
4. Tags combine freely (1-2 max)
5. `status` is optional: `draft`, `refining`, or omitted for stable
6. `created` format is always `YYYY-MM-DD`
7. Project briefs must have `status`, `goal`, and `deadline`
8. Intent fields (`filing-hint`, `context`, `source`) only in `0-Inbox/` — stripped on filing
