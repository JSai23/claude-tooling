# Review Brief

You are verifying that every behavioral block in `docs/plans/agent-loop-upgrade.md` is fully implemented.

## How to Review

1. Read the entire plan at `docs/plans/agent-loop-upgrade.md`.
2. For each of the 10 blocks, verify the implementation exists and matches the plan's specification. Check every detail — not just "does a file exist" but "does the file do what the plan says."
3. Read every file in `agents-src/` and `plugins/` that relates to the agent loop.
4. Compare plan vs reality. Document gaps.

## Block-by-Block Verification

For each block, state:
- **Implemented?** Yes / Partial / No
- **Evidence:** What files implement it, what behavior matches the plan
- **Gaps:** What's missing or diverges from the plan

Cover all 10 blocks:
1. Core Loop Hardening
2. Loop Isolation
3. Unified Tracking Log
4. Agent-Written Session Prompts (loop-author guide)
5. Distribution Model
6. Cross-Repo Loop Visibility
7. Git-Committed Loop Intelligence
8. Branching & PR-per-Iteration
9. Loop Management Skills
10. Archival

## Done Condition

Write STOP.txt when:
- All 10 blocks are verified as fully implemented per the plan
- The plugin skills compile successfully (`uv run tools/compile-prompts.py`)
- No significant gaps remain between plan and implementation
- Code is clean and follows existing patterns

Do NOT stop if blocks are partially implemented or missing. Do NOT stop if the worker hasn't addressed your feedback.
