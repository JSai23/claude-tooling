---
name: util-improve
description: >
  |
metadata:
  source-plugin: util
  source-skill: improve
---

## Feedback Context
$ARGUMENTS

---

Capture plugin feedback from this session and file it as a GitHub issue.

## Step 1: Reflect

Look back at the session. Identify:
- What went wrong or caused friction
- What the user had to correct or override
- What was missing that should exist
- What was misleading in agent/skill prompts

If $ARGUMENTS is provided, start from that. Otherwise, review the session for friction points.

## Step 2: Filter — Generic vs Repo-Specific

This is the critical gate. Ask: **"Would this feedback help a different project using these plugins?"**

**Generic** (file it):
- Planner doesn't check for existing tests before proposing new ones
- /doc skill doesn't handle monorepos
- Verifier misses import-only changes

**Repo-specific** (don't file — belongs in CLAUDE.md):
- Custom auth headers, tool preferences (pnpm vs npm), project-specific test flags
- Exception: if the same repo-specific issue keeps appearing across projects, it's generic

## Step 3: Distill

For each piece of generic feedback, structure it:
- **Plugin/skill/agent affected** — which specific component (e.g., `wf:planner`, `util:doc`, `vault:auto-process`)
- **Current behavior** — what happened
- **Expected behavior** — what should have happened
- **Session context** — what project, what task, what conditions triggered it

Group related feedback for the same plugin/agent cluster into one issue. Separate unrelated clusters into separate issues.

## Step 4: File

For each issue, use:
```bash
gh issue create \
  --repo JSai23/claude-tooling \
  --label plugin-feedback \
  --title "<plugin>: <concise summary>" \
  --body "<structured feedback from step 3>"
```

Issue body format:
```markdown
## Affected Component
<plugin>/<skill or agent> (e.g., wf/planner, util/doc)

## Current Behavior
<what happened>

## Expected Behavior
<what should have happened>

## Context
- **Project:** <what kind of project>
- **Task:** <what the user was doing>
- **Conditions:** <anything relevant about when/how this triggered>

## Notes
<any additional context, workarounds used, severity>
```

## Step 5: Report

Show the user:
- Issue URL(s) created
- Summary of what was filed
- Any feedback that was filtered out as repo-specific (and where it should go instead)
