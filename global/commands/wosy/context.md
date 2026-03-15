# /context - Quick Resume After Context Switch

Fast, read-only state summary to resume work after switching contexts. Reads task records and project memory first.

## Usage
```
/context
/context {task-id}    # resume specific task
```

## Instructions

### Step 1: Read Project Memory

Check `~/.claude/projects/<project>/memory/` for relevant tooling memories:
- Database connections, SSH patterns, CLI commands
- Environment specifics, API endpoints
- Commit/PR conventions

If project memory files exist, silently load them — they inform how you'll work, not what you'll report.

### Step 2: Read Task Records

Read `.devwork/tasks/*.md` to get an overview of all tasks:
- List all task records with their status (check/uncheck counts)
- Identify which tasks are active (have unchecked items)
- Identify blocked tasks

### Step 3: Find Target Task

- If task-id provided: find matching task record in `.devwork/tasks/{task-id}.md`
- Otherwise: find the most recently updated task record (by `updated:` date)
- If no task records exist: check for workspace status.md files as fallback

### Step 4: Read Workspace Details

Once target task is identified, read its workspace:
- `.devwork/{type}/{task-id}/status.md` — for session log and next action
- Check which workspace files exist: research.md, spec.md, plan.md, tasks.md

### Step 5: Display Context

```
Task:     {task-id} — {description}
Type:     {hotfix|feature|refactor}
Size:     {XS/S/M/L/XL or "pending"}
Phase:    {current phase from status.md}
Mode:     {deep-dive|hybrid|straight} (if determinable)
Progress: {X of Y steps done} (from task record)

Active:
  {current work from task record ## Active}

Last session:
  {most recent session log entry from status.md}

Next action:
  {next action from status.md}

Workspace docs:
  {list which files exist: status.md, research.md, spec.md, plan.md, tasks.md}

{If project memory loaded:}
Tooling:
  {brief list of loaded tooling memories — e.g., "DB: mysql via my.cnf groups", "SSH: tower host configured"}
```

If multiple active tasks exist, show a summary table first:
```
Active tasks:
  {task-id-1}: {description} — {n}/{total} steps — {active work}
  {task-id-2}: {description} — {n}/{total} steps — BLOCKED: {reason}

Showing details for most recent: {task-id-1}
{... full context display above ...}
```

### Step 6: Suggest Next Step

- If work in progress: "Continue implementation" or specific next task
- If between phases: Suggest next command (e.g., "Run `/plan`" or "Run `/work ship`")
- If stale (no update in 3+ days): "Run `/status` to update before continuing"
- If no active workspace found, say so and suggest `/intake` to start
- If no project setup, suggest `/work setup`

## Key Rules
- Read-only — NEVER modify any files
- Fast — read task records first (compact), then workspace status only if needed
- Task records are the primary source — workspace files are supplementary detail
- If no active workspace found, say so and suggest `/intake` to start
- Project memory is loaded silently — only surface it if relevant to next action
