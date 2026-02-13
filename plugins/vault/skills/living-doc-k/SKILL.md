---
name: living-doc-k
type: knowledge
description: This skill should be used when the user asks about "living documents",
  "living doc", "update MOC", "MOC maintenance", "how do MOCs work",
  "keep docs updated", "project brief", or needs to understand or apply
  the living document pattern.
argument-hint: "[area-name or filepath]"
---

> **Knowledge skill** — Living document patterns: MOCs, project briefs, what makes docs "living", update signals.

# Living Documents

Living docs evolve as understanding shifts. They synthesize — not just list. Two types exist in the vault: **MOCs** and **Project Briefs**.

## Types of Living Documents

### MOC (Map of Content)

**Purpose**: Synthesize an area's knowledge into navigable structure.

**Not an index.** A MOC tells you what you know about a topic and how it fits together.

```markdown
---
type: moc
level: 0
created: YYYY-MM-DD
---

# Area Name

{Thesis paragraph: current understanding. Updated when understanding shifts.}

## Section Name
- [[note-name]] — what it covers, why it matters
- [[other-note]] — key insight from this note

## Another Section
- [[yet-another]] — brief annotation

## Open Questions
- What you don't know yet
- Gaps in understanding

---
Sources cross-linked from: [[00_related-area]], [[00_another-area]]
```

**What makes it living:**
- Thesis paragraph evolves as understanding deepens
- Sections reorganize as the area's structure becomes clearer
- Annotations get refined (not "see this" but "key insight: X")
- Open Questions get resolved, new ones added
- Cross-links grow as connections are discovered

**L0 vs L1:**
- `00_area-name.md` (L0) — one per area, always exists, synthesizes broadly
- `01_subtopic.md` (L1) — only when 15+ notes cluster. L0 references L1; L1 goes deep.
- Never L2. If L1 needs splitting, scope is wrong.

### Project Brief

**Purpose**: Track a project's state, resources, decisions, and next actions.

```markdown
---
type: project
status: active
created: YYYY-MM-DD
goal: "One-sentence objective"
deadline: YYYY-MM-DD
---

# Project Name

{Current status paragraph: what's done, what's in progress, what's blocked.}

## Resources
- [[00_area-moc]] — area knowledge feeding this project
- [[resource-note]] — specific reference material

## Backlog
- [ ] Concrete task
- [ ] Another task

## Decisions
- Decision made and why
- Another decision with rationale
```

**What makes it living:**
- Status paragraph reflects current reality, not aspirational state
- Backlog is actual next steps, maintained as items complete
- Resources grow as relevant notes and references are discovered
- Decisions capture rationale so future-you understands past choices

## Signals a Living Doc Needs Updating

- New notes filed in the area/project that aren't linked yet
- An Open Question now has an answer in a recent note
- Thesis paragraph no longer reflects what the notes actually say
- Project status paragraph is stale (work happened but brief wasn't updated)
- Sections don't match actual note clustering (structural drift)
- Cross-links missing to areas that have grown relevant

## When to Create vs Update

| Situation | Action |
|-----------|--------|
| Filing a new note | Update parent MOC — add link with annotation |
| Understanding shifted | Update MOC thesis paragraph |
| New notes cluster on subtopic (15+) | Create L1 sub-MOC |
| Starting a new project | Create project brief |
| Project milestone hit | Update project brief status + decisions |
| Area has no MOC | Create L0 MOC |

## Anti-Patterns

- Flat bullet list of links with no annotations → not synthesized
- Thesis unchanged in months → probably stale
- No Open Questions → either perfect understanding (unlikely) or not used for thinking
- Project brief with aspirational backlog → not reflecting reality
- Sections that don't match note clustering → structural drift

## Updating a Living Doc

When invoked with an area name or file path:

### 1. Read the Target
Read the MOC or project brief.

### 2. Scan the Area/Project
List all notes. Read frontmatter and first few paragraphs of each.

### 3. Identify Gaps
- **Unlinked notes**: Notes not referenced in the living doc
- **Outdated sections**: Don't reflect current notes
- **Stale Open Questions**: Now answered by existing notes
- **Missing cross-links**: Related area MOCs that should be referenced
- **Annotation gaps**: Links with vague or missing annotations

### 4. Propose Updates
Present specific edits:

```
## Proposed Updates to 00_ai-dev-ecosystem.md

1. ADD to "Agent Architecture" section:
   - [[2025-02-05_agent-note]] — multi-agent orchestration patterns

2. UPDATE thesis paragraph:
   Add sentence about multi-agent patterns emerging as dominant architecture

3. RESOLVE Open Question:
   "How does memory continuity work?" → answered in [[2025-02-01_memory-patterns]]
```

### 5. Execute on Confirmation
Apply edits. Only modify the living doc — never the notes themselves.
