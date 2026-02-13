---
name: backlinks-a
type: action
description: This skill should be used when the user asks to "add backlinks",
  "find related notes", "what should this link to", "update backlinks",
  "suggest connections", or needs to find appropriate wikilinks for a note.
argument-hint: "<filepath>"
---

> **Action skill** — Backlink suggestion workflow: structural search, semantic search, cross-area scan, strength grouping.

# Backlink Discovery

Find and suggest appropriate `[[wikilinks]]` for a note using structural analysis and semantic search.

## Process

Given a file path:

### 1. Read the Target Note

Read the note's content. Identify its area/project, key concepts, tags, and existing links.

### 2. Structural Search

- **Inbound links**: Grep the vault for `[[note-name]]` to find all notes that already link TO this note.
- **Parent MOC**: Read the area/project MOC (`00_` file) to see what's linked and how sections are organized.
- **Sibling notes**: List other notes in the same folder to find potential connections.

### 3. Semantic Search

Run `qmd vsearch` with the note's key sentences or title to find semantically similar notes across the vault.

```bash
qmd vsearch "the key concept from the note" --files
```

Use 2-3 queries with different phrasings for better coverage.

### 4. Cross-Area Scan

Check MOCs in related areas for potential cross-links. Read MOCs from areas that share concepts with the target note.

For example, if the note is in `ai-dev-ecosystem` and mentions statistical concepts, check `00_math-stats.md`.

### 5. Tag-Based Discovery

Look for notes with the same knowledge-role tags that might be conceptually related:
- `#thread` notes in the same area → likely part of the same developing narrative
- `#question` notes → might pose questions this note answers (or vice versa)
- `#tool` notes → frameworks that apply to this note's topic
- `#insight` notes → crystallized understanding related to this note's seeds/threads

### 6. Present Suggestions

Group suggestions by strength:

**Strong matches** — Same area, high semantic similarity, shared concepts:
```
- [[2025-01-21_agentic-primitives]] — shares agent architecture concepts
  → Add to note's ## Related section
```

**Cross-area connections** — Different area, meaningful overlap:
```
- [[00_modeling]] (modeling area) — note discusses model capabilities
  → Add cross-link in note's ## Related section
```

**MOC links** — MOCs that should reference this note:
```
- [[00_ai-dev-ecosystem]] — note not yet linked in area MOC
  → Add to MOC's appropriate section with annotation
```

### 7. Apply on Confirmation

For each accepted suggestion:

- **Note → Note links**: Add to the target note's `## Related` section at the bottom. Create the section if it doesn't exist.
- **MOC links**: Add the note to the parent MOC in the appropriate section with annotation.

## Backlink Rules

- Link when the connection is clear and useful — don't force it
- Prefer linking to MOCs for high-level connections
- Bidirectional by nature — Obsidian shows backlinks automatically, only write the link in one direction
- Cross-area links are encouraged

## Related Section Format

```markdown
## Related

- [[2025-01-21_agentic-primitives]] — agent building blocks
- [[00_modeling]] — model capabilities that enable agentic workflows
```

Keep annotations brief. One phrase describing why the link matters.
