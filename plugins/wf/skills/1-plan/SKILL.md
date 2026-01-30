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

## Task
$ARGUMENTS

---

## Argument Parsing
Parse $ARGUMENTS:
- `{planname}` alone: Create a master plan for the project. {planname} is the target plan.
- `{planname} --sub NN_{name}`: Create a targeted sub-plan (one verifiable, testable component) for a scertain part of {planname}. {name} is the target sub plan. NN is a number 01, 02 so on for the ordering of sub plans.
- Empty: Show existing plans and ask what to plan

If there is a similar plan to the target plan in `**/plans/*` you should ask the user if that is the correct plan. If it is you should check if your working copy of the plan document alignts with this plan. If it doesn't you should copy the target plan onto your working plan document. This is done because you do not have edit abilities to the plans in ``**/plans/*``. Make sure to also read the corresponding deviation doc for the

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
