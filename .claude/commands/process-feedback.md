---
description: Triage and implement plugin feedback from GitHub issues
---

Process open plugin feedback issues and turn them into improvements.

## Step 1: Pull Issues

```bash
gh issue list --repo JSai23/claude-tooling --label plugin-feedback --state open --json number,title,body,createdAt
```

If no open issues, say so and stop.

## Step 2: Present

Show a numbered summary:
```
1. #42 — wf/planner: Doesn't check for existing tests
2. #43 — util/doc: Monorepo support missing
3. #44 — vault/auto-process: Tags not validated against vocabulary
```

Ask the user what they want to do:
- **Triage all** — review each for actionability, scope, duplicates
- **Pick one** — jump to a specific issue number to implement
- **Skip** — mark an issue as wontfix/duplicate

## Step 3: Triage (if requested)

For each issue, assess:
- **Actionable?** — Is there a clear change to make?
- **Scope** — Small fix, medium enhancement, or large redesign?
- **Duplicates?** — Does another issue cover the same ground?
- **Affected files** — Which plugin files would change?

Present the triage summary and let the user decide what to tackle.

## Step 4: Implement One at a Time

For the selected issue:

1. **Read the affected file(s)** — understand current state
2. **Design the change** — propose what to modify and why
3. **Confirm with user** — don't edit without agreement
4. **Make the change** — use the appropriate plugin-dev skills when modifying plugin files:
   - `/plugin-dev:skill-development` for skill changes
   - `/plugin-dev:agent-development` for agent changes
   - `/plugin-dev:hook-development` for hook changes
   - `/plugin-dev:plugin-structure` for structural changes
5. **Verify** — run any relevant validation

## Step 5: Discuss

After each change, pause:
- Explain what changed and why
- Ask if the user wants to adjust anything
- Surface anything related you noticed while in the file

## Step 6: Close

When a change is agreed upon and implemented:
```bash
gh issue close <number> --repo JSai23/claude-tooling --comment "Resolved in this session. <brief summary of what changed>"
```

## Step 7: Repeat

Go back to the issue list. Continue until the user stops or all issues are handled.
