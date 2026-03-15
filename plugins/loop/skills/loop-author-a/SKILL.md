---
name: loop-author-a
type: action
description: |
  Write high-quality session prompts (SESSION_WORKER.md and SESSION_REVIEWER.md) for an agent loop.
  Reads repo context and follows the loop-author guide to produce targeted, effective prompts.
  Use when setting up a new loop or rewriting session prompts for an existing one.
argument-hint: "[loop-id] [task description]"
---

> **Action skill** — Write session prompts for agent loops following the loop-author guide.

## Input
$ARGUMENTS

---

Write SESSION_WORKER.md and SESSION_REVIEWER.md for an agent loop. These prompts define what the loop accomplishes and how the reviewer evaluates completion.

## Gather Context

Before writing, read these sources to understand the repo and task:

### 1. Repo Context

```bash
# Project instructions
cat CLAUDE.md 2>/dev/null
cat .claude/CLAUDE.md 2>/dev/null

# Recent work
git log --oneline -20

# Repo structure (top-level)
ls -la
```

### 2. Task Context

From `$ARGUMENTS`, extract:
- **What** the loop should accomplish
- **Where** in the codebase the work lives
- **Why** this work matters (if stated)
- **Constraints** (language, patterns, dependencies)

### 3. Loop Author Guide

Follow the session prompt anatomy from `agents/prompts/loop-author.md` (or `~/claude-tooling/agents-src/prompts/loop-author.md`). The four required sections are:

1. **Objective** — single paragraph, no ambiguity
2. **Context** — key files, existing patterns, constraints
3. **Behavior Targets** — observable goals, not implementation steps
4. **Acceptance Criteria** — verifiable conditions for STOP

## Write SESSION_WORKER.md

```markdown
# Objective

{One paragraph. What is the end goal? What is the output?}

{Read X, Y, Z before starting — point to specific files.}

## Context

{What exists today. Key files and directories. Existing patterns to follow.
What has been tried. Hard constraints.}

## Behavior Targets

When this is done, the following should be true:

1. {Observable behavior — written from a tester's perspective}
2. {Observable behavior}
3. ...

## Acceptance Criteria

- {Verifiable condition — the minimum bar}
- {Verifiable condition}
- ...

## Constraints

- {Hard constraint — language, patterns, dependencies}
- {Hard constraint}
```

### Worker Prompt Principles

- **Objective is the north star.** If the objective is vague, the loop wanders. Be specific.
- **Point to files, not concepts.** "Read `src/auth/middleware.ts`" not "understand the auth system."
- **Behavior targets are observable.** "Users can log in with SSO" not "Add OAuthProvider class."
- **No decomposition.** Don't tell the worker how to break down the work — that's what TODO.md is for.
- **No code snippets.** Session prompts are strategic, not tactical.

## Write SESSION_REVIEWER.md

```markdown
# Review Brief

You are reviewing progress toward: {one-line objective summary}

## What to Verify

- {Verification point — what to check at each iteration}
- {Verification point}

## Quality Bar

- {What good looks like for this specific task}
- {Standards that apply — tests, linting, patterns}

## Watch For

- {Known risk or failure mode}
- {Common mistake for this type of work}

## Done Condition

Write STOP.txt when:
- {Specific, observable condition}
- {Specific, observable condition}
```

### Reviewer Prompt Principles

- **Same objective, different perspective.** The reviewer sees the same goal but evaluates rather than builds.
- **Shorter than the worker prompt.** Reviewers need clarity, not volume.
- **Concrete done conditions.** "All tests pass" not "code is clean."
- **Watch-for items are specific.** "Over-engineering the error handling" not "bad code."

## Output Location

Write the prompts to:
```
agents/loops/{loop-id}/session/SESSION_WORKER.md
agents/loops/{loop-id}/session/SESSION_REVIEWER.md
```

Create the directory structure if it doesn't exist:
```bash
mkdir -p agents/loops/{loop-id}/session
```

## After Writing

1. Show the user both prompts for review
2. Ask if they want to adjust anything before launch
3. If they're satisfied, suggest launching with `loop-launch-a` or directly:
   ```bash
   ./agents/run.sh --loop-id {loop-id}
   ```

## Common Mistakes to Avoid

| Mistake | Fix |
|---------|-----|
| Vague objective | One paragraph, no ambiguity — name the output |
| Steps instead of goals | Describe *what*, not *how* |
| No acceptance criteria | List verifiable conditions |
| Reviewer copies worker | Write from reviewer perspective — it's a review brief |
| Too much context | Only include what's needed to start work |
| Implementation approach in prompt | Let the worker decide, reviewer course-correct |
