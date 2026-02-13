---
name: design-docs
description: Knowledge about the agent documentation system — what docs exist, where they live, how agents contribute to them
user-invocable: false
---

# Agent Documentation System

Agent docs are design documentation that agents create and maintain. They capture system knowledge, decisions, and plans. They are separate from external docs (API references, generated documentation, user-facing guides).

## Core Rule: Foresight vs Hindsight

**Plans are foresight.** Written before building. "Here's what we're going to do."

**Everything else is hindsight.** Written after building. "Here's how it works now."

Never write living docs about code that doesn't exist yet. Never plan in hindsight. This distinction drives when each doc type gets created and by whom.

## Doc Types

### Plans
Bounded work with a lifecycle: `draft → active → complete`. A plan has milestones, acceptance criteria, and a defined end state. Once complete, it becomes a historical record of what was done and why. A completed plan going stale is fine — it's a snapshot.

Plans live at the scope they describe:
- System-level plans: `docs/plans/`
- Package-level plans: `{package}/docs/plans/`

Plans can nest for large efforts — a parent plan defines the vision and phase ordering, child plans are independently buildable.

### Living Docs
Describe how things work *now*. They have no end state — when the system changes, they change. Staleness is a bug, not a natural lifecycle. These emerge from implementation work:

- **System docs** — how a service/module/component works, its structure, data flow
- **Integration docs** — how things connect, API contracts, service boundaries, event flows
- **Data docs** — models, schemas, state machines, storage decisions
- **Test docs** — test strategy, fixture guides, integration test setup

Living docs live near what they describe:
- System-level: `docs/`
- Package-level: `{package}/docs/`
- Test-level: `{test-dir}/docs/`

### ARCHITECTURE.md
The entry point. A system-level map that tells you what exists and links to deeper docs. An agent starting a fresh session reads this first to orient itself. Lives at `docs/ARCHITECTURE.md`.

### PRINCIPLES.md
Golden rules the team enforces. Short, opinionated, evolved through experience. Lives at `docs/PRINCIPLES.md`.

## Folder Structure

```
docs/
├── plans/
│   ├── index.md                    # Catalogue of all plans
│   └── {name}/
│       ├── plan.md                 # The plan (foresight)
│       ├── decisions.md            # Decisions made during execution
│       └── verification.md         # Verifier's report
│
├── ARCHITECTURE.md                 # System map — the entry point
├── PRINCIPLES.md                   # Golden rules
└── {topic}.md                      # System-level living docs (hindsight)

{package}/
├── docs/
│   ├── plans/                      # Package-scoped plans
│   └── {topic}.md                  # Package-level living docs
└── tests/integration/
    └── docs/                       # Test-level living docs
```

## Agent Responsibilities

| Agent | Plans | Living Docs | ARCHITECTURE.md | PRINCIPLES.md |
|-------|-------|-------------|-----------------|---------------|
| Planner | Creates | — | Reads to understand current state | Reads |
| Builder | Updates progress, decisions | Creates/updates after implementation | Updates if system shape changed | — |
| Verifier | Writes verification.md | Checks accuracy against code | Checks accuracy | — |
| Gardener | Checks for stale active plans | Checks against actual code | Keeps current | Checks relevance |

**Planner** reads ARCHITECTURE.md and living docs to understand the system before planning. Seeds ARCHITECTURE.md and PRINCIPLES.md if the project doesn't have them yet.

**Builder** updates living docs after implementation — if you changed how something works, update or create the relevant doc. If the system shape changed, update ARCHITECTURE.md.

**Verifier** checks that living docs still match the code they describe.

**Gardener** audits living docs against reality, removes stale content, flags gaps. Keeps ARCHITECTURE.md and PRINCIPLES.md honest.
