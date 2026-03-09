# /research - Codebase Exploration

Explore the codebase to understand patterns, conventions, and related code before making changes.

## Usage
```
/research
```

## Prerequisites
- Must run `/intake` first (workspace must exist)
- Read `.devwork/constitution.md` if it exists

## Instructions

### Step 1: Load Context

1. Read `.devwork/{type}/{task-id}/status.md` to understand the task
2. Read `.devwork/constitution.md` for project conventions
3. Read project root `CLAUDE.md` for project-specific rules

### Step 2: Explore Codebase

### Hard Rules

1. **Reference-first**: Before designing anything, find an existing implementation in this codebase that does something similar. If none exists, state that explicitly.
2. **Verify, don't assume**: Every claim in research.md must link to a file path and line range. No "the codebase probably uses X."
3. **No phantom patterns**: Only document patterns you found with `rg`/`fd` and read with your own eyes. Never infer a pattern from file names alone.
4. **Unknowns from intake**: Address every item in status.md `Unknowns` list. Each must become either a finding or a question for `/wosy:spec`.

Using `rg` (ripgrep) and `fd`, search for:

1. **Similar functionality**
   - Find existing code that does something similar
   - Note patterns used (Service, Repository, Action, etc.)

2. **Related files**
   - Controllers, Models, Services that will be affected
   - Existing tests for those files
   - Routes, configs, migrations

3. **Conventions in use**
   - Import style in similar files
   - Naming patterns
   - Error handling patterns
   - Validation patterns

4. **Potential conflicts**
   - Code that might break
   - Dependencies on the code you'll change
   - Recent changes in the area (check git log)

### Step 3: Document Findings

Update `.devwork/{type}/{task-id}/research.md`:

```markdown
# Research: {task-id}

> Codebase exploration for: {brief description}

## Related Files

### Will Modify
| File | Purpose | Notes |
|------|---------|-------|
| `{path}` | {what it does} | {any concerns} |

### Will Reference
| File | Purpose | Pattern to Follow |
|------|---------|-------------------|
| `{path}` | {similar functionality} | {pattern used} |

## Existing Patterns

### Code Pattern
```
// Example from {file}
{code snippet showing the pattern to follow}
```

### Test Pattern
```
// Example from {test file}
{code snippet showing test pattern}
```

## Verified References

| What I Need to Build | Existing Reference | File:Line |
|-----------------------|-------------------|-----------|
| {component/pattern}   | {similar impl found} | `{path}:{line}` |

> If no reference exists for a component, state: "No existing reference — new pattern."

## Conventions Detected

- **Validation**: {Form Requests / inline / other}
- **Error Handling**: {exceptions / response codes / other}
- **Naming**: {conventions observed}
- **Structure**: {thin controllers + services / fat controllers / etc}

## Dependencies

### This code depends on:
- {list dependencies}

### Code that depends on this:
- {list dependents - things that might break}

## Risks & Considerations

- {potential issues discovered}
- {areas requiring extra caution}
- {performance considerations}

## Existing Tests

| Test File | Coverage |
|-----------|----------|
| `{path}` | {what it tests} |

## Questions for /spec

- {questions that arose during research}
- {unclear requirements discovered}
```

### Step 4: Update Status

Update `.devwork/{type}/{task-id}/status.md`:

```markdown
## Tasks
[DONE] Research codebase
[TODO] ...

## Next Action
Run `/spec` to clarify requirements (if needed) or `/plan` to design implementation.

## Session Log
### {YYYY-MM-DD}
- Researched codebase
- Found {n} related files
- Identified pattern: {pattern}
```

### Step 5: Report Summary

Output concise summary:

```
✓ Research complete: .devwork/{type}/{task-id}/research.md

Key findings:
- Pattern to follow: {pattern}
- Files to modify: {count}
- Existing tests: {yes/no}
- Risks: {brief list}

Unknowns resolved: {count} / {total from intake}
Unresolved → forwarded to /wosy:spec

Next: /spec (if requirements unclear) or /plan (if ready)
```

## Quick Research (for Hotfix)

For hotfix tasks, do a minimal research:
1. Find the file with the bug
2. Find related tests
3. Check recent changes (git log)
4. Skip full documentation - just report findings verbally
