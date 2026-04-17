---
name: wosy-work
description: Smart router + conductor entrypoint. Modes: default (auto-detect), setup, ship.
---

# /work

Parse args: `setup [update|reset|repair]` | `ship` | empty = Smart Router.

## Smart Router (no args)

1. Read `.devwork/tasks/*.md`, `.devwork/constitution.md`, project memory
2. First-match routing:
- No `.devwork/` or constitution.md → "Run `/work setup`"
- No task records → "Run `/intake`"
- Task missing research.md → "Run `/research`"
- Has research, no plan.md → "Run `/plan`"
- Plan exists, unchecked tasks → "Run `/dispatch`"
- All steps checked → "Run `/work ship`"
- Multiple active tasks → list all, suggest most progressed
3. Show: project name, active task + progress, recommended command. Wait for confirmation.

**Conductor pattern**: main window orchestrates only — dispatch sub-agents for all implementation — update task records as agents complete.

## /work setup

Flags: (none)=full | `update`=re-scan, preserve Manual Notes/Do NOT Touch | `reset`=backup + fresh | `repair`=fix dirs only

**Full**: 1) mkdir `.devwork/{decisions,specs,feature,hotfix,_archive,_scratch,tasks}`, verify gitignore 2) Detect stack from manifests, parallel agents scan: languages, frameworks, arch, quality, testing, infra, integrations 3) Dispatch Explore agent: sample 5-10 files/category, extract conventions 4) Generate `.devwork/constitution.md` (stack-relevant only) 5) Generate project `CLAUDE.md` (interview for what can't be inferred) 6) Detect tooling patterns (DB, SSH, CLI, API) → prompt user to save to project memory

**Update**: Re-run detection. Preserve `## Do NOT Touch` and `## Manual Notes` verbatim. Diff and show changes. Check for new tooling patterns.
**Reset**: Backup constitution.md.bak then run full setup.
**Repair**: Fix directory structure + missing indexes only. No scanning.

## /work ship

Sequential pipeline with gates. User can bail at any gate. NEVER auto-commit.

**Gate 1 — Verify**: All tasks done (or deferred), tests pass, lint/format passes, no debug code, acceptance criteria met, ADR updated if needed.

**Agent Review** (code tasks only — skip for brainstorm/report/spec): Dispatch code-reviewer + security-auditor agents on changed files. Run tests covering changed code. Optional simplify pass for heavy-load code. Critical findings → BLOCK. Warning → show user, ask fix/proceed. Test fail → BLOCK. Report: passed/failed/skipped counts + failure details.

**Gate 2 — Deliver**: Code quality + tests + acceptance criteria. Generate conventional commit. Show delivery summary (file list + commit message). **NEVER auto-commit** — show commands, user executes. Update task record + status.md.

**Gate 3 — Graduate** (optional): Prompt if spec/ADRs exist → graduate to `.devwork/specs/` and `.devwork/decisions/`. Update indexes.

**Gate 4 — Archive** (optional): Prompt to move workspace to `.devwork/_archive/`. Update task record.

**Final Output**: Task shipped summary: commit, graduated artifacts, archive location, task record path.

## Rules
- Task records first: read `.devwork/tasks/` before acting
- Load project memory on every `/work` invocation
- Never auto-commit
- Gates are optional: user can bail anytime
