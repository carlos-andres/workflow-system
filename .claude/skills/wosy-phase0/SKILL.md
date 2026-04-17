---
name: wosy-phase0
description: Greenfield discovery — adaptive interview from raw idea to intake-ready docs
---

# /phase0 - Idea to Intake-Ready Documentation

Input: raw idea. Output: 4 living docs in `.devwork/_scratch/phase0/` + `README.md` at project root.

## Startup
- `resume` → read existing docs, show status, continue where left off
- Existing dir without resume → ask: resume or start fresh (backup to `phase0-{timestamp}/`)
- New → create dir, draft `01-idea.md`, begin interview

## 4 Living Documents
`.devwork/_scratch/phase0/`: `01-idea.md` (vision, problem, users, out-of-scope) | `02-discovery.md` (Q/A/Insight per round, findings, open Qs) | `03-decisions.md` (ADR log DEC-NNN + rules) | `04-specs.md` (app type, features, UI, tech stack, data model)

## Interview Flow
**Adaptive cascade, not fixed script.**
Opening: What is it? What problem? Who for? What exists today?

Adaptive pivots: UI/screens → components, states, interactions, responsive | Data/storage → entities, relationships, volume | API/integrations → endpoints, auth, rate limits | Constraints/rules → rationale, scope, alternatives | Tech stack → compatibility, tradeoffs | Users/roles → permissions, per-role flows, edge cases

Principles: one question at a time, acknowledge before next, capture decisions instantly as ADRs, natural topic grouping.

## Document Updates
After each substantive exchange, update relevant doc(s). Decisions → `03-decisions.md`, UI → `04-specs.md` immediately. Notify briefly: `Updated 04-specs.md -- added toolbar component specs`. Language: conversation in user's language, documents always English.

## Handling Artifacts
ASCII/diagrams → incorporate into `04-specs.md`, generate element breakdown, ask clarifying Qs. Screenshots → analyze elements, ask about intent vs current state. Tables → incorporate into relevant doc, ask about missing columns/edge cases.

## Completion
**Explicit triggers only**: "phase0 done", "ready for intake", "done", "estoy listo", "terminamos". Ambiguous phrases do NOT trigger completion.

On completion: 1) Status report per-doc + open items warning. 2) Generate `README.md` at project root consolidating all 4 docs. 3) Next step: `Run /work setup to generate AI coding guidelines.`

## Status & Resumability
User asks "status"/"where are we?" → show per-doc summary (sections filled, open questions). Does NOT trigger completion. Docs saved progressively. `/phase0 resume` reads all, shows status, picks up where left off.
