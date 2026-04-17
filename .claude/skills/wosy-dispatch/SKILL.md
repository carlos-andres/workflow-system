---
name: wosy-dispatch
description: Task orchestration — dispatch sub-agents scaled by T-shirt size (XS-XL)
---

# /dispatch - Task Orchestration

**Load Context**: Read task record (`.devwork/tasks/{task-id}.md`), tasks.md (breakdown + deps), plan.md, constitution.md. Determine T-shirt size from tasks.md header.

**Scale by Size**:
- **XS** → Single foreground agent, no parallel
- **S** → Single agent, sequential through tasks.md checkboxes
- **M** → 2-3 parallel background agents from dependency graph
- **L** → Same as M + verification pass after all complete
- **XL** → Split into 2-4 sub-tickets by domain/layer/feature, create `.devwork/tasks/{id}-A.md` etc., dispatch each as M/L
- No size found? Infer from task count or ask user.

**Parallelizable Sets** from dependency graph: Set A (no-dep tasks) → dispatch ALL in parallel → Set B (depends on A) → dispatch after A completes → repeat until done.

**Agent Dispatch**: Each agent receives task steps + scope + pass criteria, constitution context, file paths, expected outcomes. Use `Agent` tool with `subagent_type: "general-purpose"`. Independent tasks: `run_in_background: true`. Dependent tasks: wait for blockers. Agents write results to `.devwork/{type}/{id}/task-{n}-result.md`. Agents **DO NOT commit**.

**Monitor & Coordinate**: As agents complete — read result, check pass criteria. Failure → stop dependents, report to user. Success → update tasks.md checkbox + task record, dispatch unblocked tasks.

**Merge & Report**: Show done/total/failures count, result file paths, options (git diff | /work ship | continue remaining). Update task record: progress checkboxes, active status, updated date.

**Script-and-Defer**: Build/compress/sync/deploy/long-running ops → write reusable .sh to `.devwork/{type}/{id}/scripts/` (detect OS, include flags from constitution.md, chmod +x). Tell user to run in another terminal. NEVER run directly.

**Conductor Rules**: Conductor MUST hold context, dispatch agents, track progress, report milestones. Conductor MUST NOT write implementation code, read large codebases, run tests, or modify source files.

**Constraints**: Never commit for user. Never modify files beyond task scope. Agent failure → report and stop, no auto-retry. Always update task record after dispatch.
