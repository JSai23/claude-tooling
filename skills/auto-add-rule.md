---
name: auto-add-rule
description: Help design and create Claude Code rules
---
# Rule Creation Reference

**Doc:** https://code.claude.com/docs/en/memory

## What is a Rule?
A markdown file that's always loaded into Claude's context.
Unlike skills (invoked), rules are always present.

## File Location
- User: `~/.claude/rules/<name>.md`
- Project: `.claude/rules/<name>.md`

## Content Format
Just markdown. No frontmatter needed.
```markdown
# My Rule

Always do X when Y happens.
Never do Z.
```

## When to Create a Rule
- Behavioral guidance that always applies
- Coding standards for the project
- Safety constraints
- Reference information always needed

## When NOT to Create a Rule
- One-time instruction (just say it)
- Large reference (use skill that loads on demand)
- Task-specific (use skill)

## Rule vs Skill
| Aspect | Rule | Skill |
|--------|------|-------|
| Loaded | Always | On invocation |
| Context cost | Constant | On demand |
| Invocable | No | Yes |
| Best for | Guidelines | Tasks |
