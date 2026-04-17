---
name: wosy-plan
description: Implementation blueprint with T-shirt sizing, phased tasks, dependency graph.
---

# /plan

Read status.md, research.md, spec.md (if exists), constitution.md. Requires `/intake` + `/research` done.

## Verification Checkpoint (hard gate)
Confirm before planning: 1) Every file in research.md `Will Modify` still exists and unchanged 2) Pattern from `Verified References` still fits 3) No new unknowns since research. Any failure → re-run `/research` on affected area.

## Design Approach
Consider: patterns from research.md, file structure from constitution.md, dependency order, testing strategy, risks.

## Write plan.md

`.devwork/{type}/{task-id}/plan.md`: Approach Summary (2-3 sentences), Components (name|purpose|path), Data Flow (input→process→output), Files (new + modified), Phases (task|pass criteria|verified by + gate condition), Technical Decisions (options/chosen/reason, ADR if significant), Testing Strategy (unit + integration + manual), Risks (risk|impact H/M/L|mitigation), Dependencies (must-first + can-parallel), Estimated Effort per phase + total. Light plan for bugfix: skip detailed architecture, single phase, focus what/how/risks.

## T-Shirt Sizing

From research.md signals — **highest factor wins** (e.g. S effort + L risk = L):
- **Effort** (Will Modify count): 1 file (XS) → 1-3 (S) → 4-10 (M) → 10-25 (L) → 25+ (XL)
- **Complexity** (Dependencies): Zero deps (XS) → Single domain (S) → Cross-file parallelizable (M) → Cross-domain tight coupling (L) → Architecture-level (XL)
- **Risk** (Risks + Questions): None (XS) → Low, ref found (S) → Some new patterns (M) → Unknowns, 3rd-party (L) → No reference, open questions (XL)

Execution by size:
- **XS** → Skip dispatch, just do it, no tasks.md needed
- **S** → Manual — work through tasks.md checkboxes
- **M** → `/dispatch` — orchestrate sub-agents
- **L** → `/dispatch` + thorough review via `/work ship`
- **XL** → Split into sub-tasks first, `/plan` each, then dispatch

## Generate tasks.md

`.devwork/{type}/{task-id}/tasks.md`: Phase checklists `- [ ] {task} → **pass**: {criteria}` + checkpoint per phase. Progress: started date, current phase, blocked status. T-Shirt Size + factor scores + execution strategy. Extended sections (M+ only): Dependency Graph (per-phase deps + parallelizable sets), Task Details (scope, blockedBy, context, steps, pass criteria, commit message).

## Update Records
- Task record: check off `create implementation plan`, set `size:` header, replace generic steps with actual phases (keep <=30 lines), update Active + date
- status.md: mark [DONE], session log, set next action

## Output
```
Plan complete: .devwork/{type}/{task-id}/plan.md
Tasks generated: .devwork/{type}/{task-id}/tasks.md
Task record updated: .devwork/tasks/{task-id}.md (size: {size})
T-shirt size: {size} | Phases: {n} | Tasks: {n} | New files: {n} | Modified: {n}
{XS: "Just do it." | S: "Work through tasks.md or /dispatch." | M/L: "Run /dispatch." | XL: "Split into sub-tasks first."}
```
