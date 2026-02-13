---
name: auto-process-a
type: action
description: This skill should be used when the user asks to "process inbox",
  "auto process", "file this note", "triage inbox", "route this to the right place",
  or needs to automatically move notes from 0-Inbox to their correct PARA destination.
argument-hint: "[filename(s)] or blank for all inbox"
---

> **Action skill** — Inbox processing workflow: read intent, determine destination, confirm, file, update living docs.

# Automated Inbox Processing

Process inbox items: read intent, classify, file, rename, connect, and update living docs. Designed for the librarian agent but usable standalone.

## Input

- **Specific file(s)**: Process only the named files in `0-Inbox/`
- **No argument**: Process all files in `0-Inbox/` (excluding `archive/`)

## Process Per Item

### 1. Read and Understand Intent

Read the note. Check frontmatter for intent signals left by the writer or thinker:

| Field | Meaning |
|-------|---------|
| `filing-hint` | Suggested destination (area name, project name, "resource", "unsure") |
| `context` | Freeform context — what prompted this, what it relates to |
| `source: thinker` | Came from a synthesis session — handle with care |
| `type` | dump, note, clip, edit |
| `tags` | Knowledge role: seed, thread, tool, question, insight |

If no intent signals, classify from content.

### 2. Determine Destination

Filing cascade (first match wins):

1. **Project?** → Does this help an active project? Check project briefs for goal alignment.
2. **Area?** → Does this relate to an ongoing area? Match against area scopes.
3. **Resource?** → Is this reference material? Route to correct sub-folder (clips/short-form/long-form/books/videos).
4. **None?** → Archive or flag for user.

When `filing-hint` exists, treat as strong signal but verify.

### 3. Confirm with Semantic Search

```bash
qmd vsearch "key content from the note" --files
```

**Auto-file** when:
- Semantic search confirms (3+ top results in same location)
- Content clearly matches one area/project's scope
- `filing-hint` aligns with search results

**Ask the user** when:
- Top matches span multiple areas
- Content is vague or multi-topic
- `filing-hint: unsure` or missing with no clear match

### 4. Archive Original

Preserve the raw capture before modifying:

```bash
mkdir -p "0-Inbox/archive"
cp "0-Inbox/original-name.md" "0-Inbox/archive/original-name.md"
```

### 5. Fix Frontmatter

- Set `type: note` if missing (keep original type if appropriate)
- Set `created: YYYY-MM-DD` using today's date if missing
- Validate tags against the 5-tag vocabulary (`#seed`, `#thread`, `#tool`, `#question`, `#insight`)
- Set appropriate `status` (draft, refining, or omit for stable)
- **Remove intent fields**: Strip `filing-hint`, `context`, `source` — they served their purpose

### 6. Rename and Move

Rename to `YYYY-MM-DD_descriptive-slug.md`, then move to destination:

```bash
mv "0-Inbox/original-name.md" "2-Areas/area-name/YYYY-MM-DD_slug.md"
```

### 7. Update Living Docs

Read the parent MOC or project brief. Add the note with annotation:

```markdown
- [[YYYY-MM-DD_slug]] — brief description of what the note covers
```

For **thinker synthesis** (`source: thinker`):
- Check if the synthesis updates the MOC's thesis paragraph
- Check if it resolves any Open Questions
- Update source notes' `## Related` sections

### 8. Build Connections

Find related notes via semantic search and structural analysis. Add `## Related` section if strong connections exist. Only add connections that are clear and useful.

## Special: Edit Notes

For notes with `type: edit`:
1. Read the `targets` array from frontmatter
2. Read each target file
3. Apply the described edits
4. Archive the edit note

## Processing Report

After processing, show summary:

```
## Inbox Processing Report

### Filed
- "Raw thoughts on agents" → 2-Areas/ai-dev-ecosystem/2025-02-07_agent-thoughts.md
- "Market data notes" → 1-Projects/polymarket-framework/2025-02-07_market-data.md

### Living Docs Updated
- 00_ai-dev-ecosystem.md — added link to agent-thoughts
- 00_polymarket-framework.md — added link to market-data

### Connections Found
- agent-thoughts ↔ agentic-primitives (shared concepts)

### Needs Attention
- "Ambiguous note" — couldn't determine destination, left in inbox
```

## After Batch Processing

Reindex semantic search:
```bash
qmd update
```
