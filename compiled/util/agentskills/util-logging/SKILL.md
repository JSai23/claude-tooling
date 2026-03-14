---
name: util-logging
description: >
  Add, fix, or update logging in project code
metadata:
  source-plugin: util
  source-skill: logging
---

## Logging Scope
$ARGUMENTS

---

Add, fix, or update logging following strict principles.

## Core Principle: Signal over Noise

Logs that don't get read are useless. Every log statement must earn its place.

**Before adding a log, ask:**
- Will someone look at this?
- Does this help diagnose something?
- Is this the right level?
- Is there already a log covering this?

Cut ruthlessly. Then cut more.

## Log Levels

### 1. INFO: The Service Narrative
**What the service is doing at a glance.**

Log these:
- Service startup/shutdown
- External connections established/closed (WebSocket, DB)
- Subscriptions to new resources
- Periodic heartbeats (every N seconds: "processing X markets")
- HTTP requests going out (target, method)
- Key state transitions

Never log:
- Every function entry/exit
- Internal data transformations
- Things that happen thousands of times per second

### 2. DEBUG: Granular Internals
**Details for troubleshooting. Off in production unless investigating.**

Log these:
- Request/response payloads (redact secrets)
- Internal state changes
- Timing breakdowns
- Configuration values at startup
- Loop iterations when relevant

### 3. WARN: Rare by Design
**Recoverable errors you're explicitly allowing to continue.**

Log these:
- Fallback to default config
- Retryable failures that succeeded on retry
- Resource thresholds approached (memory at 80%)
- Deprecated API usage detected

Never log:
- Expected conditions (user not found, validation failed)
- Anything you'd ignore in production

### 4. ERROR: Every Failure
**Log at the handling point. Once.**

- Use language/framework hooks to catch all errors automatically
- Include context: what was being attempted, relevant IDs
- Don't log and rethrow—pick one
- Stack traces for unexpected errors

## Process

1. Identify scope (file, module, or all)
2. Audit existing logging against these levels
3. Add missing INFO logs for external-facing events
4. Remove noisy/redundant logs
5. Ensure ERRORs are logged at handling points
6. Use framework-provided logging (HTTP interceptors, etc.) where available
7. **Remind: run `/logging` after significant code changes**

## No Scope Specified?

Review ALL logging against current code. Fix level mismatches. Remove noise. Add missing service narrative. Report what was changed.
