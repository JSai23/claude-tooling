---
name: 1-plan
description: Research and planning before implementation
argument-hint: "{planname} [--sub name]"
disable-model-invocation: true
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

## Argument Parsing
Parse $ARGUMENTS:
- `{planname}` alone: Create a master plan for the project
- `{planname} --sub {name}`: Create a targeted sub-plan (one verifiable, testable component)
- Empty: Show existing plans and ask what to plan

The user decides whether this is a master plan or a sub-plan. Do not create sub-plans inside a master plan or vice versa. Each invocation produces exactly one plan document.

## Planning Requirements

### 1. Clarify Goals
- What exactly needs to be built?
- What problem does it solve?
- What are the acceptance criteria?

### 2. Present Approaches (2-3 options)
For each major decision:
- State the decision clearly
- Present 2-3 realistic approaches
- For each approach:
  - What it offers (benefits)
  - What it costs (tradeoffs)
  - How to mitigate downsides
- Your recommendation with rationale
- Unknowns and risks

### 3. Design Before Code
- **Diagrams first**: ASCII flowcharts, sequence diagrams
- **Component relationships**: Class diagrams, module dependencies
- **Data flow**: How information moves through the system
- Code snippets ONLY for illustrating complexity tradeoffs

### 4. Identify Risks
- What could go wrong?
- What unknowns remain?
- What dependencies might change?

Ask clarifying questions rather than assuming. Do not simplify or stub.
