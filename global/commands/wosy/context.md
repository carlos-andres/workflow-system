# /context - Quick Resume After Context Switch

Fast, read-only state summary to resume work after switching contexts.

## Usage
```
/context
/context {task-id}    # resume specific task
```

## Instructions

1. **Find active workspace**:
   - If task-id provided: look in `.devwork/feature/{task-id}/` and `.devwork/hotfix/{task-id}/`
   - Otherwise: find most recently modified `status.md` across all `.devwork/` subdirectories

2. **Read and display** (concise, no fluff):
   ```
   Task:     {task-id} — {description}
   Type:     {hotfix|feature|refactor}
   Phase:    {current phase from status.md}
   Mode:     {deep-dive|hybrid|straight} (if determinable)
   Progress: {X of Y tasks done} or {phase status}

   Last session:
     {most recent session log entry from status.md}

   Next action:
     {next action from status.md}

   Workspace docs:
     {list which files exist: status.md, research.md, spec.md, plan.md, tasks.md, adr.md}
   ```

3. **Suggest next step**:
   - If work in progress: "Continue implementation" or specific next task
   - If between phases: Suggest next command (e.g., "Run `/plan`" or "Run `/verify`")
   - If stale (no update in 3+ days): "Run `/status` to update before continuing"

## Key Rules
- Read-only — NEVER modify any files
- Fast — read only status.md and check file existence, don't parse all docs
- If no active workspace found, say so and suggest `/intake` to start
