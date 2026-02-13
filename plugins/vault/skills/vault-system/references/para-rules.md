# PARA Rules — Full Reference

## Content Flow

```
0-Inbox/
    ↓ processing (weekly review or /auto-process)
    ↓ ask: Project? Area? Resource? Archive?
    ↓
┌──────────┬──────────┬───────────┬──────────┐
│ Project  │  Area    │ Resource  │ Archive  │
│ (active  │ (ongoing │ (reference│ (dead)   │
│  work)   │ interest)│ material) │          │
└──────────┴──────────┴───────────┴──────────┘
    │            │           │
    │ done ──→ Archive       │
    │ spawns ──→ Project     │
    │            │←── link ──┘
    │            │
    └── all connected via backlinks
```

## Agent Flow

```
Writer (interactive)  ──→ 0-Inbox/
Thinker (synthesis)   ──→ 0-Inbox/
Raw dumps             ──→ 0-Inbox/
                           ↓
                      Librarian
                           ↓
              ┌────────────┼────────────┐
              ↓            ↓            ↓
         1-Projects   2-Areas    3-Resources
              │            │            │
              └── Living docs updated ──┘
              └── Backlinks built ──────┘
```

## Filing Cascade (Detailed)

Ask in order, first match wins:

1. **Project?** — Does this directly help an active project with a defined goal and deadline?
2. **Area?** — Does this relate to an ongoing area of interest/responsibility?
3. **Resource?** — Is this reference material (article, tweet, book note, video note, clip)?
4. **None of the above?** — Archive or delete.

### Reading Intent Signals

When processing inbox items from the writer or thinker:
- `filing-hint` — strong signal for destination, verify with sem-search
- `context` — explains what prompted the note and what it relates to
- `source: thinker` — synthesis note, may update MOC thesis
- `tags` — knowledge role hints at filing (e.g., `#tool` might be a resource)

### Confirming Ambiguous Filing

When the destination isn't obvious:
- Run semantic search — if top 5 matches cluster in one area, strong signal
- Check if the note references concepts from a specific project's goals
- If it spans two areas, file in the more specific one and cross-link from the other's MOC

## Inbox-First Pattern

Everything enters through `0-Inbox/`. Writer and thinker both write here exclusively. Only the librarian files to PARA destinations.

- Raw dumps → `0-Inbox/` with `type: dump`, `status: draft`
- Writer output → `0-Inbox/` with intent fields
- Thinker synthesis → `0-Inbox/` with `source: thinker`

Processing happens later via `/auto-process` or the librarian agent.

## Inbox Archive Pattern

When processing inbox items:
1. The **processed version** goes to its PARA destination (renamed, frontmatter fixed, connected)
2. The **original raw capture** moves to `0-Inbox/archive/`
3. Never delete inbox items — move originals to archive

## Depth Enforcement

| Location | Max Depth | Example |
|----------|-----------|---------|
| Areas | 4 levels | vault > 2-Areas > ai-dev-ecosystem > note.md |
| Projects | 5 levels | vault > 1-Projects > polymarket > research > note.md |
| Resources | 4 levels | vault > 3-Resources > clips > note.md |
| Archive | 4 levels | vault > 4-Archive > note.md |

**Areas never get sub-folders.** If an area gets big, add MOCs (L0 → L1) — not folders.

**Projects allow one sub-folder level:**
1. Start flat. Only create sub-folders at 5+ notes with clear split
2. Max one level deep (research/ OK, research/polymarket/ NOT OK)
3. Sub-folders must be work types (research/, backtests/), not topics
4. Project brief (00_) stays at root

## Note Lifecycle

```
Raw input → 0-Inbox/ (status: draft, tag: #seed)
    ↓ librarian processes
Filed in Area/Project (status: draft or refining, appropriate tag)
    ↓ refine over time
Stable (no status field, tag: #insight or #tool)
    ↓ eventually
4-Archive/ (if superseded or dead)
```

## Archive Workflow

1. Add archive frontmatter fields:
   - `archived: YYYY-MM-DD`
   - `archived-from: original/path`
   - `archive-reason: superseded | completed | stale | abandoned`
2. Move to `4-Archive/` (flat, no sub-folders)
3. For completed projects: move the entire project folder to `4-Archive/`

### Never Auto-Archive

- MOCs (manual decision only)
- Active area notes
- Resources (they stay in Resources forever)

## Weekly Review Process

20-30 minutes.

1. **Process `0-Inbox/`** — file each item, archive originals
2. **Check active Projects** — update status in briefs, mark completed for archive
3. **Scan Area MOCs** — add links to this week's notes, update thesis if understanding shifted
4. **Archive anything done or dead**
5. **Check `#question` notes** — any answered? Resolve and update tags.
6. **Check stale `#seed` notes** — older than 30 days? Develop or archive.

## MOC Rules (Detailed)

### When to Create

| Level | Trigger | Example |
|-------|---------|---------|
| L0 (00_) | Always — one per area/project | `00_ai-dev-ecosystem.md` |
| L1 (01_) | 15+ notes cluster on a subtopic | `01_agent-architecture.md` |

Never L2. If L1 needs splitting, the subtopic is too broad.

### MOC as Living Document

MOCs evolve as notes are added. They synthesize understanding — not just list files.

- **Thesis paragraph**: Current understanding (update when it shifts)
- **Sections**: Group related notes with annotations
- **Open Questions**: What you don't know yet
- **Cross-links**: Connect to related area MOCs
- Updated whenever new notes are filed or understanding changes
