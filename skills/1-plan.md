---
name: 1-plan
description: Research and planning before implementation
disable-model-invocation: true
context: fork
agent: planner
---
## Git Context
- Branch: !`git branch --show-current 2>/dev/null || echo "not a git repo"`
- Recent commits: !`git log --oneline -5 2>/dev/null || echo "no commits"`
- Changed files: !`git status --short 2>/dev/null || echo ""`

## Codebase Structure
!`tldr tree . --ext .py,.ts,.js 2>/dev/null | head -40 || find . -name "*.py" -o -name "*.ts" | head -20`

## Task
$ARGUMENTS

---

Use plan mode. Research the problem space before proposing solutions.

## Planning Requirements:

### 1. Clarify Goals
- What exactly needs to be built?
- What problem does it solve?
- What are the acceptance criteria?

### 2. Present Approaches (2-3 options)
For each approach:
- What it offers (benefits)
- What it costs (tradeoffs)
- How to mitigate downsides
- Your recommendation with rationale

### 3. Design Before Code
- **Diagrams first**: ASCII flowcharts, sequence diagrams
- **Component relationships**: Class diagrams, module dependencies
- **Data flow**: How information moves through the system
- Code snippets ONLY for illustrating complexity tradeoffs

### 4. Identify Risks
- What could go wrong?
- What unknowns remain?
- What dependencies might change?

## Output
Save plan to: `plans/YYYYMMDD_<short-description>.md`
(Example: `plans/20260124_add-auth.md`)

Ask clarifying questions rather than assuming. Do not simplify or stub.
