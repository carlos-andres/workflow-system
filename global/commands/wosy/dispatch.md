# /dispatch - Task Orchestration

Execute tasks from plan using sub-agents. Wosy's built-in orchestrator
for M-sized tasks. For L-sized tasks, add thorough `/verify` review.

## Usage
```
/dispatch
```

## Prerequisites
- Must have `.devwork/{type}/{task-id}/tasks.md` with dependency graph
- Sizing must be M or L (if XL, remind user to split or escalate to superpowers)
- Constitution must exist (agents read it for conventions)

## Instructions

### Step 1: Load & Validate
1. Read tasks.md — check sizing is M or L
2. Read dependency graph — identify parallelizable sets
3. Read constitution.md — will be passed to each agent
4. If sizing is XL, refuse: "This task is XL. Split into smaller tickets first, or escalate to `superpowers:subagent-driven-development`."
5. If sizing is S or XS, refuse: "This task is {size}. Work through tasks.md checkboxes manually — dispatch overhead isn't worth it."

### Step 2: Dispatch Implementation Tasks

For each parallelizable set:

**Independent tasks (no deps) → dispatch ALL in parallel:**
Each task gets an Agent (subagent_type: "general-purpose") with:
- Task details from tasks.md (steps, scope, pass criteria)
- Constitution.md context (stack, patterns, conventions)
- Integration config (from constitution Integrations section)
- Instruction: write result to `.devwork/{type}/{id}/task-{n}-result.md`
- Instruction: DO NOT commit — report what was done

Run with `run_in_background: true` where no deps exist.

**Dependent tasks → wait for blockers, then dispatch sequentially.**

### Step 3: Merge & Report

After all tasks complete:
1. Read each `task-{n}-result.md`
2. Update tasks.md checkboxes (mark completed)
3. Update status.md with progress

### Step 4: Offer Review

> Implementation complete. {N}/{total} tasks done.
>
> Results: .devwork/{type}/{id}/task-*-result.md
>
> Options:
> 1. Review changes manually (git diff)
> 2. Run /verify for phase checkpoint
> 3. Run /deliver if ready

Do NOT auto-commit. Do NOT auto-review. Human decides next step.

## Constraints
- Never commit on behalf of user
- Never modify files beyond task scope
- If any agent fails, report failure and stop — don't retry
- If sizing is XL, refuse and recommend splitting or superpowers
