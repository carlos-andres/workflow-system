# /dispatch - Task Orchestration (Always-On)

Execute tasks from plan using sub-agents. Scales from XS to XL — the conductor dispatches, agents implement.

> Reference: [Conductor Discipline](conductor.md) | [Model Assignment](models.md)

## Model Assignment

| Agent Role | Model | When |
|-----------|-------|------|
| Implementer | `sonnet` | Code writing, bug fixes, file edits |
| Researcher | `sonnet` | Codebase reading, pattern finding |
| Reporter | `sonnet` | HTML/MD report generation |
| Reviewer | `opus` | Code review, security audit |
| Architect | `opus` | Design decisions, ADR writing |

Every Agent tool call **must** specify `model:`. Never leave it implicit.

## Usage
```
/dispatch
/dispatch {task-id}    # dispatch specific task
```

## Prerequisites
- Must have `.devwork/{type}/{task-id}/tasks.md` with task breakdown (for S+)
- Constitution must exist (agents read it for conventions)
- Task record must exist in `.devwork/tasks/`

## Instructions

### Step 0: Load Context

1. Read `.devwork/tasks/{task-id}.md` (task record)
2. Read `.devwork/{type}/{task-id}/tasks.md` (task breakdown with dependency graph)
3. Read `.devwork/{type}/{task-id}/plan.md` (implementation plan)
4. Read `.devwork/constitution.md` (conventions for agents)
5. Read Claude project memory for tooling context
6. Determine T-shirt size from tasks.md header

**Scope Gate** — before dispatching any agent, verify:
- [ ] `spec.md` or `plan.md` exists in `.devwork/{type}/{task-id}/`
- [ ] Plan or spec defines a clear output and definition of done

If neither exists, stop. Run `/spec` or `/plan` first. Dispatching without a scope doc is not allowed.

### Step 1: Scale by Size

| Size | Dispatch Behavior |
|------|-------------------|
| **XS** | Single inline agent. No parallel. Conductor creates one agent, waits, updates task record. |
| **S** | Single agent with task record updates. Agent works through tasks.md checkboxes sequentially. |
| **M** | 2-3 parallel agents. Conductor identifies parallelizable sets from dependency graph, dispatches, coordinates. |
| **L** | Parallel agents + thorough review. Same as M, but after completion run verification pass before reporting done. |
| **XL** | Split first. Read tasks.md, identify natural split points, suggest 2-4 sub-tickets. Create sub-task records in `.devwork/tasks/`. Then dispatch each as M or L. |

If no size in tasks.md, check plan.md. If still no size, ask user or infer from task count.

### Step 2: Identify Parallelizable Sets

Read the dependency graph from tasks.md:

```
Phase 1: {name}
  task-1 → (no deps)
  task-2 → (no deps)
  task-3 → depends-on: [task-1]
```

Group into dispatch sets:
- **Set A**: tasks with no dependencies → dispatch ALL in parallel
- **Set B**: tasks depending on Set A → dispatch after Set A completes
- Repeat until all tasks dispatched

### Step 3: Create Session Tasks

For each unchecked step in the task breakdown:
- Create a Tasks API item for real-time session tracking
- Map Tasks API items to task record steps for sync

### Step 4: Dispatch Agents

For each parallelizable set, dispatch agents:

**Each agent gets (handoff contract):**
- Task type and description
- Path to scope document (spec.md or plan.md)
- Task details: steps, scope, pass criteria
- Constitution.md context (stack, patterns, conventions)
- Project memory (tooling patterns, connection commands)
- Permitted files list (what the agent may read/write)
- Instruction: **DO NOT commit** — report what was done
- Instruction: Write result to `.devwork/{type}/{id}/task-{n}-result.md`
- Instruction: Update `.devwork/{type}/{id}/status.md` with done log on completion

**Agent dispatch rules:**
- Use `Agent` tool with `subagent_type: "general-purpose"`
- **Always specify `model:`** — `"sonnet"` for implementation/research, `"opus"` for review/architecture
- Independent tasks: `run_in_background: true`
- Dependent tasks: wait for blockers to complete first
- For XS/S: single foreground agent (simpler, less overhead)
- For M/L: parallel background agents

### Step 5: Monitor & Coordinate

As agents complete:
1. Read each `task-{n}-result.md`
2. Check pass criteria from tasks.md
3. If agent failed: report failure, stop dispatching dependent tasks
4. If agent succeeded:
   - Update tasks.md checkbox
   - Update task record progress
   - Dispatch newly unblocked tasks
5. Update Tasks API items as agents complete

### Step 6: Merge & Report

After all tasks complete:

```
✓ Dispatch complete: {task-id}
  {N}/{total} tasks done
  {failed count} failures (if any)

Results: .devwork/{type}/{id}/task-*-result.md

Options:
1. Review changes (git diff)
2. Run /work ship (verify + deliver pipeline)
3. Continue with remaining tasks (if partial)
```

**Git-context gate** — only mention commit/PR options if:
- `.git` directory exists in project root
- The task produced file changes (not a report-only or research task)

If no `.git` or task is non-code output (HTML report, research doc, etc.) — skip git options entirely.

**Commit policy** (see [conductor.md](conductor.md), roots defined in `~/.claude/CLAUDE.md`):
- **corporate** (`WORK_ROOT`): present commit message text + PR description as copy-ready blocks. Never run git.
- **personal** (`PERSONAL_ROOT`): present commit text, offer to execute only if user explicitly approves for this project.
- **unknown**: ask once per session, default to personal behavior.

Update task record:
- Check off completed steps in `## Progress`
- Update `## Active` with completion status
- Update `updated:` date

### Step 7: Post-Dispatch (L-size only)

For L-sized tasks, automatically run a verification pass:
- Dispatch a review agent to check all changes against plan.md and constitution.md
- Report findings before offering `/work ship`

## XL Split Strategy

When size is XL:

1. Read tasks.md dependency graph
2. Identify natural boundaries (domain, layer, feature)
3. Suggest split:
   ```
   This XL task should be split into:
   1. {SUB-TASK-A}: {scope} (estimated: M)
   2. {SUB-TASK-B}: {scope} (estimated: M)
   3. {SUB-TASK-C}: {scope} (estimated: S)

   Create sub-task records? (y/n)
   ```
4. If yes: create `.devwork/tasks/{TASK-ID}-A.md`, `-B.md`, etc.
5. Link parent task record to sub-tasks in `## Dependencies`
6. Dispatch sub-tasks sequentially or in parallel based on deps

## Conductor Rules

The main window (conductor) MUST:
- **Hold context**: task record, plan, constitution, memory
- **Dispatch agents**: for ALL implementation work
- **Track progress**: update task records and Tasks API
- **Report**: keep user informed at milestones

The main window MUST NOT:
- Write implementation code directly
- Read large codebases directly (agents do this)
- Run tests directly (agents do this)
- Modify source files (agents do this)

## Constraints
- Never commit on behalf of user
- Never modify files beyond task scope
- If any agent fails, report failure and stop — don't retry without user input
- Always update task record after dispatch completes
- Clean up task-{n}-result.md files are optional — user can review or delete
