---
name: wosy-research
description: Explore codebase before changes. Parallel agents for multi-domain tasks. Detect tooling patterns.
---

# /research

Prereq: `/intake` done, workspace exists. Read constitution.md, status.md, CLAUDE.md first.

## Explore Codebase

If task touches 3+ subsystems, offer parallel Explore agents (`run_in_background: true`). Merge, de-duplicate, flag conflicts.

**Rules**: (1) Reference-first — find existing similar impl before designing. (2) Verify — every claim links to file:line, no "probably uses X." (3) No phantom patterns — only document what you found via rg/fd. (4) Resolve intake unknowns — each becomes a finding or /spec question.

**Search for**: similar functionality + patterns, related files (controllers/models/services/tests/routes/configs), conventions (imports/naming/errors/validation), potential conflicts (breakage/deps/recent changes).

## Write research.md

`.devwork/{type}/{task-id}/research.md` sections:
- **Will Modify**: file, purpose, notes
- **Will Reference**: file, purpose, pattern to follow
- **Existing Patterns**: code + test snippets from actual files
- **Verified References**: what to build, existing reference file:line (or "new pattern")
- **Conventions Detected**: validation, error handling, naming, structure
- **Dependencies**: depends-on + depended-on-by
- **Risks**: issues, caution areas, performance
- **Existing Tests**: test file, coverage
- **Questions for /spec**: unresolved items

## Update Records
- status.md: mark research [DONE], add session log, set next action
- Task record: check off `research codebase`, update Active + date

## Memory Detection
Watch for tooling patterns (DB, SSH, env, CLI, APIs, git). When found, prompt: `Tooling: {what} / Why: {reason} / Sandbox: {perms} — Save? (y/n)`. If yes, write to `~/.claude/projects/<project>/memory/`. Never save tooling to task records.

## Output
```
Research complete: .devwork/{type}/{task-id}/research.md | Task record updated
Findings: {pattern}, {file count} files, {test count} tests, {risks}
Unknowns resolved: {n}/{total} | {Tooling: {n} patterns saved}
Next: /spec (if unclear) or /plan (if ready)
```

### Quick Research (Hotfix)
Minimal: find bug file, related tests, recent git changes. Report verbally. Still update task record.
