#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.10"
# ///
"""Compile Claude plugin agents + skills into portable prompt formats.

Reads agent definitions, resolves knowledge skill references, and produces:
1. Flat system prompts — one .md per agent (agent body + inlined knowledge skills)
2. AgentSkills.io directories — agents and standalone skills as publishable skills

Usage:
    uv run tools/compile-prompts.py              # compile all plugins
    uv run tools/compile-prompts.py wf           # compile one plugin
    uv run tools/compile-prompts.py wf planner   # compile one agent
"""

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PLUGINS_DIR = ROOT / "plugins"
COMPILED_DIR = ROOT / "compiled"
LINE_LIMIT = 500


def parse_frontmatter(text):
    """Parse YAML frontmatter. Returns (dict, body_string)."""
    m = re.match(r"^---\n(.*?)\n---\n?(.*)", text, re.DOTALL)
    if not m:
        return {}, text
    fm_text, body = m.group(1), m.group(2).lstrip("\n")
    fm = {}
    lines = fm_text.split("\n")
    i = 0
    while i < len(lines):
        line = lines[i]
        kv = re.match(r"^([\w][\w-]*):\s*(.*)", line)
        if kv:
            key, val = kv.group(1), kv.group(2).strip()
            if val == ">":
                parts = []
                i += 1
                while i < len(lines) and (lines[i].startswith("  ") or lines[i].strip() == ""):
                    parts.append(lines[i].strip())
                    i += 1
                fm[key] = " ".join(p for p in parts if p)
                continue
            elif val == "" or val.startswith("["):
                items = []
                i += 1
                while i < len(lines) and re.match(r"^\s+-\s+", lines[i]):
                    item = re.match(r"^\s+-\s+(.*)", lines[i]).group(1).strip()
                    items.append(item)
                    i += 1
                if items:
                    fm[key] = items
                elif val:
                    fm[key] = val
                continue
            else:
                fm[key] = val
        i += 1
    return fm, body


def strip_startup(body):
    """Remove ## Startup section (skills are inlined instead)."""
    return re.sub(r"## Startup\n.*?---\n*", "", body, flags=re.DOTALL)


def line_count(text):
    return text.strip().count("\n") + 1


def compile_agent(agent_path, skills_dir):
    """Compile agent + knowledge skills into flat prompt.

    Returns (compiled_text, name, description, knowledge_skills, action_skills).
    """
    text = agent_path.read_text()
    fm, body = parse_frontmatter(text)
    name = fm.get("name", agent_path.stem)
    desc = fm.get("description", "")
    skills = fm.get("skills", [])
    if isinstance(skills, str):
        skills = [skills]

    body = strip_startup(body)
    parts = [body.strip()]
    k_skills, a_skills = [], []

    for skill_name in skills:
        skill_path = skills_dir / skill_name / "SKILL.md"
        if not skill_path.exists():
            parts.append(f"\n\n---\n\n<!-- MISSING: {skill_name} -->")
            continue
        sfm, sbody = parse_frontmatter(skill_path.read_text())
        skill_type = sfm.get("type", "knowledge")
        if skill_type in ("knowledge", "both"):
            k_skills.append(skill_name)
            parts.append(f"\n\n---\n\n## {sfm.get('name', skill_name)}\n\n{sbody.strip()}")
        else:
            a_skills.append(skill_name)

    compiled = "\n".join(parts)
    return compiled, name, desc, k_skills, a_skills


def write_flat(compiled, name, out_dir):
    """Write flat .md system prompt for agent sessions."""
    agents_dir = out_dir / "agents"
    agents_dir.mkdir(parents=True, exist_ok=True)
    path = agents_dir / f"{name}.md"
    path.write_text(compiled + "\n")
    return path


def write_agentskill(compiled, name, desc, plugin_name, out_dir, *, source_type="agent"):
    """Write AgentSkills.io directory."""
    skill_name = f"{plugin_name}-{name}"
    skill_dir = out_dir / "agentskills" / skill_name
    skill_dir.mkdir(parents=True, exist_ok=True)
    source_key = "source-agent" if source_type == "agent" else "source-skill"
    content = f"""---
name: {skill_name}
description: >
  {desc}
metadata:
  source-plugin: {plugin_name}
  {source_key}: {name}
---

{compiled.strip()}
"""
    (skill_dir / "SKILL.md").write_text(content)
    return skill_dir


def compile_plugin(plugin_dir, out_dir, target_agent=None):
    """Compile all agents and standalone skills for a plugin."""
    agents_dir = plugin_dir / "agents"
    skills_dir = plugin_dir / "skills"
    plugin_name = plugin_dir.name

    if not agents_dir.exists():
        print(f"  {plugin_name}: no agents/ directory, skipping")
        return True

    print(f"\n  {plugin_name}")
    print(f"  {'-' * 40}")

    issues = []
    agent_files = sorted(agents_dir.glob("*.md"))

    if target_agent:
        agent_files = [f for f in agent_files if f.stem == target_agent]
        if not agent_files:
            print(f"    Error: agent '{target_agent}' not found")
            return False

    # Compile agents
    referenced_skills = set()
    for agent_file in agent_files:
        compiled, name, desc, k_skills, a_skills = compile_agent(agent_file, skills_dir)
        referenced_skills.update(k_skills + a_skills)
        count = line_count(compiled)

        write_flat(compiled, name, out_dir)
        write_agentskill(compiled, name, desc, plugin_name, out_dir)

        status = "OK" if count <= LINE_LIMIT else "OVER LIMIT"
        if count > LINE_LIMIT:
            issues.append((name, count))

        print(f"    {name:<20} {count:>4} lines  [{status}]")
        if k_skills:
            print(f"      inlined: {', '.join(k_skills)}")
        if a_skills:
            print(f"      on-demand: {', '.join(a_skills)}")

    # Compile standalone skills (not referenced by any agent)
    if not target_agent and skills_dir.exists():
        standalone = []
        for skill_file in sorted(skills_dir.glob("*/SKILL.md")):
            sfm, sbody = parse_frontmatter(skill_file.read_text())
            sname = sfm.get("name", skill_file.parent.name)
            if sname not in referenced_skills:
                desc = sfm.get("description", "")
                write_agentskill(sbody.strip(), sname, desc, plugin_name, out_dir, source_type="skill")
                count = line_count(sbody)
                standalone.append((sname, count))
                print(f"    {sname:<20} {count:>4} lines  [standalone]")

    if issues:
        print(f"\n    OVER {LINE_LIMIT}-LINE LIMIT:")
        for name, count in issues:
            print(f"      {name}: {count} lines")
        return False
    return True


def main():
    target_plugin = sys.argv[1] if len(sys.argv) > 1 else None
    target_agent = sys.argv[2] if len(sys.argv) > 2 else None

    if target_plugin and not (PLUGINS_DIR / target_plugin).exists():
        print(f"Error: plugin '{target_plugin}' not found in {PLUGINS_DIR}")
        sys.exit(1)

    if target_plugin:
        plugins = [PLUGINS_DIR / target_plugin]
    else:
        plugins = sorted(p for p in PLUGINS_DIR.iterdir() if p.is_dir())

    print(f"Compiling to {COMPILED_DIR}/")

    all_ok = True
    for plugin_dir in plugins:
        out_dir = COMPILED_DIR / plugin_dir.name
        if not compile_plugin(plugin_dir, out_dir, target_agent):
            all_ok = False

    print(f"\n  {'All OK' if all_ok else 'Issues found'} (limit: {LINE_LIMIT} lines)")

    if not all_ok:
        sys.exit(1)


if __name__ == "__main__":
    main()
