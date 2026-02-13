---
name: vault-system
description: This skill should be used when the user asks to "file a note",
  "organize vault", "PARA structure", "vault rules", "add frontmatter",
  "tag a note", "archive a note", "naming convention", or when working
  with Obsidian vault files.
---

# Vault System — PARA Knowledge Base

Core rules for managing a PARA-based Obsidian vault. This skill provides the complete filing system, naming conventions, and structural rules.

## Folder Structure

```
0-Inbox/                          Raw captures, zero friction
  archive/                        Processed originals
1-Projects/                       Active work with goal + deadline
  {project-name}/                 Flat inside (one sub-folder level allowed)
2-Areas/                          Ongoing interests, no end date
  {area-name}/                    Flat inside, no sub-folders ever
3-Resources/                      Reference material
  clips/                          Raw captures (Readwise, manual)
  short-form/                     Tweets, posts, quick takes
  long-form/                      Articles, essays
  books/                          Book notes
  videos/                         Video notes, transcripts
4-Archive/                        Done or dead
_System/                          Templates, config, references
```

**Max depth: 4 levels.** Vault > PARA category > folder > note. No sub-folders inside Areas. Projects allow one level of sub-folders (research/, backtests/) because projects are temporary.

## Filing Cascade

Ask in order, first match wins:

1. **Project?** Does this help an active project with a goal + deadline? → `1-Projects/{project}/`
2. **Area?** Does this relate to an ongoing interest? → `2-Areas/{area}/`
3. **Resource?** Is this reference material? → `3-Resources/{subfolder}/`
4. **None?** → `4-Archive/` or delete

When ambiguous, use semantic search to confirm — if top matches cluster in one area, that's strong signal.

## Naming Conventions

**Notes**: `YYYY-MM-DD_descriptive-slug.md` — always. Generate slug from content.

**MOCs** (Maps of Content):
- `00_area-name.md` — L0: Main area MOC (one per area, always exists)
- `01_subtopic.md` — L1: Sub-MOC (only when 15+ notes cluster on subtopic)
- Never L2. If L1 needs splitting, scope is wrong.

**Project briefs**: `00_project-name.md` — always at project root.

## Frontmatter

Every note gets frontmatter. Required fields: `type`, `created`, `tags`.

### Status Field

Note maturity lives in frontmatter, not tags:
- `status: draft` — raw, incomplete
- `status: refining` — being actively worked on
- (omit for stable content)

### Intent Fields (Inbox Only)

Writer and thinker encode intent for the librarian:
- `filing-hint` — suggested PARA destination
- `context` — freeform: what prompted this, what it relates to
- `source` — who created it (e.g., `thinker`)

These are stripped by the librarian when filing.

Consult `references/frontmatter-schemas.md` for exact YAML for each type.

## Tags — Knowledge Roles (5 total)

Tags express the **role a note plays in your thinking**. They are cross-cutting, intent-based, and orthogonal to PARA.

| Tag | Role | Meaning |
|-----|------|---------|
| `#seed` | Raw spark | Early idea, observation, needs development |
| `#thread` | Developing narrative | Part of bigger picture, being actively developed |
| `#tool` | Applicable method | Framework, technique, mental model to apply |
| `#question` | Open gap | Unresolved question, gap in understanding |
| `#insight` | Crystallized understanding | Key takeaway, settled understanding |

**No other tags.** PARA handles topics. Tags handle knowledge roles.

Tags can combine (1-2 max): `[seed, question]`, `[tool, insight]`.

## MOCs — The Real Structure

MOCs are living documents that synthesize understanding, not just list links.

**Structure**: Thesis paragraph → Sections with annotated links → Open Questions → Cross-links to related areas.

**L0 MOC**: One per area/project. Links everything. Written prose with `[[wikilinks]]`.

**L1 Sub-MOC**: Only when 15+ notes cluster on a subtopic. L0 references L1; L1 goes deep.

## Backlinks

Use `[[wikilinks]]`. Link when connection is clear and useful — don't force it.

- **In MOCs**: Link to all relevant notes (MOC's job)
- **In notes**: `## Related` section at bottom, or inline where relevant
- **In project briefs**: Link to area MOCs and resources
- **Prefer linking to MOCs** for high-level connections

## Inbox-First Pattern

Everything enters through `0-Inbox/`. Writer and thinker both write here. Only the librarian files to PARA destinations.

## Inbox Processing

1. Read intent signals from frontmatter (`filing-hint`, `context`, `source`, `tags`)
2. Determine destination via filing cascade
3. Confirm with semantic search
4. Archive original to `0-Inbox/archive/`
5. Fix frontmatter, strip intent fields
6. Rename to `YYYY-MM-DD_slug.md`
7. Move to destination
8. Update parent living doc (MOC or project brief)
9. Add `## Related` section if strong connections exist

## Archive

Archive notes get these fields added:
```yaml
archived: YYYY-MM-DD
archived-from: 2-Areas/area-name
archive-reason: superseded | completed | stale | abandoned
```

Never auto-archive MOCs, active area notes, or Resources.

## Additional Resources

For detailed reference:
- **`references/para-rules.md`** — Full filing rules, archive workflow, content flow, depth enforcement
- **`references/frontmatter-schemas.md`** — Exact YAML for every frontmatter type
- **`references/filing-logic.md`** — Area scope table, project scope table, decision trees
