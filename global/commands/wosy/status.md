# /status - Progress Update

Update task record and status file with current progress. Essential for context-switching between projects.

> **Status model**: `status.md` is a **done log**, not a task list.
> It records what has been completed and verified. Pending work lives in `backlog.md` or `tasks.md`.
> The conductor reads `status.md` to understand where things stand — not what still needs doing.

## Usage
```
/status
/status "completed user validation"
/status blocked "waiting for API credentials"
/status check
```

## Prerequisites
- Must have active workspace (from /intake)

## Instructions

### Step 1: Load Task Record + Status

1. Find the active task:
   - Check `.devwork/tasks/` for task records — find the most recently updated one (or match by task-id if provided)
   - Read the matching `.devwork/{type}/{task-id}/status.md`

2. If multiple active tasks exist in `.devwork/tasks/`, list them and ask which one to update.

### Step 2: Determine Update Type

If message provided:
- If contains "blocked" → add to BLOCKED items
- Otherwise → mark related task as DONE

If no message:
- Ask: "What did you accomplish?" (brief)

### Step 3: Update Task Record

Update `.devwork/tasks/{task-id}.md`:
- Check off completed steps in `## Progress`
- Update `## Active` with current work description
- Update the `updated:` date in the header
- Add dependencies if discovered

**Task record must stay ≤30 lines.** If it's growing, you're adding too much detail — keep it chart-level.

```markdown
# {TASK-ID}: {Brief Description}
type: feature | size: M | created: 2026-01-15 | updated: {TODAY}

## Progress
- [x] research codebase
- [x] define requirements
- [x] create implementation plan
- [ ] implement solution (3/8 files done)
- [ ] test changes
- [ ] deliver

## Active
implementing UserService — blocked on auth middleware refactor

## Dependencies
- auth middleware must complete before user service
- image pipeline must resolve before QA

## Workspace
.devwork/feature/{task-id}/
```

### Step 4: Update status.md

Update the workspace status file. **Done log only** — no [TODO] items here.
Pending work belongs in `backlog.md` or `tasks.md`.
Max 20 lines.

```markdown
# Status: {task-id}

## Current
{Single line: what is being worked on right now. Or "complete — ready for /work ship"}

## Done
- [x] Research codebase (YYYY-MM-DD)
- [x] Define requirements (YYYY-MM-DD)
- [x] Create implementation plan (YYYY-MM-DD)
- [x] {newly completed step} (TODAY)

## Blocked
{If applicable: "Waiting for X" — otherwise omit this section}

## Session Log
### {YYYY-MM-DD}
- {previous entries}

### {TODAY}
- {new accomplishment}
```

If there are pending items, put them in `tasks.md` (checkboxes) or `backlog.md` — not in `status.md`.

### Step 5: Update tasks.md (if exists)

Check off completed items in `.devwork/{type}/{task-id}/tasks.md`

### Step 6: Check for Phase Completion

If all tasks in a phase are done:
- Note phase completion in session log
- Update "Current Phase" in tasks.md
- Suggest running checkpoint verification

### Step 7: Confirm

Output (terse):

```
✓ Status updated
✓ Task record updated: .devwork/tasks/{task-id}.md

Done: {what was marked done}
Next: {next action}
Progress: {n}/{total} tasks
```

## Quick Status Check

If you just want to see current status without updating:
```
/status check
```

Reads task records from `.devwork/tasks/` and outputs:

```
Active tasks:
  {task-id}: {description}
    Progress: {n}/{total} steps
    Active: {current work}
    Size: {XS/S/M/L/XL}

  {task-id-2}: {description}
    Progress: {n}/{total} steps
    Active: {current work}
    Blocked: {reason}
```

If only one active task, show single-task format:
```
{task-id}: {description}
Phase: {current phase}
Progress: {n}/{total} tasks
Blocked: {yes/no}
Next: {next action}
```

## Session Handoff

When ending a work session, run `/status` to update the done log. Future-you reads `status.md` to see what's verified, then `tasks.md` to see what's next.

The **task record** (`.devwork/tasks/{id}.md`) holds the next action pointer — keep it updated.

Good task record `## Active`:
```
## Active
implementing validateYear() in YearFilter.php — tests next
```

Bad task record `## Active`:
```
## Active
continue working on feature
```

## Blocked Status

When blocked:
```
/status blocked "waiting for client to provide API keys"
```

Updates both task record and status.md:
- Task record `## Active`: adds "BLOCKED: {reason}"
- Status.md: adds `[BLOCKED]` item with reason
