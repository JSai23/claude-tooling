---
name: auto-add-skill
description: Help design and create Claude Code skills
---
# Skill Creation Reference

**Doc:** https://code.claude.com/docs/en/skills

## What is a Skill?
A SKILL.md file with instructions that Claude adds to its toolkit.
- Claude uses skills when relevant, or user invokes with `/skill-name`
- Frontmatter (YAML) controls behavior, markdown body has instructions

## Key Frontmatter Fields
| Field | Purpose |
|-------|---------|
| `name` | Slash command name |
| `description` | When Claude should use it (for auto-invocation) |
| `disable-model-invocation` | `true` = user-only |
| `context: fork` | Run in subagent |
| `agent` | Which subagent (requires `context: fork`) |
| `allowed-tools` / `disallowedTools` | Tool restrictions |

## Dynamic Injection
- `$ARGUMENTS` - User input after skill name
- `!` + backtick + `command` + backtick - Shell command runs before Claude sees skill (preprocessing)

## File Location
- User: `~/.claude/skills/<name>/SKILL.md`
- Project: `.claude/skills/<name>/SKILL.md`

## When to Create a Skill
- Reusable workflow or task
- Need to inject dynamic context
- Want user-invocable command
- Need tool restrictions (with `context: fork`)

## When NOT to Create a Skill
- One-time task (just do it)
- Simple question (just ask)
- Already exists (check first)
