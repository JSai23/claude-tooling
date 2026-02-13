---
name: find-connections-a
type: action
description: This skill should be used when the user asks to "find connections",
  "what relates to this", "how does this connect", "map connections",
  "show related work", or needs to discover relationships across the vault.
argument-hint: "<filepath | topic | area-name>"
---

> **Action skill** — Connection discovery: semantic search, backlink analysis, tag-based discovery, PARA structure analysis.

# Connection Discovery

Combines semantic search, backlinks, tags, and PARA structure to map relationships across the vault.

## Input Parsing

The argument can be:

1. **File path** → Read the note, use its content as the search basis
2. **Topic text** (e.g., "prediction market pricing") → Use directly as search query
3. **Area name** (e.g., "ai-dev-ecosystem") → Read the area's L0 MOC, use its thesis and key concepts

## Process

### 1. Semantic Search

Query the vault for similar notes.

For a note or topic:
```bash
qmd query "<key sentences or topic>" --files
```

For an area, run multiple queries based on the MOC's sections:
```bash
qmd vsearch "<section 1 topic>" --files
qmd vsearch "<section 2 topic>" --files
```

Collect top 10-15 results across queries.

### 2. Backlink Analysis

- Find all notes that link to/from the target
- Trace **2-hop connections**: notes that share common links but don't directly link to the target
- Use Grep: search for `[[note-name]]` patterns across the vault

### 3. Tag-Based Discovery

Find notes with knowledge-role tags that suggest conceptual relationships:
- `#seed` + `#seed` in similar areas → potential threads waiting to be connected
- `#question` notes → might pose questions the target answers
- `#tool` notes → frameworks that apply to the target's domain
- `#insight` notes → crystallized understanding that builds on the target
- Shared tags + semantic similarity = strong connection signal

### 4. PARA Structure Analysis

Check structural relationships:
- Which **projects** draw from the same area?
- Which **areas** have overlapping scope with the target?
- Which **resources** were captured for the same purpose?
- Read project briefs to find area MOC references

### 5. Synthesize Connection Map

Present findings organized by relationship type:

**Direct connections** — linked or semantically close:
```
- [[2025-01-21_agentic-primitives]] (ai-dev-ecosystem)
  Semantic similarity: high | Shared concepts: agent architecture, tooling
```

**Indirect connections** — shared links, related tags, related area:
```
- [[2025-02-01_transformer-scaling]] (modeling)
  Connection via: both linked from [[00_ai-dev-ecosystem]], both tagged #thread
```

**Project opportunities** — area knowledge that could feed a project:
```
- prediction-markets area notes → prediction-market-algo-dev project
  Notes about market mechanics could inform algorithm design
```

**Gaps** — topics mentioned but with no notes:
```
- "memory continuity" mentioned in 3 notes but no dedicated note exists
- "cross-market correlation" referenced in project brief but no area coverage
```

## Output Format

```markdown
## Connection Map: {input}

### Direct (N notes)
{strongest connections}

### Indirect (N notes)
{2-hop links, shared tags, related areas}

### Project Opportunities
{area notes that could serve projects}

### Gaps
{topics referenced but not covered}
```

## When to Use vs. Other Skills

- **backlinks-a** — focused on one note's links. Use when you know the note.
- **find-connections-a** — broad exploration across the vault. Use when mapping a topic or area.
- **sem-search-a** — raw search results. Use when you just need to find notes.
