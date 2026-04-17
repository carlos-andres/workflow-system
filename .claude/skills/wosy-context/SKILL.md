---
name: wosy-context
description: Quick resume after context switch — read-only state summary
---

# /context - Quick Resume

## Steps
1. **Project memory**: Load `~/.claude/projects/<project>/memory/` silently
2. **Task records**: Read `.devwork/tasks/*.md` — list all with status, identify active/blocked
3. **Target task**: Match task-id if provided, else most recently updated. Fallback: workspace status.md
4. **Workspace**: Read `.devwork/{type}/{task-id}/status.md` for session log + next action. Note which docs exist

## Display
```
Task: {task-id} -- {description}  |  Type: {hotfix|feature|refactor}  |  Size: {XS-XL}
Progress: {X of Y steps done}
Active: {from task record}  |  Last: {most recent log entry}
Next: {next action}  |  Docs: {existing files}  |  Tooling: {loaded memories}
```
Multiple active tasks? Show summary table first, then details for most recent.

## Suggest Next Step
Work in progress → specific next task | Between phases → suggest next command | Stale 3+ days → "Run `/status` to update" | No workspace → `/intake` | No project setup → `/work setup`

## Rules
Read-only — NEVER modify files. Task records are primary source; workspace files supplementary. Project memory loaded silently — only surface if relevant.
