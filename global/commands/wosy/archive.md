# /archive - Archive Completed Workspaces

Move completed workspaces to `.devwork/_archive/` to keep active workspace clean.

## Usage
```
/archive                    # archive current/most recent delivered task
/archive {task-id}          # archive specific task
/archive clean              # batch-archive all DELIVERED tasks
```

## Instructions

1. **Find workspace to archive**:
   - If task-id provided: locate `.devwork/{type}/{task-id}/`
   - If `clean`: find all workspaces where status.md contains "DELIVERED"
   - Otherwise: find most recently modified workspace with DELIVERED status

2. **Verify status**:
   - Read `status.md` — must show DELIVERED status
   - If not DELIVERED: warn and ask to confirm force-archive
   - Show task summary before archiving

3. **Archive**:
   - Create `.devwork/_archive/` if it doesn't exist
   - Move workspace to `.devwork/_archive/{task-id}/`
   - Preserve all files as-is

4. **Update archive index**:
   - Append entry to `.devwork/_archive/README.md`:
     ```
     | {task-id} | {type} | {description} | {date archived} | {status} |
     ```
   - Create README.md with table header if it doesn't exist:
     ```
     # Archived Workspaces

     | Task ID | Type | Description | Archived | Status |
     |---------|------|-------------|----------|--------|
     ```

5. **Output**:
   ```
   ✓ Archived: {task-id} → .devwork/_archive/{task-id}/
   ```
   For `clean`:
   ```
   ✓ Archived {N} workspaces:
     - {task-id-1}
     - {task-id-2}
   ```

## Key Rules
- NEVER delete workspaces — always move
- ALWAYS update the archive index
- Warn if archiving a non-DELIVERED task
- For `clean`, show list and confirm before batch archiving
