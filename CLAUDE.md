# Claude Tooling

## Compilation

After modifying any plugin agent or skill, always recompile:

```bash
uv run tools/compile-prompts.py
```

Compiled output lives in `compiled/` and is committed to the repo. Never gitignore it.

## Plugin Structure

- `plugins/{name}/agents/` — agent system prompts with frontmatter skill references
- `plugins/{name}/skills/{skill-name}/SKILL.md` — skills, postfixed `-k` (knowledge) or `-a` (action)
- `compiled/{name}/agents/` — flat system prompts (agent body + inlined knowledge skills)
- `compiled/{name}/agentskills/` — AgentSkills.io format directories
