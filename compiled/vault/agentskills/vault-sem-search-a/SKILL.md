---
name: vault-sem-search-a
description: >
  This skill should be used when the user asks to "search notes",
metadata:
  source-plugin: vault
  source-skill: sem-search-a
---

> **Action skill** — Semantic search operations: BM25, vector search, hybrid search, reindexing.

# Semantic Search — qmd

Search the vault by meaning using **qmd**, a local semantic search engine for markdown. BM25 + vector search + LLM re-ranking, all local. No cloud APIs.

## Setup (One-Time)

If qmd is not installed:

```bash
brew install oven-sh/bun/bun        # Bun runtime (if not installed)
bun install -g github:tobi/qmd      # qmd itself
```

Register the vault as a collection:

```bash
qmd collection add "<vault-path>" --name vault
```

Build initial embeddings (~2GB models downloaded on first run):

```bash
qmd embed
```

Index stored at `~/.cache/qmd/index.sqlite` — outside vault, no gitignore needed.

## Commands

### Reindex

When invoked with `--reindex` or after batch changes to the vault:

```bash
qmd update    # Re-index all collections (picks up new/changed/deleted files)
qmd embed     # Rebuild vector embeddings (needed after first install or model change)
```

Use `qmd update` for routine reindexing. Use `qmd embed` only for initial setup or embedding model changes.

### Quick Search (BM25)

Fast keyword search. Good for finding notes that mention specific terms.

```bash
qmd search "prediction market pricing"
```

### Semantic Search (Vector)

Vector similarity search. Finds conceptually related content even without keyword overlap.

```bash
qmd vsearch "how do agents maintain context across sessions"
```

This is the most useful search mode for finding related notes, confirming filing destinations, and discovering connections.

### Best Quality (Hybrid + LLM Re-ranking)

Combines BM25 + vector search + LLM re-ranking with 6 parallel searches. Highest quality but slower.

```bash
qmd query "what patterns emerge in agentic development workflows"
```

Use for thorough exploration. Overkill for quick lookups.

### Get Document

Retrieve the content of a specific document by path:

```bash
qmd get "2-Areas/ai-dev-ecosystem/2025-01-21_agentic-learnings.md"
```

### Output Formats

Append format flags for programmatic use:

- `--json` — JSON output (for parsing results)
- `--csv` — CSV output
- `--md` — Markdown formatted
- `--files` — File paths only (one per line, useful for piping)

Example: `qmd vsearch "agentic development" --files` returns just paths.

## When to Use Which

| Need | Command | Speed |
|------|---------|-------|
| Find notes mentioning a term | `qmd search` | Fast |
| Find conceptually similar notes | `qmd vsearch` | Medium |
| Thorough exploration of a topic | `qmd query` | Slower |
| Confirm filing destination | `qmd vsearch` | Medium |
| Discover cross-area connections | `qmd query` | Slower |

## Integration with Other Skills

- **auto-process-a**: Uses `qmd vsearch` to confirm filing destinations
- **backlinks-a**: Uses `qmd vsearch` or `qmd query` to find semantically similar notes
- **find-connections-a**: Uses `qmd query` for thorough connection discovery
- **librarian agent**: Runs `qmd update` after batch processing

## Troubleshooting

- **"No collections"**: Run `qmd collection add "<vault-path>" --name vault`
- **"No embeddings"**: Run `qmd embed` (first time takes a few minutes)
- **Stale results**: Run `qmd update` to re-index
- **Check collections**: `qmd collection list` shows registered collections
