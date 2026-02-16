# WF Plugin Architecture

## Agent → Skill Map

```
┌─────────────────────────────────────────────────────────────────────┐
│                        COMMON SKILLS                                │
│                                                                     │
│  common-design-docs-k        common-testing-k                       │
│  (doc system, folder         (test philosophy,                      │
│   structure, frontmatter,     anti-patterns,                        │
│   agent roles, lifecycle)     coverage priorities)                  │
│                                                                     │
│  Loaded by: ALL agents       Loaded by: builder, verifier           │
└─────────────────────────────────────────────────────────────────────┘

┌─────────────────────┐  ┌─────────────────────┐
│      PLANNER        │  │      BUILDER        │
│                     │  │                     │
│  Role:              │  │  Role:              │
│  Everything before  │  │  Implement from     │
│  code — design &    │  │  plans, write tests,│
│  implementation     │  │  maintain living     │
│  planning           │  │  docs               │
│                     │  │                     │
│  Skills:            │  │  Skills:            │
│  ┌─────────────────┐│  │  ┌─────────────────┐│
│  │ planner-design-k││  │  │ builder-        ││
│  │ (product, system││  │  │  conventions-k  ││
│  │  code-level     ││  │  │ (deviation,     ││
│  │  design, trade- ││  │  │  progress,      ││
│  │  offs)          ││  │  │  code standards,││
│  ├─────────────────┤│  │  │  reflection)    ││
│  │ planner-        ││  │  └─────────────────┘│
│  │  implementation-││  │                     │
│  │  k              ││  │                     │
│  │ (milestones,    ││  │  Subagents: none    │
│  │  sequencing,    ││  │                     │
│  │  acceptance)    ││  │  Produces:          │
│  └─────────────────┘│  │  · production code  │
│                     │  │  · tests            │
│  Subagents: none    │  │  · updated plan     │
│                     │  │  · living docs      │
│  Produces:          │  │                     │
│  · design plans     │  └─────────────────────┘
│  · implementation   │
│    plans            │
│  · decisions.md     │
│                     │
└─────────────────────┘

┌─────────────────────┐  ┌─────────────────────┐
│     VERIFIER        │  │     GARDENER        │
│                     │  │                     │
│  Role:              │  │  Role:              │
│  End-of-cycle       │  │  Continuous cleanup  │
│  quality review,    │  │  of LLM-generated   │
│  delegates via      │  │  debt in code and   │
│  Task tool          │  │  docs               │
│                     │  │                     │
│  Skills:            │  │  Skills:            │
│  ┌─────────────────┐│  │  ┌─────────────────┐│
│  │ verify-quality-a││  │  │ gardener-       ││
│  │ (dimensions,    ││  │  │  standards-k    ││
│  │  severity,      ││  │  │ (freshness,     ││
│  │  grading,       ││  │  │  completeness,  ││
│  │  prod readiness)││  │  │  cross-linking, ││
│  ├─────────────────┤│  │  │  priorities)    ││
│  │ verify-larp-a   ││  │  └─────────────────┘│
│  │ (fake code,     ││  │                     │
│  │  red flags)     ││  │  Produces:          │
│  ├─────────────────┤│  │  · cleaned code     │
│  │ verify-style-a  ││  │  · updated docs     │
│  │ (AI slop, dead  ││  │  · garden report    │
│  │  code, naming)  ││  │                     │
│  ├─────────────────┤│  │  Model: sonnet      │
│  │ verify-design-a ││  │                     │
│  │ (architecture   ││  └─────────────────────┘
│  │  review)        ││
│  └─────────────────┘│
│                     │
│  Produces:          │
│  · verification.md  │
│                     │
└─────────────────────┘
```

## Workflow Flow

```
         ┌──────────┐
         │ PLANNER  │──── creates ────► design-docs/plans/{name}/{name}_plan.md
         └────┬─────┘                   design-docs/plans/{name}/{name}_decisions.md
              │
              │ user starts builder session
              ▼
         ┌──────────┐
         │ BUILDER  │──── updates ────► {name}_plan.md (progress, surprises)
         └────┬─────┘     creates ────► living docs near code
              │            updates ────► ARCHITECTURE.md (if shape changed)
              │
              │ user starts verifier session
              ▼
         ┌──────────┐
         │ VERIFIER │──── creates ────► design-docs/plans/{name}/{name}_verification.md
         └────┬─────┘     delegates ──► 4 verification passes via Task tool
              │
              │ ongoing / as needed
              ▼
         ┌──────────┐
         │ GARDENER │──── updates ────► ARCHITECTURE.md, PRINCIPLES.md
         └──────────┘     fixes ──────► stale living docs, dead code
                          marks ──────► completed plans
```

## User-Invokeable Skills

```
/wf:doc-a [type]           Generate or update standard code documentation (docstrings, rustdoc, API refs)
/wf:logging-a [type]       Log decisions, progress, deviations, discoveries
```

## Design-Docs Folder Structure

```
design-docs/                            # System-level (repo root)
├── plans/                              # ALL plans — centralized (foresight)
│   └── {name}/
│       ├── {name}_plan.md
│       ├── {name}_decisions.md
│       ├── {name}_verification.md
│       └── {sub-plan}/{sub-plan}_plan.md
│
├── ARCHITECTURE.md                     # System map — entry point
├── PRINCIPLES.md                       # Golden rules
└── {topic}.md                          # System-level living docs (hindsight)

{package}/design-docs/                  # Package-level living docs
{test-dir}/design-docs/                 # Test-level living docs
```
