---
name: wosy-models
description: Model routing reference — Opus for thinking, Sonnet for doing
---

# Model Assignment

Opus (`claude-opus-4-6`): planning, spec, ADR writing, architecture decisions, code review, security audit
Sonnet (`claude-sonnet-4-6`): implementation, coding, fixes, research, codebase exploration, report generation, QA, testing, deployment, conductor window

Rule: Opus when thinking hard matters. Sonnet when doing matters.

Commands: `/phase0`, `/spec`, `/plan`, `/pr-review`, `/dispatch review agents` → Opus | `/research`, `/dispatch agents`, `/work` → Sonnet

`/dispatch` sets model per agent role. Plan mode uses best available for planning; implementation agents use Sonnet.
