---
name: util-resume-handoff
description: >
  Resume work from a previous handoff document
metadata:
  source-plugin: util
  source-skill: resume-handoff
---

Input Handoff:
If this is populated use this handoff file if this is empty use the autosuggested handoff file
$ARGUMENTS

Resume from the handoff above.

## Process
1. **Review the handoff** - goal, current state, learnings
2. **Check git** - any commits since handoff? Any uncommitted work?
3. **Summarize for user**:
   - Where we left off
   - What was learned (worked/didn't work)
   - Recommended next approach
4. **Confirm with user** before starting work

If the handoff suggests we were stuck, acknowledge the blocker and ask if user wants to:
- Continue with the suggested next_approach
- Try a different approach
- Get help with the blocker

Don't just start working. Confirm direction first.
