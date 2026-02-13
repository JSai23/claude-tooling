#!/usr/bin/env python3
"""Compile agent prompts from plugin agents + knowledge skills into flat files.

Reads agent definitions, resolves their skill references, and produces:
1. Flat system prompts — one .md per agent with knowledge skills inlined
2. AgentSkills.io compatible directories — compiled agents as publishable skills

Only skills with `type: knowledge` are compiled into flat prompts.
Action skills remain load-on-demand.

Usage:
    python3 tools/compile-prompts.py plugins/wf
    python3 tools/compile-prompts.py plugins/vault
    python3 tools/compile-prompts.py plugins/wf --out build/wf
"""

import re
import sys
from pathlib import Path

LINE_LIMIT = 500


def parse_frontmatter(text):
    """Parse YAML frontmatter from markdown. Returns (dict, body_string).

    Handles: simple key: value, multiline > strings, and - item lists.
    No external dependencies.
    """
    m = re.match(r"^---\n(.*?)\n---\n?(.*)", text, re.DOTALL)
    if not m:
        return {}, text

    fm_text = m.group(1)
    body = m.group(2).lstrip("\n")
    fm = {}

    lines = fm_text.split("\n")
    i = 0
    while i < len(lines):
        line = lines[i]
        kv = re.match(r"^([\w][\w-]*):\s*(.*)", line)
        if kv:
            key, val = kv.group(1), kv.group(2).strip()

            if val == ">":
                # Multiline folded string
                parts = []
                i += 1
                while i < len(lines) and (
                    lines[i].startswith("  ") or lines[i].strip() == ""
                ):
                    parts.append(lines[i].strip())
                    i += 1
                fm[key] = " ".join(p for p in parts if p)
                continue

            elif val == "" or val.startswith("["):
                # Possibly a list
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
    """Remove ## Startup section from agent body (skills are inlined)."""
    return re.sub(r"## Startup\n.*?---\n*", "", body, flags=re.DOTALL)


def compile_agent(agent_path, skills_dir):
    """Compile one agent with its knowledge skills into a flat prompt.

    Returns (compiled_text, agent_name, knowledge_skills, action_skills).
    """
    text = agent_path.read_text()
    fm, body = parse_frontmatter(text)

    name = fm.get("name", agent_path.stem)
    desc = fm.get("description", "")
    skills = fm.get("skills", [])
    if isinstance(skills, str):
        skills = [skills]

    body = strip_startup(body)

    # Build compiled prompt
    parts = []
    parts.append(body.strip())

    k_skills = []
    a_skills = []

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
    """Write flat system prompt .md file."""
    path = out_dir / f"{name}.md"
    path.write_text(compiled + "\n")
    return path


def write_agentskill(compiled, name, desc, plugin_name, out_dir):
    """Write AgentSkills.io compatible skill directory."""
    skill_name = f"{plugin_name}-{name}"
    skill_dir = out_dir / "agentskills" / skill_name
    skill_dir.mkdir(parents=True, exist_ok=True)

    content = f"""---
name: {skill_name}
description: >
  {desc}
metadata:
  source-plugin: {plugin_name}
  source-agent: {name}
  compiled: "true"
---

{compiled}
"""
    (skill_dir / "SKILL.md").write_text(content)
    return skill_dir


def main():
    if len(sys.argv) < 2:
        print("Usage: compile-prompts.py <plugin-dir> [--out <output-dir>]")
        print()
        print("Examples:")
        print("  python3 tools/compile-prompts.py plugins/wf")
        print("  python3 tools/compile-prompts.py plugins/vault --out build/vault")
        sys.exit(1)

    plugin_dir = Path(sys.argv[1])
    out_dir = plugin_dir / "compiled"
    if "--out" in sys.argv:
        idx = sys.argv.index("--out")
        if idx + 1 < len(sys.argv):
            out_dir = Path(sys.argv[idx + 1])

    agents_dir = plugin_dir / "agents"
    skills_dir = plugin_dir / "skills"

    if not agents_dir.exists():
        print(f"Error: no agents/ directory in {plugin_dir}")
        sys.exit(1)

    plugin_name = plugin_dir.name
    out_dir.mkdir(parents=True, exist_ok=True)

    print(f"Compiling {plugin_name} agents...")
    print(f"  Agents:  {agents_dir}")
    print(f"  Skills:  {skills_dir}")
    print(f"  Output:  {out_dir}")
    print()

    issues = []
    total_agents = 0

    for agent_file in sorted(agents_dir.glob("*.md")):
        compiled, name, desc, k_skills, a_skills = compile_agent(
            agent_file, skills_dir
        )
        line_count = compiled.count("\n") + 1
        total_agents += 1

        # Write outputs
        flat_path = write_flat(compiled, name, out_dir)
        skill_dir = write_agentskill(compiled, name, desc, plugin_name, out_dir)

        # Check limit
        status = "OK" if line_count <= LINE_LIMIT else "OVER LIMIT"
        if line_count > LINE_LIMIT:
            issues.append((name, line_count))

        # Report
        print(f"  {name}")
        print(f"    Lines:     {line_count:>4}  [{status}]")
        if k_skills:
            print(f"    Compiled:  {', '.join(k_skills)}")
        if a_skills:
            print(f"    Skipped:   {', '.join(a_skills)} (action)")
        print(f"    Flat:      {flat_path}")
        print(f"    Skill:     {skill_dir / 'SKILL.md'}")
        print()

    # Summary
    print(f"--- {plugin_name} summary ---")
    print(f"  Agents compiled: {total_agents}")

    if issues:
        print(f"\n  OVER {LINE_LIMIT}-LINE LIMIT:")
        for name, count in issues:
            print(f"    {name}: {count} lines")
        sys.exit(1)
    else:
        print(f"  All agents within {LINE_LIMIT}-line limit.")


if __name__ == "__main__":
    main()
