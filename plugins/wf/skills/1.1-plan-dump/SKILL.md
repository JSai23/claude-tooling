---
name: 1.1-plan-dump
description: Dump plan from plan mode to disk
argument-hint: "{planname} [--sub name]"
disable-model-invocation: true
---
## Current Plans
!`ls -la plans/*/*.md 2>/dev/null || echo "No plans yet"`

## Arguments
$ARGUMENTS

---

Save the plan document from plan mode to the proper location.

## Directory Structure

```
plans/{planname}/
├── scope.md              # Master plan (always exists)
├── 01_feature.md         # Sub-plan 1
├── 02_api.md             # Sub-plan 2
├── deviation_scope.md    # Deviations from master plan
└── deviation_01.md       # Deviations from sub-plan 01
```

## Determine Plan Type

From the original `/1-plan` invocation:
- `/1-plan myproject` → Master plan → `scope.md`
- `/1-plan myproject --sub auth` → Sub-plan → `NN_auth.md`

## Dump Process

### 1. Create Directory
```bash
mkdir -p plans/{planname}
```

### 2. Save Master Plan
File: `plans/{planname}/scope.md`

Content: The full plan document from plan mode, unmodified.

### 3. Save Sub-Plan
File: `plans/{planname}/NN_{name}.md`

Find next available number:
```bash
ls plans/{planname}/[0-9][0-9]_*.md 2>/dev/null | tail -1
```
- If none exist, use `01_`
- Otherwise increment (01 → 02 → 03...)

### 4. Create Deviation Doc

Always create alongside the plan file.

File: `plans/{planname}/deviation_{scope|NN}.md`

Template:
```markdown
# Deviations: {planname}/{scope|NN}

## [YYYY-MM-DD] Deviation: {title}

### Original Plan
{what the plan said}

### Actual Implementation
{what was done instead}

### Reason
{why the change was necessary}

### Impact
{effect on other sub-plans, if any}
```

## Checklist Format

Plans should use `[ ]` checkboxes for steps:
```markdown
## Implementation Steps

- [ ] Step 1: Description
- [ ] Step 2: Description
- [ ] Step 3: Description
```

Mark complete with `[x]` during implementation.
