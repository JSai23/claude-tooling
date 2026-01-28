# Claude Tooling

Personal Claude Code extensions: skills, agents, hooks, and rules.

## Installation

```bash
./install.sh
```

## Skills

### Workflow (Shaw-style, 1-0)
- `/1-plan {planname} [--sub name]` - Research and planning (uses native plan mode)
- `/2-implement {planname}[/NN] [focus]` - Execute the plan
- `/3-continue {planname}[/NN] [from step]` - Keep going
- `/4-quality [files]` - Refactoring pass
- `/5-test [focus]` - Write tests
- `/6-larp` - Find fake code (forks to auditor)
- `/7-deslop [files]` - Remove AI cruft
- `/8-production` - Production readiness check (forks to validator)
- `/9-review` - Final review (forks to auditor)
- `/0-fix [issue]` - Fix all remaining issues

### Language-Specific
- `/rust-quality [path]` - Rust quality audit (Apollo best practices)

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

- `auditor` - Code audit for /6-larp, /9-review
- `validator` - Production checklist for /8-production
- `automation-designer` - Claude Code automation specialist

## Structure

```
~/claude-tooling/
├── skills/     # 19 skills
├── agents/     # 3 agents
├── hooks/      # statusline.py
├── rules/      # tldr-cli.md
└── docs/       # lsp-setup.md, testing-guide.md
```

## Plan Management System

### Directory Structure
Plans stored in `plans/{planname}/`:
- `scope.md` - Master plan (always exists)
- `NN_name.md` - Sub-plans (01_, 02_, etc.)
- `deviation_{scope|NN}.md` - Deviation tracking

### Workflow
1. `/1-plan {planname}` - Create master plan (scope.md)
2. `/1-plan {planname} --sub {name}` - Add sub-plan
3. `/2-implement {planname}[/NN]` - Execute plan/sub-plan
4. `/3-continue {planname}[/NN]` - Resume work

### Plan Mode Behavior
During plan mode: Write to plan document (only writable file)
On exit: Dump content to `plans/{planname}/` structure

### Progress Tracking
- Mark completed items as `[x]` in plan files
- No separate tracking file - user specifies plan in arguments

### Sub-Plan Principles
- Each sub-plan is a verifiable, testable unit
- Simple projects skip sub-plans (use scope.md directly)
- Complex projects break into sub-plans
