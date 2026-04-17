---
name: wosy-status
description: Update or check task record and status file with current progress
---

# /status - Progress Update

**Load**: Find active task in `.devwork/tasks/` (most recent by `updated:` date, or match task-id). Read matching status.md. Multiple active? List them, ask which.

**Update Logic**: "blocked" → add BLOCKED item | message → mark related task DONE | no message → ask "What did you accomplish?" | `check` subcommand → read-only display (skip to Output).

**Update Files**:
- **Task record** `.devwork/tasks/{task-id}.md` (<=30 lines): check off completed `## Progress` steps, update `## Active`, update `updated:` date, add dependencies if discovered
- **Status file** `.devwork/{type}/{task-id}/status.md`: update `## Current State`, mark items `[DONE]`/`[TODO]`/`[BLOCKED]`, update `## Next Action` (specific, not vague), append to `## Session Log` under today's date
- **Task breakdown** `.devwork/{type}/{task-id}/tasks.md`: check off completed items

**Phase Completion**: All tasks in phase done → note in session log, update current phase, suggest checkpoint.

**Session Handoff**: Good: `Next Action: Implement validateYear() in YearFilter.php, then write test.` Bad: `Next Action: Continue working on the feature.`

**Blocked**: `/status blocked "reason"` → task record `## Active`: "BLOCKED: {reason}" + status.md `[BLOCKED]` item.

**Output**:
```
Done: {what was marked done}
Next: {next action}
Progress: {n}/{total} tasks
```

**Status Check** (read-only): `{task-id}: {description} | Progress: {n}/{total} | Size: {XS-XL} | Active: {current} | Blocked: {reason or no}`. Multiple tasks? Show summary for each.
