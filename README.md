# Claude Tooling

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square" alt="MIT License"></a>
  <a href="https://github.com/jsai/claude-tooling/releases"><img src="https://img.shields.io/badge/version-1.0.0-green.svg?style=flat-square" alt="Version"></a>
  <a href="https://docs.anthropic.com/en/docs/claude-code"><img src="https://img.shields.io/badge/Claude%20Code-Plugins-8A2BE2?style=flat-square" alt="Claude Code Plugins"></a>
</p>

<p align="center">
  <strong>Stop vibe-coding. Ship with structure.</strong>
</p>

<p align="center">
  <em>Plugins that make Claude Code follow a real development process.</em>
</p>

<p align="center">
  <sub>No frameworks. No dependencies. No bloat. Just markdown files that work.</sub>
</p>

---

## The Problem

```
You: "Build me an auth system"

Claude: *writes 500 lines*
Claude: "Done! Here's your auth system."

You: *tests it*
You: "This doesn't actually validate tokens."

Claude: "Oh right, let me fix that..."
Claude: *writes 200 more lines that break something else*
```

LLMs skip steps. They write code that looks right but doesn't work. They forget what they were doing between sessions.

Every AI coding tool adds more features, more complexity, more noise. This goes the other way: **simple markdown files that enforce discipline**.

---

## The Key Insight: Questions

Most AI tools just generate. This one **asks**.

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│   TYPICAL AI                         THIS WORKFLOW                      │
│                                                                         │
│   You: "Build auth"                  You: "Build auth"                  │
│        │                                  │                             │
│        ▼                                  ▼                             │
│   AI: *generates 500 lines*          AI: "JWT or session-based?        │
│        │                                   What's the token lifetime?   │
│        ▼                                   Refresh token strategy?"     │
│   You: "This is wrong"                    │                             │
│        │                                  ▼                             │
│        ▼                             You: *answers*                     │
│   AI: *generates 300 more*                │                             │
│        │                                  ▼                             │
│        ▼                             AI: *builds exactly that*          │
│   You: "Still wrong"                      │                             │
│        │                                  ▼                             │
│        ▼                             AI: "I built X, Y, Z.              │
│   *repeat until frustrated*               Is that what you meant?"      │
│                                           │                             │
│                                           ▼                             │
│                                      You: "Yes" or "No, actually..."   │
│                                           │                             │
│                                           ▼                             │
│                                      *catches drift before it compounds*│
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

Questions appear at every phase:
- **Planning**: "Which approach? What are the tradeoffs you care about?"
- **Alignment**: "This function does X—is that right?"
- **Testing**: "What SHOULD happen in this edge case?"
- **Review**: "Does this architecture match your vision?"

LLMs are confident. Confident and wrong. Questions force verification before the wrong code compounds into a mess.

---

## The Solution

```
┌────────────────────────────────────────────────────────────────────┐
│                                                                    │
│    ┌─────────┐    ┌─────────┐    ┌─────────┐    ┌─────────┐      │
│    │  PLAN   │───▶│  BUILD  │───▶│  VERIFY │───▶│  AUDIT  │      │
│    └─────────┘    └─────────┘    └─────────┘    └─────────┘      │
│         │                                             │           │
│         │              ┌─────────┐                    │           │
│         └─────────────▶│   FIX   │◀───────────────────┘           │
│                        └─────────┘                                │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

**Plan** before you code. **Track** deviations. **Audit** for fake code. **Fix** systematically.

---

## Install

```bash
git clone https://github.com/jsai/claude-tooling.git
cd claude-tooling && ./install.sh
```

---

## Three Plugins

<table>
<tr>
<td width="33%" valign="top">

### 🔄 wf
**Workflow**

Forces a real dev process:

```
/wf:1-plan
    ↓
/wf:2-implement
    ↓
/wf:3-align
    ↓
/wf:4-quality
    ↓
/wf:5-test
    ↓
/wf:6-larp
    ↓
/wf:0-fix
```

Plans get saved. Progress gets tracked. Deviations get flagged.

</td>
<td width="33%" valign="top">

### 🔧 cc
**Build Extensions**

Create your own Claude Code tools:

```
/cc:skill
"I want a /deploy command"
     ↓
Walks you through design
     ↓
Creates the files
     ↓
Installed and working
```

Also: `/cc:agent`, `/cc:hook`, `/cc:rule`

</td>
<td width="33%" valign="top">

### 📦 util
**Utilities**

Never lose context:

```
End of day:
/util:create-handoff
     ↓
Next morning:
/util:resume-handoff
     ↓
"Yesterday you were stuck on X.
 You tried A (failed) and B (worked).
 Ready to continue?"
```

Also: `/util:ask`, `/util:doc`

</td>
</tr>
</table>

---

## Full Workflow

```
                                    START
                                      │
                                      ▼
                    ┌─────────────────────────────────────┐
                    │            /wf:1-plan               │
                    │   ┌───────────────────────────┐     │
                    │   │ • Research the problem    │     │
                    │   │ • Present 2-3 approaches  │     │
                    │   │ • Discuss tradeoffs       │     │
                    │   │ • User picks direction    │     │
                    │   └───────────────────────────┘     │
                    └─────────────────────────────────────┘
                                      │
                         ┌────────────┴────────────┐
                         ▼                         ▼
              ┌──────────────────┐      ┌──────────────────┐
              │ /wf:1.1-plan-dump│      │    plans/*.md    │
              │   Save to disk   │─────▶│  Track progress  │
              └──────────────────┘      └──────────────────┘
                                                │
                                                ▼
                    ┌─────────────────────────────────────┐
                    │          /wf:2-implement            │
                    │   ┌───────────────────────────┐     │
                    │   │ • Follow plan step by step│     │
                    │   │ • Mark [x] as you go      │     │
                    │   │ • STOP on any deviation   │◀────┼──── Deviation?
                    │   │ • Document why in file    │     │     Discuss first.
                    │   └───────────────────────────┘     │
                    └─────────────────────────────────────┘
                                      │
                                      ▼
                    ┌─────────────────────────────────────┐
                    │           /wf:3-align               │
                    │   ┌───────────────────────────┐     │
                    │   │ "This function does X,    │     │
                    │   │  is that what you meant?" │     │
                    │   │                           │     │
                    │   │ "Data flows A → B → C,    │     │
                    │   │  correct?"                │     │
                    │   │                           │     │
                    │   │  Catches drift early.     │     │
                    │   └───────────────────────────┘     │
                    └─────────────────────────────────────┘
                                      │
          ┌───────────────────────────┼───────────────────────────┐
          ▼                           ▼                           ▼
┌──────────────────┐      ┌──────────────────┐      ┌──────────────────┐
│  /wf:4-quality   │      │   /wf:5-test     │      │   /wf:6-larp     │
│                  │      │                  │      │                  │
│ Architecture:    │      │ Behavior:        │      │ Fake code:       │
│ • Class design   │      │ • Happy path     │      │ • Stub functions │
│ • Dependencies   │      │ • Error cases    │      │ • Always-true    │
│ • Module bounds  │      │ • Edge cases     │      │   validation     │
│ • Is it earned?  │      │ • Integration    │      │ • Empty catches  │
│                  │      │                  │      │ • Mock theater   │
│ Finds: design    │      │ Finds: behavior  │      │ Finds: lies      │
│ issues           │      │ gaps             │      │                  │
└────────┬─────────┘      └────────┬─────────┘      └────────┬─────────┘
         │                         │                         │
         └─────────────────────────┼─────────────────────────┘
                                   ▼
                    ┌─────────────────────────────────────┐
                    │  /wf:7.1-deslop  +  /wf:7.2-quality │
                    │   ┌───────────────────────────┐     │
                    │   │ Remove:                   │     │
                    │   │ • Try/catch that can't    │     │
                    │   │   fail                    │     │
                    │   │ • Null checks on non-null │     │
                    │   │ • One-use abstractions    │     │
                    │   │ • Obvious comments        │     │
                    │   │                           │     │
                    │   │ Polish:                   │     │
                    │   │ • Naming                  │     │
                    │   │ • Formatting              │     │
                    │   │ • Simplify conditionals   │     │
                    │   └───────────────────────────┘     │
                    └─────────────────────────────────────┘
                                      │
                                      ▼
                    ┌─────────────────────────────────────┐
                    │           /wf:8-review              │
                    │   ┌───────────────────────────┐     │
                    │   │ Final check:              │     │
                    │   │ □ Tests pass              │     │
                    │   │ □ No hardcoded secrets    │     │
                    │   │ □ Errors handled          │     │
                    │   │ □ No TODOs remain         │     │
                    │   │                           │     │
                    │   │ "Ready to ship?"          │     │
                    │   └───────────────────────────┘     │
                    └─────────────────────────────────────┘
                                      │
                          ┌───────────┴───────────┐
                          ▼                       ▼
                    ┌───────────┐           ┌───────────┐
                    │   PASS    │           │   FAIL    │
                    │   Ship it │           │     │     │
                    └───────────┘           └─────┼─────┘
                                                  │
                                                  ▼
                              ┌─────────────────────────────────────┐
                              │            /wf:0-fix                │
                              │   ┌───────────────────────────┐     │
                              │   │ • Gather all issues       │     │
                              │   │ • Prioritize: critical →  │     │
                              │   │   warning → suggestion    │     │
                              │   │ • Fix one at a time       │     │
                              │   │ • Verify before moving on │     │
                              │   │ • Loop until clean        │     │
                              │   └───────────────────────────┘     │
                              └─────────────────────────────────────┘
                                                  │
                                                  ▼
                                              BACK TO
                                             /wf:8-review
```

---

## Session Handoffs

```
┌─────────────────────────────────────────────────────────────────┐
│                         SESSION 1                               │
│                                                                 │
│   Working on auth system...                                     │
│   Got stuck on token refresh...                                 │
│   Tried approach A (failed because X)                           │
│   Tried approach B (worked for Y but not Z)                     │
│                                                                 │
│   /util:create-handoff                                          │
│        │                                                        │
│        ▼                                                        │
│   .handoffs/2024-01-30_auth-system.yaml                        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                         SESSION 2                               │
│                                                                 │
│   /util:resume-handoff                                          │
│        │                                                        │
│        ▼                                                        │
│   "Last session you were working on auth.                       │
│    You got stuck on token refresh.                              │
│    Approach A failed because X.                                 │
│    Approach B worked for Y.                                     │
│    Recommended: Try B with modification for Z.                  │
│    Continue?"                                                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

No more "what was I doing?" at the start of every session.

---

## Requirements

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) CLI
- Plugin support enabled

---

## License

MIT
