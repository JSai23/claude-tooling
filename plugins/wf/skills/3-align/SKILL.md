---
name: 3-align
description: Verify understanding alignment - detailed questions about implementation
argument-hint: "[files or area]"
---
## Target
$ARGUMENTS

---

# Initial Alignment Check

Verify your understanding matches the user's intent through detailed questions.

## Purpose

LLMs can drift from user intent during implementation. This catches misalignment early by asking specific questions about what was built.

## Question Density

- **Per 2-3 functions:** 1-2 questions
- **Per file:** 1-2 questions about the file's role
- **Overall:** Questions about how pieces connect

## Question Types

Use diagrams and visuals to test understanding - they reveal misalignment faster than words.

### Function-Level
- "This function does X - is that what you intended?"
- "I made Y return Z in edge case W - correct?"
- "Function A calls B here - is that the right dependency direction?"

### File-Level
- "This file handles X responsibility - does that match your mental model?"
- "I put Y in this module because Z - does that make sense?"

### Connection-Level (use visuals)
Show the flow and ask if it's right:
```
"Is this the correct data flow?

[User Input] → [Validator] → [Processor] → [Store]
                    ↓
               [Error Handler]
"
```

```
"Does this dependency structure match your intent?

┌──────────┐     ┌──────────┐
│  Service │────>│   Repo   │
└────┬─────┘     └──────────┘
     │
     v
┌──────────┐
│  Cache   │
└──────────┘
"
```

### Path-Level (use visuals)
```
"Is this the correct execution path for case X?

1. Entry: handleRequest()
2. Validate: checkAuth() → checkParams()
3. Process: transform() → save()
4. Return: formatResponse()
"
```

## Process

This is a **cycle**, not a one-shot check. Keep going until alignment feels solid.

```
┌─────────────────────────────────────┐
│                                     │
│  ┌─────────┐    ┌─────────────┐    │
│  │  Ask    │───>│  Listen to  │    │
│  │Questions│    │  Answers    │    │
│  └─────────┘    └──────┬──────┘    │
│       ^                │           │
│       │                v           │
│       │         ┌─────────────┐    │
│       │         │  Aligned?   │    │
│       │         └──────┬──────┘    │
│       │                │           │
│       │     No         │  Yes      │
│       └────────────────┘    │      │
│                             v      │
│                        ┌────────┐  │
│                        │  Done  │  │
│                        └────────┘  │
└─────────────────────────────────────┘
```

1. Review changed code
2. Ask questions about functions, files, connections
3. Listen to answers - do they confirm or correct your understanding?
4. If corrected, ask follow-up questions about the correction
5. **Repeat until answers feel aligned** - no more surprises
6. Document corrections in deviation file

## When to Stop

Stop when:
- Answers confirm your understanding without corrections
- Follow-up questions get "yes, exactly" responses
- You can predict what the user will say

Keep going when:
- Answers reveal you misunderstood something
- User adds context you didn't have
- You're unsure about any part

## Output Format

Ask questions using AskUserQuestion tool. Group related questions.

After alignment:
```
## Alignment Summary
- Cycles: {N rounds of questions}
- Corrections needed: {list or "none"}
- Understanding confirmed for: {list of files/areas}
```

## Success Criteria
Full alignment with no surprises is the goal. Keep cycling until you get there.
