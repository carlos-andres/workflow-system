> **DEPRECATED (v3.0)** — Legacy v2.0 command file kept for reference only.  
> Active version: `~/.claude/skills/wosy-research/SKILL.md`  
> See [CHANGELOG.md](../../../CHANGELOG.md) for migration details.

---

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

### Step 2a: Parallel Research (Optional)

If the task touches 3+ independent subsystems:

> This task spans multiple areas. Parallel research available:
> 1. {domain 1} — {investigation focus}
> 2. {domain 2} — {investigation focus}
> 3. {domain 3} — {investigation focus}
>
> Dispatch parallel Explore agents? (y/n)

**If yes** — dispatch one Agent (subagent_type: "Explore") per domain:

Each agent prompt:
- Task context from status.md
- Specific domain to investigate
- Output format: Files to Modify table, Patterns Found, Dependencies, Risks
- Read constitution.md for project conventions

All agents run with `run_in_background: true`.

**After all agents return:**
1. Merge outputs into single `research.md` using standard template
2. De-duplicate overlapping findings
3. Flag conflicts between agent findings
4. Add `## Research Method: Parallel ({N} agents)` header

### Hard Rules

1. **Reference-first**: Before designing anything, find an existing implementation in this codebase that does something similar. If none exists, state that explicitly.
2. **Verify, don't assume**: Every claim in research.md must link to a file path and line range. No "the codebase probably uses X."
3. **No phantom patterns**: Only document patterns you found with `rg`/`fd` and read with your own eyes. Never infer a pattern from file names alone.
4. **Unknowns from intake**: Address every item in status.md `Unknowns` list. Each must become either a finding or a question for `/spec`.

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

### Step 5: Update Task Record

Update `.devwork/tasks/{task-id}.md`:
- Check off `research codebase` in Progress
- Update `## Active` with research summary
- Update `updated:` date

### Step 6: Proactive Memory Detection

During research, watch for **tooling patterns** that should be saved to Claude project memory. If you discover any of the following, prompt the user:

| Pattern Detected | Example | Suggested Memory File |
|-----------------|---------|----------------------|
| Database connection commands | `mysql --no-defaults --defaults-group-suffix=-local` | `tooling_database.md` |
| SSH connections | `ssh tower`, custom host aliases | `tooling_ssh.md` |
| Environment specifics | .test domains, custom nginx, PHP versions | `tooling_environment.md` |
| CLI patterns | Custom scripts, specific flags, preferred tools | `tooling_cli.md` |
| API endpoints | Internal APIs, auth patterns, base URLs | `tooling_api.md` |
| Commit/PR conventions | Branch naming, commit prefixes, PR templates | `tooling_git.md` |

**When a pattern is detected, ask:**

> I found a tooling pattern worth remembering across sessions:
> - **What**: {command/pattern}
> - **Why this way**: {what to avoid and why}
> - **Sandbox**: {any permission requirements}
>
> Save to project memory? (y/n)

**If yes**, write an operational instruction to `~/.claude/projects/<project>/memory/`:

```markdown
---
name: {pattern-name}
description: {one-line — used to decide relevance in future sessions}
type: reference
---

## {Tool/Pattern Name}
- Command: `{exact command}`
- Why this way: {what NOT to do and why}
- Prerequisites: {config files, sandbox permissions, what must exist}
- Verify: `{one-liner to confirm it works}`
```

Then update `~/.claude/projects/<project>/memory/MEMORY.md` index with a link to the new file.

**Do NOT save tooling info to task records** — tooling goes in project memory only.

### Step 7: Report Summary

Output concise summary:

```
✓ Research complete: .devwork/{type}/{task-id}/research.md
✓ Task record updated: .devwork/tasks/{task-id}.md

Key findings:
- Pattern to follow: {pattern}
- Files to modify: {count}
- Existing tests: {yes/no}
- Risks: {brief list}

Unknowns resolved: {count} / {total from intake}
Unresolved → forwarded to /spec

{If tooling patterns found:}
Tooling detected: {count} patterns — saved to project memory

Next: /spec (if requirements unclear) or /plan (if ready)
```

## Quick Research (for Hotfix)

For hotfix tasks, do a minimal research:
1. Find the file with the bug
2. Find related tests
3. Check recent changes (git log)
4. Skip full documentation - just report findings verbally
5. Still update task record progress
