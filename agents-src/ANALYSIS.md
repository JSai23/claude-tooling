# System Analysis — Flow, Gaps, and Suggestions

## The Architecture

Two primitives. That's it.

```
┌─────────────────────────────────────────────────────┐
│                   COMPOSITION MODEL                  │
│                                                     │
│   session.md           (shared rules, all agents)   │
│       ↓                                             │
│   worker.md  OR  reviewer.md   (primitive role)     │
│       ↓                                             │
│   [specialization].md          (optional layer)     │
│       ↓                                             │
│   [invocation inputs]          (task, manifesto…)   │
└─────────────────────────────────────────────────────┘
```

Every agent in the system is either a worker or a reviewer. Specializations don't create new primitives — they layer domain knowledge on top.

**Examples:**

| Agent | = | Primitive | + Specialization | + Inputs |
|-------|---|-----------|------------------|----------|
| Plan writer | | worker | planner.md | manifesto, user thoughts, plan file |
| Plan reviewer | | reviewer | (plan-review focus in invocation) | same manifesto, plan file |
| Rust executor | | worker | rust-executor.md | task file, plan reference |
| Code reviewer | | reviewer | (code-review focus in invocation) | same task context |

## The Loop

```
    ┌─────────────────────────────────────────────┐
    │            RUNNER SCRIPT (bash)              │
    │   Concatenates prompts, alternates agents    │
    └──────┬───────────────────────┬──────────────┘
           │                       │
    ┌──────▼──────┐         ┌──────▼──────┐
    │   WORKER    │         │  REVIEWER   │
    │             │         │             │
    │ Reads:      │         │ Reads:      │
    │  TASK input │         │  TASK input │
    │  FEEDBACK   │         │  Worker's   │
    │  DONEXT     │         │  output +   │
    │  MEMORY     │         │  all state  │
    │  TODO       │         │             │
    │             │         │ Writes:     │
    │ Writes:     │         │  FEEDBACK   │
    │  Code       │         │  DONEXT     │
    │  MEMORY     │         │  STOP.txt?  │
    │  PROGRESS   │         │             │
    │  TODO       │         │             │
    │  STOP.txt?  │         │             │
    └─────────────┘         └─────────────┘
           │                       │
           └──────────┬────────────┘
                      │
                 agents/ dir
           (gitignored, ephemeral)
```

Repeats until STOP.txt appears.

---

## What's Solid

1. **Two-primitive constraint** is clean and composable. No role confusion, no third category.
2. **File-based continuity** — simple, debuggable, no shared memory or APIs.
3. **Specialization as layering** — same script, same loop, different prompts. New specializations don't require new infrastructure.
4. **Reviewer personality** — opinionated in the right ways.
5. **Planning decomp process** — manifesto → decomp → design → scaffolding → blocks is thorough.

---

## Gaps

### 1. Runner script doesn't exist
The glue that makes it all work. Needs to:
- Concatenate session + primitive + specialization prompts
- Alternate worker ↔ reviewer invocations
- Check for STOP.txt between iterations
- Pass task-specific inputs
- Capture transcripts

### 2. Prompt composition mechanics
Each invocation = session.md + primitive + specialization + task inputs. The runner needs to assemble these. Options:
- `cat` files together into a temp file, pass via `--system-prompt-file`
- For Codex: inline the concatenated content in the exec prompt (since Codex uses AGENTS.md for persistent system-level stuff)

### 3. Task input mechanism
Who writes the initial task file? How does a plan become task inputs for the execution loop? This bridge is undefined.

### 4. Worker ↔ reviewer handoff
What exactly does the reviewer see from the worker? The doc says "full transcription will be made available" — mechanism unspecified. Options:
- Pipe worker stdout/json to a file the reviewer reads
- Reviewer just reads agents/ dir (MEMORY, PROGRESS, TODO, code diffs)
- Both

### 5. Runtime assignment (Claude vs Codex)
The original doc says: Claude for plan writing, Codex for reviewing. But the prompts themselves shouldn't hardcode which runtime they run on — that's the runner script's job. Currently unspecified where this decision lives.

### 6. No error recovery
If a worker crashes mid-run, continuity files may be half-written. Options:
- Git-commit agents/ state between iterations
- Runner checks: did PROGRESS.md get updated? If not, flag the error.

### 7. PROGRESS.md lifecycle
Who reads it first before the worker overwrites it? Currently the worker prompt says "read then overwrite" — but if the reviewer needs to see last worker's progress, does the reviewer run *before* the next worker wipes it? (Yes — the loop is worker → reviewer → worker, so reviewer always sees the worker's PROGRESS.md before the next worker overwrites it. This is fine as long as the loop order is guaranteed.)

---

## Suggested Next Steps

### A. Build the runner script
Minimal viable version:

```bash
#!/bin/bash
set -euo pipefail

AGENTS_DIR="./agents"
PROMPTS_DIR="./agents/prompts"
MAX_ITERATIONS="${MAX_ITERATIONS:-10}"

# These get passed in or configured
WORKER_SPECIALIZATION="${WORKER_SPEC:-}"    # e.g., planner.md
REVIEWER_SPECIALIZATION="${REVIEWER_SPEC:-}" # e.g., plan-reviewer.md
TASK_PROMPT="$1"  # The task-specific prompt/instruction

mkdir -p "$AGENTS_DIR/archive" "$AGENTS_DIR/transcripts"

compose_prompt() {
  local role="$1"      # worker.md or reviewer.md
  local spec="$2"      # specialization file (optional)
  cat "$PROMPTS_DIR/session.md" "$PROMPTS_DIR/$role"
  [ -n "$spec" ] && [ -f "$PROMPTS_DIR/$spec" ] && cat "$PROMPTS_DIR/$spec"
}

for i in $(seq 1 "$MAX_ITERATIONS"); do
  echo "=== Iteration $i: Worker ==="

  claude -p \
    --dangerously-skip-permissions \
    --system-prompt-file <(compose_prompt worker.md "$WORKER_SPECIALIZATION") \
    --max-turns 30 \
    --output-format json \
    "$TASK_PROMPT" \
    > "$AGENTS_DIR/transcripts/worker_$(printf '%03d' $i).json"

  [ -f "$AGENTS_DIR/STOP.txt" ] && echo "Worker stopped at iteration $i." && break

  echo "=== Iteration $i: Reviewer ==="

  codex exec \
    --full-auto \
    --json \
    "$(compose_prompt reviewer.md "$REVIEWER_SPECIALIZATION")

    $TASK_PROMPT

    Review the current state in $AGENTS_DIR/ and output FEEDBACK.md and/or DONEXT.md." \
    > "$AGENTS_DIR/transcripts/reviewer_$(printf '%03d' $i).json"

  [ -f "$AGENTS_DIR/STOP.txt" ] && echo "Reviewer stopped at iteration $i." && break
done
```

### B. Define runtime assignment convention
Put it in the runner script config, not the prompts. Something like:

```bash
WORKER_RUNTIME="claude"   # or "codex"
REVIEWER_RUNTIME="codex"  # or "claude"
```

The prompts stay runtime-agnostic. The runner picks which CLI to invoke.

### C. Build one concrete specialization end-to-end
Pick something real (the Rust Polymarket planner). Wire it up:
1. Write `planner.md` specialization (done)
2. Write the MANIFESTO.md and USER_THOUGHTS.md
3. Run the loop
4. See what breaks, iterate

### D. Decide on the plan → execution bridge
When planning finishes, how does the output become task input for an execution loop? Simplest: the plan file itself IS the task input for the executor worker.
