# Model Assignment Reference

Use this as the shared model routing guide across all wosy commands.

## Instructions

Use this reference when dispatching agents via `/dispatch`. Always specify `model:` explicitly — never leave it implicit. Use the generic aliases `"opus"` and `"sonnet"` — Claude Code resolves these to the latest available version automatically.

## Model Routing

| Role / Task | Model | Reason |
|-------------|-------|--------|
| Planning, spec, ADR writing | `opus` (latest) | Needs reasoning depth, avoids shortcuts |
| Architecture decisions | `opus` (latest) | Trade-off analysis, long-horizon thinking |
| Code review, security audit, PR review | `opus` (latest) | Needs to catch subtle issues |
| Implementation, coding, bug fixes | `sonnet` (latest) | Fast, accurate, code-native |
| Research, codebase exploration | `sonnet` (latest) | Fast reading, pattern recognition |
| Report generation (HTML/MD output) | `sonnet` (latest) | Structured output, no deep reasoning needed |
| QA, smoke testing, deployment | `sonnet` (latest) | Procedural execution |
| Conductor window (default) | `sonnet` (latest) | Orchestration, not reasoning-heavy |

> **Note:** `"opus"` and `"sonnet"` are generic aliases. Claude Code resolves them to the latest available model version at dispatch time — no hardcoded version strings needed.

## Summary Rule

> **Opus** when thinking hard matters — plans, specs, reviews, decisions.
> **Sonnet** when doing matters — code, research, output generation, orchestration.

## How to Apply

When `/dispatch` sends an agent, the prompt must specify the model:
```
Agent tool → model: "opus" or model: "sonnet"
```

When working in plan mode (Claude Code), the plan mode automatically uses the best available model for planning. Implementation steps dispatched via `/dispatch` should use Sonnet.

## Quick Reference

```
/plan      → opus  (architect-level thinking)
/spec      → opus  (requirements precision)
/pr-review → opus  (reviewer role)
/research  → sonnet (fast explorer)
/dispatch  → sonnet for implementers, opus for review agents
/phase0    → opus  (discovery + design)
/work      → sonnet (routing + coordination)
```
