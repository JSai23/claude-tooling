---
name: auto-add-hook
description: Help design and create Claude Code hooks
---
# Hook Creation Reference

**Doc:** https://code.claude.com/docs/en/hooks

## What is a Hook?
Shell commands that run in response to events (tool calls, session start, etc.)

## Hook Events
| Event | When | Use For |
|-------|------|---------|
| `PreToolUse` | Before tool runs | Validation, blocking, redirection |
| `PostToolUse` | After tool runs | Logging, notifications |
| `SessionStart` | Session begins | Setup, context loading |
| `Stop` | Session ending | Cleanup, handoff prompts |
| `UserPromptSubmit` | User sends message | Context injection |

## Configuration (settings.json)
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash|Edit",
        "hooks": [
          { "type": "command", "command": "./my-hook.sh" }
        ]
      }
    ]
  }
}
```

## Hook Input/Output
- Input: JSON via stdin with event details
- Output: Exit code determines behavior
  - `0` = continue
  - `2` = block with message (stderr shown to Claude)

## When to Create a Hook
- Need to validate/block operations
- Want notifications on events
- Inject context per-message
- Cleanup on session end

## When NOT to Create a Hook
- Can be done in a skill
- One-time validation
- Adds latency without value
