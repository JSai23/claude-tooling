# WF Plugin Architecture

## Agent → Skill → Subagent Map

```
┌─────────────────────────────────────────────────────────────────────┐
│                        COMMON SKILLS                                │
│                                                                     │
│  common-design-docs          common-testing                         │
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
│  │ planner-design  ││  │  │ builder-        ││
│  │ (product, system││  │  │  conventions    ││
│  │  code-level     ││  │  │ (deviation,     ││
│  │  design, trade- ││  │  │  progress,      ││
│  │  offs)          ││  │  │  code standards,││
│  ├─────────────────┤│  │  │  reflection)    ││
│  │ planner-        ││  │  └─────────────────┘│
│  │  implementation ││  │                     │
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
│  delegates to       │  │  debt in code and   │
│  subagents          │  │  docs               │
│                     │  │                     │
│  Skills:            │  │  Skills:            │
│  ┌─────────────────┐│  │  ┌─────────────────┐│
│  │ verify-quality  ││  │  │ gardener-       ││
│  │ (dimensions,    ││  │  │  standards      ││
│  │  severity,      ││  │  │ (freshness,     ││
│  │  grading)       ││  │  │  completeness,  ││
│  ├─────────────────┤│  │  │  cross-linking, ││
│  │ verify-larp     ││  │  │  priorities)    ││
│  │ (fake code,     ││  │  └─────────────────┘│
│  │  red flags)     ││  │                     │
│  ├─────────────────┤│  │  Subagents: none    │
│  │ verify-style    ││  │                     │
│  │ (AI slop, dead  ││  │  Produces:          │
│  │  code, naming)  ││  │  · cleaned code     │
│  ├─────────────────┤│  │  · updated docs     │
│  │ verify-design   ││  │  · garden report    │
│  │ (architecture   ││  │                     │
│  │  review)        ││  │  Model: sonnet      │
│  └─────────────────┘│  │                     │
│                     │  └─────────────────────┘
│  Subagents:         │
│  ┌─────────────────┐│
│  │ verify-design-  ││
│  │  auditor        ││
│  │ verify-larp-    ││
│  │  detector       ││
│  │ verify-code-    ││
│  │  cleaner        ││
│  │ verify-         ││
│  │  production-    ││
│  │  reviewer       ││
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
         │ PLANNER  │──── creates ────► design-docs/plans/{name}/plan.md
         └────┬─────┘                   design-docs/plans/{name}/decisions.md
              │
              │ user starts builder session
              ▼
         ┌──────────┐
         │ BUILDER  │──── updates ────► plan.md (progress, surprises)
         └────┬─────┘     creates ────► living docs near code
              │            updates ────► ARCHITECTURE.md (if shape changed)
              │
              │ user starts verifier session
              ▼
         ┌──────────┐
         │ VERIFIER │──── creates ────► design-docs/plans/{name}/verification.md
         └────┬─────┘     spawns ─────► 4 verify-* subagents
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
/wf:design-doc [scope]     Generate or update agent design documentation
/wf:logging [type]         Log decisions, progress, deviations, discoveries
```

## Design-Docs Folder Structure

```
design-docs/                            # System-level (repo root)
├── plans/                              # ALL plans — centralized (foresight)
│   ├── index.md
│   └── {name}/
│       ├── plan.md
│       ├── decisions.md
│       ├── verification.md
│       └── {sub-plan}/plan.md          # Nested child plans
│
├── ARCHITECTURE.md                     # System map — entry point
├── PRINCIPLES.md                       # Golden rules
└── {topic}.md                          # System-level living docs (hindsight)

{package}/design-docs/                  # Package-level living docs
{test-dir}/design-docs/                 # Test-level living docs
```
