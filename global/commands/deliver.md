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

1. Read `.devwork/{type}/{jira-id}/status.md`
2. Read `.devwork/{type}/{jira-id}/tasks.md` (if exists)
3. Read `.devwork/{type}/{jira-id}/spec.md` (if exists)

### Step 2: Run Verification Checklist

Ask me to confirm each:

```
## Pre-Delivery Checklist

### Code Quality
- [ ] Linting passes (pint, phpstan, eslint)
- [ ] No debug code left (dd(), console.log(), var_dump())
- [ ] No commented-out code
- [ ] Follows project conventions (constitution.md)

### Testing
- [ ] Relevant tests pass
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

### Step 3: Generate Commit Message

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

Closes TASKS-1400
```

### Step 4: Show Summary

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
- [ ] Update Jira ticket
```

### Step 5: Update Status (Final)

Update `.devwork/{type}/{jira-id}/status.md`:

```markdown
## Current State
✅ DELIVERED

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

### Step 6: Offer Archive

```
Task complete! Archive workspace?
- Yes: Move to .devwork/_archive/{jira-id}/
- No: Keep in place for reference

(You can archive later manually)
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

Closes {JIRA-ID}
```

### Bug Fix
```
fix({scope}): {what was fixed}

{root cause and solution}

Fixes {JIRA-ID}
```

### Refactor
```
refactor({scope}): {what was refactored}

{why and what changed}

Refs {JIRA-ID}
```

## Important

- **NEVER run git commit automatically**
- **ALWAYS show the commit message for review**
- **ALWAYS let user execute the commit**

---

## After Commit: Graduation & Archive

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
- Yes: Move .devwork/{type}/{jira-id}/ to .devwork/_archive/{jira-id}/
- No: Keep in place for reference

(You can archive later with: mv .devwork/{type}/{jira-id} .devwork/_archive/)
```

### Final Output

```
✓ Task NT-0001 complete!

Commit ready:
  git add {files}
  git commit -m "feat(auth): add user authentication"

Artifacts:
  - Spec graduated to: .devwork/specs/nt-0001-user-authentication.md
  - ADR graduated to: .devwork/decisions/0001-auth-choice.md
  - Workspace archived to: .devwork/_archive/nt-0001/

🎉 Well done!
```
