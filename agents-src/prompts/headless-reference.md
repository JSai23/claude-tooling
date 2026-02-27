# Headless Execution Reference

How to run agents non-interactively with full auto-approval.

---

## Claude Code

### Basic headless execution
```bash
claude -p "your prompt here"
```

### YOLO mode (skip all permissions)
```bash
claude -p "your prompt" --dangerously-skip-permissions
```

### Load system prompt from file (replaces default)
```bash
claude -p --system-prompt-file ./agents/prompts/worker.md "your task prompt"
```

### Append instructions to default prompt (keeps Claude Code defaults)
```bash
claude -p --append-system-prompt-file ./agents/prompts/session.md "your task prompt"
```

### Control tools available
```bash
claude -p --allowedTools "Bash,Read,Edit,Grep,Glob,Write" "your prompt"
```

### Limit agentic turns and budget
```bash
claude -p --max-turns 20 --max-budget-usd 5.00 "your prompt"
```

### JSON output for scripting
```bash
claude -p --output-format json "your prompt" | jq -r '.result'
```

### Continue a previous session
```bash
session_id=$(claude -p "start task" --output-format json | jq -r '.session_id')
claude -p "continue" --resume "$session_id"
```

### Pipe context in
```bash
cat agents/FEEDBACK.md | claude -p "Address this feedback"
git diff | claude -p "Review these changes"
```

### Model selection
```bash
claude -p --model opus "complex task"
claude -p --model sonnet "quick task"
```

### Full worker invocation example
```bash
claude -p \
  --dangerously-skip-permissions \
  --append-system-prompt-file ./agents/prompts/session.md \
  --system-prompt-file ./agents/prompts/worker.md \
  --max-turns 30 \
  --output-format json \
  "Read DONEXT.md and FEEDBACK.md in agents/, then execute the task described in agents/TASK.md"
```

> **Note:** `--system-prompt-file` replaces the default; `--append-system-prompt-file` adds to it. You can't use both to layer two custom files — one replaces, one appends. To combine session + role, concatenate them into one file or use `--system-prompt-file` with a file that includes both.

---

## Codex CLI

### Basic headless execution
```bash
codex exec "your prompt here"
```

### Full auto mode (workspace-write sandbox, auto-approve)
```bash
codex exec --full-auto "your prompt"
```

### Nuclear YOLO (bypass all approvals AND sandbox)
```bash
codex exec --dangerously-bypass-approvals-and-sandbox "your prompt"
```

### Sandbox modes
```bash
codex exec --sandbox read-only "analyze only"          # Default for exec
codex exec --sandbox workspace-write "fix the code"    # Write inside repo
codex exec --sandbox danger-full-access "anything"     # Full system (VMs only)
```

### Approval modes
```bash
codex exec --ask-for-approval never "fully automated"
codex exec --ask-for-approval suggest "require approval for writes"
codex exec --ask-for-approval auto-edit "auto-apply patches, prompt for shell"
```

### JSON output
```bash
codex exec --json "your prompt" | jq
codex exec --json --output-last-message "your prompt"
```

### Quiet mode
```bash
codex exec --quiet "your prompt"
```

### Model selection
```bash
codex exec --model gpt-5-codex "your prompt"
codex exec --model o4-mini "your prompt"
```

### Context files (AGENTS.md convention)
Codex reads `AGENTS.md` files automatically (merged top-down):
- `~/.codex/AGENTS.md` — global instructions
- `./AGENTS.md` — repo-level instructions
- `./<subfolder>/AGENTS.md` — scoped instructions

### Full reviewer invocation example
```bash
codex exec \
  --full-auto \
  --json \
  --model gpt-5-codex \
  "You are a reviewer agent. Read agents/prompts/reviewer.md for your instructions. \
   The task prompt is in agents/TASK.md. Review work in agents/ and output FEEDBACK.md and/or DONEXT.md."
```

---

## Key Differences

| | Claude Code | Codex CLI |
|---|---|---|
| Headless flag | `-p` | `exec` |
| YOLO | `--dangerously-skip-permissions` | `--dangerously-bypass-approvals-and-sandbox` |
| Safe auto | `--allowedTools` | `--full-auto` (workspace-write + on-request) |
| System prompt | `--system-prompt-file` / `--append-system-prompt-file` | `AGENTS.md` convention |
| Output | `--output-format json` | `--json` |
| Session resume | `--resume <id>` | `exec resume --last` |
