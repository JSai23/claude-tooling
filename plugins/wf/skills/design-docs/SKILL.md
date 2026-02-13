---
name: design-docs
description: Knowledge about the agent documentation system — what docs exist, where they live, how agents contribute to them
user-invocable: false
---

# Agent Documentation System

Agent docs are design documentation that agents create and maintain. They capture system knowledge, decisions, and plans. They are separate from external docs (API references, generated documentation, user-facing guides). Agent docs live in `design-docs/` folders — never in a generic `docs/` folder.

## Core Rule: Foresight vs Hindsight

**Plans are foresight.** Written before building. "Here's what we're going to do."

**Everything else is hindsight.** Written after building. "Here's how it works now."

Never write living docs about code that doesn't exist yet. Never plan in hindsight. This distinction drives when each doc type gets created and by whom.

## Doc Types

### Plans
Bounded work with a lifecycle: `draft → active → complete`. A plan has milestones, acceptance criteria, and a defined end state. Once complete, it becomes a historical record of what was done and why. A completed plan going stale is fine — it's a snapshot.

Plans live centralized — all plans go in `design-docs/plans/` at the repo root, regardless of what package they affect. This is because plans are foresight — they're written before code exists and often cross-cut multiple packages.

Plans can nest for large efforts. A parent plan defines the vision and phase ordering, child plans are independently buildable sub-plans within that parent's folder.

**Sibling vs nested plans:** Plans that implement different parts of the same vision are siblings (e.g., `pm-data-service/` and `pm-engine/` are sibling plans — different services). Plans that break one piece of work into phases are nested (e.g., `pm-data-service/block-1/` is a child of `pm-data-service/`). Ask: "Is this a sub-part of that work, or a parallel effort?" Sub-parts nest, parallel efforts are siblings.

### Living Docs
Describe how things work *now*. They have no end state — when the system changes, they change. Staleness is a bug, not a natural lifecycle. Living docs emerge from implementation — the builder creates and updates them after building, not before.

Categories that naturally arise:
- **System docs** — how a service/module/component works, its structure, data flow
- **Integration docs** — how things connect, API contracts, service boundaries, event flows
- **Data docs** — models, schemas, state machines, storage decisions
- **Test docs** — test strategy, fixture guides, integration test setup

Living docs live near what they describe — distributed, not centralized:
- System-level: `design-docs/` at repo root
- Package-level: `{package}/design-docs/`
- Test-level: `{test-dir}/design-docs/`

### ARCHITECTURE.md
The entry point for the whole system. A map that tells you what exists and links to deeper living docs. An agent starting a fresh session reads `design-docs/ARCHITECTURE.md` first to orient itself. It should link to package-level living docs, test indexes, and anything else an agent needs to find.

### PRINCIPLES.md
Golden rules the team enforces. Short, opinionated, evolved through experience. Lives at `design-docs/PRINCIPLES.md`.

## Folder Structure

```
design-docs/                            # System-level (repo root)
├── plans/                              # ALL plans — centralized
│   ├── index.md                        # Catalogue of all plans
│   └── {name}/
│       ├── plan.md                     # The plan (foresight)
│       ├── decisions.md                # Decisions made during execution
│       ├── verification.md             # Verifier's report
│       └── {sub-plan}/                 # Nested child plans
│           └── plan.md
│
├── ARCHITECTURE.md                     # System map — the entry point
├── PRINCIPLES.md                       # Golden rules
└── {topic}.md                          # System-level living docs (hindsight)

{package}/
├── design-docs/                        # Package-level living docs (hindsight)
│   └── {topic}.md
└── tests/
    └── design-docs/                    # Test-level living docs
```

Plans centralized, living docs distributed. Plans are foresight (written before code, often cross-cutting). Living docs are hindsight (written after code, near what they describe).

## Agent Roles in the Doc System

Each agent has a specific relationship to agent docs. This is not optional — every agent must fulfill its docs responsibilities as part of its core work.

**Planner** — Creates plans. Reads `design-docs/ARCHITECTURE.md` and existing living docs to understand the system before planning. Seeds ARCHITECTURE.md and PRINCIPLES.md if the project doesn't have them yet (hindsight only — describe what exists, not aspirational content). Uses subagents to read large files and explore the codebase in parallel. When organizing plans, confirm sibling vs nesting with the user — don't assume.

**Builder** — The primary author of living docs. After implementing code, the builder is responsible for creating or updating living docs to reflect the new reality. This is not an afterthought — it's a core output alongside production code and tests. Specifically:
- After each milestone, update the plan doc (progress, surprises, decisions)
- After implementation, create or update living docs near the code that changed
- If the system shape changed, update `design-docs/ARCHITECTURE.md`
- Living docs describe what exists now, not what was planned — write in hindsight
- Place living docs at the right scope: system-level in `design-docs/`, package-level in `{package}/design-docs/`, test-level in `{test-dir}/design-docs/`

**Verifier** — Checks doc accuracy as part of verification. Writes `verification.md` alongside the plan. Flags living docs that don't match the code, ARCHITECTURE.md that's stale, and components that were built but have no living doc. Doc accuracy is a verification dimension alongside code quality.

**Gardener** — Maintains doc health. Audits living docs against reality — removes stale content, flags gaps, updates ARCHITECTURE.md and PRINCIPLES.md to match the current system. Checks that plans marked active are actually still in progress. The gardener's core job is ensuring that what's in `design-docs/` accurately represents the system so future agent sessions can trust it.
