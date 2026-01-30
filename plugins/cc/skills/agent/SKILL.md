---
name: agent
description: Help design and create Claude Code subagents
---
# Subagent Creation Reference

**Doc:** https://code.claude.com/docs/en/sub-agents

## What is a Subagent?
A specialized AI assistant with its own context, tools, and prompt.
Runs in isolation, returns results to main conversation.

## File Location
- User: `~/.claude/agents/<name>.md`
- Project: `.claude/agents/<name>.md`

## Format
```yaml
---
name: my-agent
description: When Claude should use this agent
tools: Read, Grep, Glob, Bash
disallowedTools: Edit, Write, Task
model: inherit
skills:
  - skill-to-preload
---
You are a specialist in X.

Your system prompt goes here.
```

## Key Frontmatter Fields
| Field | Purpose |
|-------|---------|
| `name` | Agent identifier |
| `description` | When to delegate (Claude uses this) |
| `tools` | Allowlist of tools |
| `disallowedTools` | Blocklist of tools |
| `model` | `inherit`, `sonnet`, `opus`, `haiku` |
| `skills` | Skills to preload (full content injected) |

## Agent Body = System Prompt
The markdown after frontmatter becomes the agent's system prompt.
Define WHO the agent is, HOW it behaves, output format.

## When to Create an Agent
- Need tool restrictions
- Want isolated context
- Reusable specialist behavior
- Skill needs `context: fork`

## When NOT to Create an Agent
- Task needs main conversation context
- Need back-and-forth with user
- Simple task (overhead not worth it)

## Skill vs Agent
- **Skill with `context: fork`**: You write the TASK, agent provides personality
- **Agent with `skills`**: You write the PERSONALITY, skills provide reference
