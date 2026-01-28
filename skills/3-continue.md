---
name: 3-continue
description: Continue working on the current task
argument-hint: "{planname}[/NN] [from step]"
disable-model-invocation: true
---
## Existing Plans & Progress
!`for d in plans/*/; do [ -d "$d" ] && echo "=== $(basename $d) ===" && grep -rE "^\s*-\s*\[" "$d" 2>/dev/null | head -5; done 2>/dev/null || echo "No plans yet"`

## Resume From
$ARGUMENTS

---

Continue where you left off.

## Plan Loading
Parse $ARGUMENTS to find plan:
- `{planname}` → Load `plans/{planname}/scope.md`
- `{planname}/NN` → Load `plans/{planname}/NN_*.md` (e.g., `myplan/01`)
- If no planname, show existing plans above and ask which to continue

Read the plan file to understand current progress.

## Process
1. Check progress markers (`[x]` vs `[ ]`) in plan file
2. Find next incomplete step
3. If sub-plan complete, prompt to move to next sub-plan
4. If argument specifies step, start from there

Look at:
1. What was the last thing done? (last `[x]` item)
2. What's the next step in the plan? (first `[ ]` item)
3. Are there any blockers?

If context is unclear, summarize your understanding and confirm before continuing.

Same rules apply:
- Follow the plan
- Discuss deviations (document in `deviation_{scope|NN}.md`)
- Keep code simple
- Break up big things
- Mark steps `[x]` as you complete them
