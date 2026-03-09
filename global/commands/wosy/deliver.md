# /deliver - Delivery Preparation

Final verification and commit message generation. NEVER auto-commits.

## Usage
```
/deliver
```

## Prerequisites
- Implementation complete
- Tests passing
- Linting clean

## Instructions

### Step 1: Load Context

1. Read `.devwork/{type}/{task-id}/status.md`
2. Read `.devwork/{type}/{task-id}/tasks.md` (if exists)
3. Read `.devwork/{type}/{task-id}/spec.md` (if exists)

### Step 2: Detect Project Tools

1. Read `.devwork/constitution.md` for configured linters, formatters, test runners
2. If no constitution: detect from project manifests (`composer.json`, `package.json`, `Package.swift`, `Cargo.toml`, `pyproject.toml`, `go.mod`)

Use detected tools throughout — never hardcode tool names or paths.

### Step 3: Run Verification Checklist

Ask me to confirm each:

```
## Pre-Delivery Checklist

### Code Quality
- [ ] Linting/formatting passes (use detected tools)
- [ ] No debug code left (search for common debug patterns per stack)
- [ ] No commented-out code
- [ ] Follows project conventions (constitution.md)

### Testing
- [ ] Relevant tests pass (use detected test runner)
- [ ] New tests added (if new feature)
- [ ] No test regressions

### Functionality
- [ ] Acceptance criteria met (from spec.md)
- [ ] Edge cases handled
- [ ] Error handling in place

### Documentation
- [ ] Code is self-documenting or has comments where needed
- [ ] ADR updated (if decisions were made)

Ready to proceed? (y/n)
```

### Step 4: Generate Commit Message

Based on task type and changes, generate conventional commit:

**Format:**
```
{type}({scope}): {description}

{body - what and why}

{footer - references}
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code change that neither fixes a bug nor adds a feature
- `chore`: Maintenance tasks
- `docs`: Documentation only
- `test`: Adding or fixing tests

**Example:**
```
feat(inventory): add year filter to Nova resource

- Add YearFilter with dynamic year range (current+1 to current-20)
- Pre-select current year by default
- Register filter in Inventory resource

Closes AUTH-001
```

### Step 5: Show Summary

```
## Delivery Summary

### Changes
- {file}: {change description}
- {file}: {change description}

### Commit Message
```
{generated commit message}
```

### Commands
```bash
# Stage changes
git add {files}

# Commit
git commit -m "{message}"

# Or copy message and commit manually
```

### Post-Commit
- [ ] Push to feature branch
- [ ] Create PR (if applicable)
- [ ] Update ticket
```

### Step 6: Update Status (Final)

Update `.devwork/{type}/{task-id}/status.md`:

```markdown
## Current State
DELIVERED

## Tasks
[DONE] All tasks completed

## Delivery
- **Date**: {YYYY-MM-DD}
- **Commit**: {commit message first line}
- **Files Changed**: {count}

## Session Log
### {YYYY-MM-DD}
- Completed all tasks
- Passed verification checklist
- Generated commit message
- Ready for commit
```

### Step 7: Offer Graduation

Check if ticket has artifacts worth preserving:

```
This ticket has:
- Spec: {yes/no} → {graduated/not graduated}
- ADRs: {count} → {graduated/not graduated}

Graduate significant artifacts? (y/n)
- Yes: Run /graduate all
- No: Skip to archive
```

### Step 8: Offer Archive

```
Archive workspace?
- Yes: Run /archive
- No: Keep in place for reference
```

### Final Output

```
Task {task-id} complete!

Commit ready:
  git add {files}
  git commit -m "{type}({scope}): {description}"

Artifacts:
  - Spec graduated to: .devwork/specs/{task-id}-{slug}.md
  - ADR graduated to: .devwork/decisions/NNNN-{slug}.md
  - Workspace archived to: .devwork/_archive/{task-id}/
```

## Quick Deliver (for Hotfix)

For hotfixes, streamlined process:

1. Verify tests pass
2. Generate commit message
3. Show git commands

Skip detailed checklist.

## Commit Message Templates

### Feature
```
feat({scope}): {what it does}

{bullet points of changes}

Closes {task-id}
```

### Bug Fix
```
fix({scope}): {what was fixed}

{root cause and solution}

Fixes {task-id}
```

### Refactor
```
refactor({scope}): {what was refactored}

{why and what changed}

Refs {task-id}
```

## Important

- **NEVER run git commit automatically**
- **ALWAYS show the commit message for review**
- **ALWAYS let user execute the commit**
- Detect tools from constitution.md / project manifests — never hardcode tool paths
