---
name: tags
description: This skill should be used when the user asks to "check tags",
  "update tags", "audit tags", "change tag", "list tags", "tag this note",
  "fix frontmatter tags", or needs to manage tags across notes.
argument-hint: "<filepath | --audit | --list>"
---

# Tag Management

Manage the vault's intent-based tag vocabulary. Tags express the **role a note plays in your thinking** — orthogonal to PARA (which handles location) and `type` (which handles what it is).

## Tag Vocabulary

5 tags. Each describes the note's role in your knowledge system:

| Tag | Role | When to Use |
|-----|------|-------------|
| `#seed` | Raw spark | Early idea, observation, unprocessed thought. Needs development. |
| `#thread` | Developing narrative | Part of a bigger picture, connects to ongoing thinking. Being actively developed. |
| `#tool` | Applicable method | Framework, technique, mental model, methodology. Something to apply. |
| `#question` | Open gap | Unresolved question, gap in understanding, thing to figure out. |
| `#insight` | Crystallized understanding | Key takeaway, "aha" moment, settled understanding. |

### Design Principles

- **Cross-cutting**: A `#seed` in math-stats and a `#seed` in ai-dev-ecosystem both mean "needs development"
- **Intent-based**: Tags express what you want to DO with the knowledge
- **Orthogonal to PARA**: Areas handle topics, tags handle knowledge roles
- **Not status**: Note maturity lives in the `status` frontmatter field (`draft`, `refining`, or omitted for stable)

### Tag Combinations

Tags can combine: `[seed, question]` (a question that's still raw), `[tool, insight]` (a framework you've crystallized). Keep to 1-2 tags. If you need 3+, the note probably needs splitting.

### Tag Lifecycle

Notes naturally move through tags as understanding develops:
```
#seed → #thread → #insight (ideas that crystallize)
#seed → #question → #insight (questions that get answered)
#tool stays #tool (methods are stable once captured)
```

## Mode 1: Tag a Note

**Trigger**: `/tags path/to/note.md`

1. Read the note's content and frontmatter
2. Determine the note's role:
   - Is it a raw, undeveloped thought? → `#seed`
   - Is it part of a developing line of thinking? → `#thread`
   - Is it a framework/method/technique? → `#tool`
   - Does it pose or explore an unanswered question? → `#question`
   - Has it crystallized a clear understanding? → `#insight`
3. Show current tags vs. suggested tags
4. On confirmation, edit the frontmatter `tags:` field

## Mode 2: Audit Tags

**Trigger**: `/tags --audit`

Scan all notes and report:

1. **Invalid tags**: Tags outside the 5-tag vocabulary
2. **Missing tags**: Notes with no `tags` field (exclude MOCs, project briefs)
3. **Stale seeds**: Notes tagged `#seed` older than 30 days — develop or archive
4. **Open questions**: All `#question` notes — any answered? Any resolvable?
5. **Tag distribution**: Count per tag across the vault

Exclude `_System/`, `.obsidian/`, `0-Inbox/archive/` from scan.

## Mode 3: List by Tag

**Trigger**: `/tags --list`

Group all notes by tag:

```
## #seed (N notes)
- path/to/note.md

## #thread (N notes)
...

## #insight (N notes)
...

## #tool (N notes)
...

## #question (N notes)
...

## Untagged (N notes)
...
```
