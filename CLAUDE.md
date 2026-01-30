# Claude Tooling

Plugin marketplace for Claude Code: workflow, automation, and utility plugins.

## Repository Structure

```
claude-tooling/
├── .claude-plugin/marketplace.json   # Marketplace catalog
├── plugins/
│   ├── wf/                           # Workflow plugin
│   ├── auto/                         # Automation plugin
│   └── util/                         # Utilities plugin
├── user-config/                      # Manual user config
└── install.sh                        # Full installation
```

## Plugins

| Plugin | Skills | Description |
|--------|--------|-------------|
| `wf` | /wf:1-plan, /wf:2-implement, /wf:3-align, etc. | Agentic workflow |
| `cc` | /cc:skill, /cc:agent, /cc:hook, /cc:rule | Automation builder |
| `util` | /util:ask, /util:doc, /util:create-handoff, etc. | Utilities |

## Guidelines for This Repo

### Plugin Structure
Each plugin at `plugins/{name}/` contains:
- `.claude-plugin/plugin.json` - Plugin metadata
- `skills/{skillname}/SKILL.md` - Skills
- `agents/{name}.md` - Agents
- `hooks/` - Hook scripts and hooks.json (if applicable)

### Modifying Plugins
- Add skill to `wf` → modify `plugins/wf/skills/`
- Add agent to `cc` → modify `plugins/cc/agents/`
- New hook for workflow → modify `plugins/wf/hooks/`

### Agent Design
- Give every agent a personality (how it thinks, not just what it does)
- Define a clear output format
- Specify what it does NOT do

### Skill Design
- Skills are thin wrappers that delegate to agents
- Use `context: fork` for read-only operations
- Use `agent: name` to specify which agent handles it

### Docs
Reference: https://docs.anthropic.com/en/docs/claude-code
