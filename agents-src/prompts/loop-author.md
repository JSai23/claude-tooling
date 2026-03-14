# Loop Author Guide

How to write session prompts that produce effective agent loops. This guide is for both humans and agents authoring SESSION_WORKER.md and SESSION_REVIEWER.md.

## Session Prompt Anatomy

Every session prompt has four sections. In this order.

### 1. Objective

What is the end goal? What is the output? Single paragraph. No ambiguity.

The objective is the north star for the entire loop. Every decision the worker makes and every review the reviewer gives traces back to this paragraph. If the objective is vague, the loop will wander.

**Good:** "Build a CLI tool in `src/cli/` that validates YAML config files against a JSON schema. Output should match the existing linter format in `tools/lint`."

**Bad:** "Improve the config validation system."

### 2. Context

What exists today? What repo/files matter? What has been tried? What constraints exist?

Point agents to the specific files, directories, and existing patterns they need to understand. Don't make them search — tell them where to look.

**Include:**
- Key files and directories
- Existing patterns to follow
- What has already been attempted (to avoid rework)
- Hard constraints (language, dependencies, compatibility)

### 3. Behavior Targets

Conceptual, observable goals — not implementation steps.

Behavior targets describe what should be true when the work is done. They are written from the perspective of someone testing the system, not someone building it.

**Good:** "Users can log in with SSO and see their dashboard within 3 seconds."

**Bad:** "Add OAuthProvider class with getToken() method."

Each target should be independently verifiable. The reviewer uses these to decide when work is complete.

### 4. Acceptance Criteria

How the reviewer knows this is done. Observable, verifiable conditions.

These are stricter than behavior targets — they're the minimum bar for STOP. If even one criterion isn't met, the loop continues.

**Good:**
- All tests pass (`cargo test`)
- No new warnings in `cargo clippy`
- The migration runs cleanly on a fresh database

**Bad:**
- Code is clean
- Everything works

## What Session Prompts Do NOT Include

- **Decomposition into steps.** The worker and reviewer handle task breakdown via TODO.md. The session prompt defines *what*, not *how*.
- **Implementation approach.** Don't prescribe architecture, file structure, or algorithms. Let the worker decide and the reviewer course-correct.
- **Code snippets.** Session prompts are strategic, not tactical.
- **Meta-instructions about the loop.** The session/worker/reviewer prompts already handle agent behavior. Don't duplicate them.

## Writing the Reviewer Prompt

The reviewer prompt describes the same objective but from the reviewer's perspective. It reads like a code review brief:

- What to verify at each iteration
- What quality means for this specific task
- What to watch for (common failure modes, known risks)
- When to stop — what "done" looks like

The reviewer prompt should be shorter than the worker prompt. Reviewers need clarity, not volume.

## Template: SESSION_WORKER.md

```markdown
# Objective

{One paragraph. What is the end goal?}

{Optional: Read X, Y, Z before starting.}

## Context

{What exists today. Key files. Constraints. Prior work.}

## Behavior Targets

When this is done, the following should be true:

1. {Observable behavior 1}
2. {Observable behavior 2}
3. ...

## Acceptance Criteria

- {Verifiable condition 1}
- {Verifiable condition 2}
- ...

## Constraints

- {Hard constraint 1}
- {Hard constraint 2}
```

## Template: SESSION_REVIEWER.md

```markdown
# Review Brief

You are reviewing progress toward: {one-line objective summary}

## What to Verify

- {Verification point 1}
- {Verification point 2}

## Quality Bar

- {What good looks like for this task}

## Watch For

- {Known risk or failure mode 1}
- {Known risk or failure mode 2}

## Done Condition

Write STOP.txt when:
- {Specific, observable condition 1}
- {Specific, observable condition 2}
```

## Common Mistakes

| Mistake | Why it hurts | Fix |
|---------|-------------|-----|
| Vague objective | Worker wanders, reviewer can't judge done | One paragraph, no ambiguity |
| Steps instead of goals | Worker follows recipe instead of thinking | Describe *what*, not *how* |
| No acceptance criteria | Reviewer has no basis for STOP | List verifiable conditions |
| Reviewer prompt copies worker prompt | Reviewer doesn't know its role | Write from reviewer perspective |
| Too much context | Agents drown in text, miss what matters | Only include what's needed to start |
