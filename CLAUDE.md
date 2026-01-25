# Claude Tooling

Personal Claude Code extensions: skills, agents, hooks, and rules.

## Installation

```bash
./install.sh
```

## Skills

### Workflow (Shaw-style, 1-0)
- `/1-plan` - Research and planning (forks to planner agent)
- `/2-implement [area]` - Execute the plan
- `/3-continue [from step]` - Keep going
- `/4-quality [files]` - Refactoring pass
- `/5-test [focus]` - Write tests
- `/6-larp` - Find fake code (forks to auditor)
- `/7-deslop [files]` - Remove AI cruft
- `/8-production` - Production readiness check (forks to validator)
- `/9-review` - Final review (forks to auditor)
- `/0-fix [issue]` - Fix all remaining issues

### Automation
- `/auto-add-skill` - Create new skills
- `/auto-add-hook` - Create new hooks
- `/auto-add-rule` - Create new rules
- `/auto-add-agent` - Create new agents

### Utilities
- `/create-handoff` - Create session handoff
- `/resume-handoff` - Resume from handoff
- `/tldr-code` - TLDR CLI reference
- `/doc [type]` - Generate documentation (api, readme, changelog, design)

## Agents

- `planner` - Read-only research for /1-plan
- `auditor` - Code audit for /6-larp, /9-review
- `validator` - Production checklist for /8-production
- `automation-designer` - Claude Code automation specialist

## Structure

```
~/claude-tooling/
├── skills/     # 18 skills
├── agents/     # 4 agents
├── hooks/      # statusline.py
├── rules/      # tldr-cli.md
└── docs/       # lsp-setup.md, testing-guide.md
```
