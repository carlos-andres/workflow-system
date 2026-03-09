# /status - Progress Update

Update the status file with current progress. Essential for context-switching between projects.

## Usage
```
/status
/status "completed user validation"
/status blocked "waiting for API credentials"
```

## Prerequisites
- Must have active workspace (from /intake)

## Instructions

### Step 1: Load Current Status

Read `.devwork/{type}/{task-id}/status.md`

### Step 2: Determine Update Type

If message provided:
- If contains "blocked" → add to BLOCKED items
- Otherwise → mark related task as DONE

If no message:
- Ask: "What did you accomplish?" (brief)

### Step 3: Update status.md

Update the relevant sections:

```markdown
# Status: {task-id}

## Current State
{Updated description of where we are now}

## Tasks
[DONE] Research codebase
[DONE] Define requirements
[DONE] Create implementation plan
[DONE] {newly completed task}
[TODO] {remaining tasks}
[BLOCKED] {blocked items with reason}

## Next Action
{Clear, specific next step to take}

## Session Log
### {YYYY-MM-DD}
- {previous entries}

### {TODAY}
- {new accomplishment}
```

### Step 4: Update tasks.md (if exists)

Check off completed items in `.devwork/{type}/{task-id}/tasks.md`

### Step 5: Check for Phase Completion

If all tasks in a phase are done:
- Note phase completion in session log
- Update "Current Phase" in tasks.md
- Suggest running checkpoint verification

### Step 6: Confirm

Output (terse):

```
✓ Status updated

Done: {what was marked done}
Next: {next action}
Progress: {n}/{total} tasks
```

## Quick Status Check

If you just want to see current status without updating:
```
/status check
```

Output:
```
{task-id}: {description}
Phase: {current phase}
Progress: {n}/{total} tasks
Blocked: {yes/no}
Next: {next action}
```

## Session Handoff

When ending a work session, run `/status` with a clear "Next Action" so future-you (or Claude) knows exactly where to pick up:

Good:
```
Next Action: Implement the `validateYear()` method in YearFilter.php, then write test.
```

Bad:
```
Next Action: Continue working on the feature.
```

## Blocked Status

When blocked:
```
/status blocked "waiting for client to provide API keys"
```

Updates status.md:
```markdown
## Tasks
[BLOCKED] API integration - waiting for client to provide API keys

## Current State
Implementation paused. Cannot proceed with Phase 2 until API credentials received.

## Next Action
Follow up with client about API keys. Once received, continue with API integration.
```
