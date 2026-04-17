> **DEPRECATED (v3.0)** — Legacy v2.0 command file kept for reference only.  
> Active version: `~/.claude/skills/wosy-models/SKILL.md`  
> See [CHANGELOG.md](../../../CHANGELOG.md) for migration details.

---

# Model Assignment Reference

Use this as the shared model routing guide across all wosy commands.

## Model Routing

| Role / Task | Model | Reason |
|-------------|-------|--------|
| Planning, spec, ADR writing | `claude-opus-4-6` | Needs reasoning depth, avoids shortcuts |
| Architecture decisions | `claude-opus-4-6` | Trade-off analysis, long-horizon thinking |
| Code review, security audit, PR review | `claude-opus-4-6` | Needs to catch subtle issues |
| Implementation, coding, bug fixes | `claude-sonnet-4-6` | Fast, accurate, code-native |
| Research, codebase exploration | `claude-sonnet-4-6` | Fast reading, pattern recognition |
| Report generation (HTML/MD output) | `claude-sonnet-4-6` | Structured output, no deep reasoning needed |
| QA, smoke testing, deployment | `claude-sonnet-4-6` | Procedural execution |
| Conductor window (default) | `claude-sonnet-4-6` | Orchestration, not reasoning-heavy |

## Summary Rule

> **Opus** when thinking hard matters — plans, specs, reviews, decisions.
> **Sonnet** when doing matters — code, research, output generation, orchestration.

## How to Apply

When `/dispatch` sends an agent, the prompt must specify the model:
```
Agent tool → model: "opus" or "sonnet"
```

When working in plan mode (Claude Code), the plan mode automatically uses the best available model for planning. Implementation steps dispatched via `/dispatch` should use Sonnet.

## Quick Reference

```
/plan      → Opus  (architect-level thinking)
/spec      → Opus  (requirements precision)
/pr-review → Opus  (reviewer role)
/research  → Sonnet (fast explorer)
/dispatch  → Sonnet for implementers, Opus for review agents
/phase0    → Opus  (discovery + design)
/work      → Sonnet (routing + coordination)
```
