---
name: create-handoff
description: Create session handoff document for transferring work to another session
disable-model-invocation: true
---
## Git Context
- Branch: !`git branch --show-current 2>/dev/null || echo "not a git repo"`
- Recent commits: !`git log --oneline -10 2>/dev/null || echo "no commits"`
- Changed files: !`git status --short 2>/dev/null || echo ""`

## Session ID
${CLAUDE_SESSION_ID}

---

Create a handoff document for the next session.

## Handoff Location
Save to: `.handoffs/YYYY-MM-DD_HH-MM_<short-description>.yaml`
(Example: `.handoffs/2026-01-24_14-30_auth-implementation.yaml`)

## Schema
```yaml
---
date: YYYY-MM-DD
status: complete | partial | stuck | transient
---

goal: |
  What was the larger goal of this session?
  What were we ultimately trying to achieve?

current_state: |
  Where did we end up?
  What's the current state of the work?
  What skill was used in terms of state - planning, implementing, reviewing etc?

# If stuck
stuck_on: |
  What specific problem is blocking progress?
  What have we tried that didn't work?

# If goals shifted
transient: false  # or true
transient_reason: |
  Why did the goals shift? What new direction emerged?

# CRITICAL: Learnings
learned:
  - insight: What we discovered
    details: Specifics about the learning

worked:
  - approach: What worked well
    why: Why it worked

didnt_work:
  - approach: What we tried that failed
    why: Why it failed, what to avoid

# Forward-looking
next_approach: |
  Given what we learned, what should we try next?
  What's the recommended path forward?

next_steps:
  - First concrete action
  - Second concrete action

# Auto-populated from git context above
git:
  branch: <from context>
  recent_commits:
    - <from context>
  changed_files:
    - <from context>

# Optional
questions: []      # Unresolved questions
decisions: []      # Key decisions made
files_to_read: []  # Files next session should read first
```

Fill this out based on our session. Be honest about stuck points and what didn't work.
