> **DEPRECATED (v3.0)** — Legacy v2.0 command file kept for reference only.  
> Active version: `~/.claude/skills/wosy-work/SKILL.md`  
> See [CHANGELOG.md](../../../CHANGELOG.md) for migration details.

---

# /work - Smart Router & Conductor

The primary entrypoint for the workflow system. Reads project state, auto-detects phase, dispatches the right command. The main window is the **conductor** — it holds context and orchestrates, never implements.

## Usage
```
/work                    # Auto-detect and suggest next action
/work setup              # Project setup (constitution + project-init)
/work setup update       # Re-scan, preserve manual notes
/work setup reset        # Fresh start (backs up existing)
/work setup repair       # Fix structure issues only
/work ship               # Pipeline: verify → deliver → graduate → archive
```

## Arguments
$ARGUMENTS

## Instructions

### Route by Arguments

Parse `$ARGUMENTS`:
- `setup` → Jump to **`/work setup`** section below
- `setup update` → Jump to `/work setup` with `update` flag
- `setup reset` → Jump to `/work setup` with `reset` flag
- `setup repair` → Jump to `/work setup` with `repair` flag
- `ship` → Jump to **`/work ship`** section below
- Empty / no args → Run **Smart Router** (default)

---

## Smart Router (default: no arguments)

### Step 1: Read Project State

1. Check if `.devwork/` exists
2. Read `.devwork/tasks/*.md` for active task records
3. Read Claude project memory from `~/.claude/projects/<project>/memory/` for tooling context
4. Check if `.devwork/constitution.md` exists

### Step 2: Determine Current State & Recommend

Evaluate conditions in order (first match wins):

| Condition | Recommendation |
|-----------|---------------|
| No `.devwork/` directory | "No project setup found. Run `/work setup` to initialize." |
| No `.devwork/constitution.md` | "No constitution found. Run `/work setup` to scan project." |
| No active task records in `.devwork/tasks/` | "No active tasks. Run `/intake` to start a new task." |
| Active task with no research.md | "Task {id} needs research. Run `/research`." |
| Active task with research but no plan.md | "Task {id} has research, needs planning. Run `/plan`." |
| Active task with plan, unchecked items in tasks.md | "Task {id} ready for implementation. Run `/dispatch`." |
| Active task with all steps checked in task record | "Task {id} looks complete. Run `/work ship` to deliver." |
| Multiple active tasks | List all with status, suggest most recent or most progressed. |

### Step 3: Present & Confirm

```
Project: {project name from constitution or directory}
{If tooling memories loaded: "Tooling: {count} patterns loaded from project memory"}

{If single active task:}
Active: {task-id} — {description}
  Progress: {n}/{total} steps
  Active: {current work}
  Next: {recommended command}

{If multiple active tasks:}
Active tasks:
  1. {task-id}: {description} — {n}/{total} — {status}
  2. {task-id}: {description} — {n}/{total} — {status}

Recommended: {command} for {task-id}

{If no tasks:}
No active tasks.
→ /intake {ID} "description" to start a new task
```

Wait for user confirmation before executing the recommended command.

### Step 4: Conductor Pattern

When executing any command from the router, the main window stays as **conductor**:

1. **Never write implementation code** — dispatch sub-agents for all implementation work
2. **Hold context** — task record, plan, project memory, constitution
3. **Create Tasks API items** from task record steps for session tracking
4. **Dispatch sub-agents** for code reading, writing, testing, research
5. **Update task record** as agents complete work
6. **Report progress** to user at natural milestones

The conductor's job is to coordinate, not to code.

---

## /work setup

Merges the functionality of the former `/constitution`, `/project-init`, and `/rebuild` commands into a single setup command.

### Parse Flags

| Flag | Behavior |
|------|----------|
| (none) | Full constitution scan + project-init (first time setup) |
| `update` | Re-scan project, preserve Manual Notes & Do NOT Touch sections |
| `reset` | Backup existing constitution to `.devwork/constitution.md.bak`, start fresh |
| `repair` | Fix directory structure only, no scan |

### Full Setup (no flag)

Execute the full constitution generation flow:

**Phase 0: Pre-flight**
- Check for Phase 0 docs in `.devwork/_scratch/phase0/`
- Read README.md if exists
- If Phase 0 docs exist, read them in order (01→06) for context

**Phase 1: Structure**
```bash
mkdir -p .devwork/{decisions,specs,feature,hotfix,_archive,_scratch,tasks}
```
- Create indexes: `decisions/README.md`, `specs/README.md`
- Verify gitignore: check `~/.gitignore_global` and `.gitignore` for `.devwork`

**Phase 2: Parallel Detection**
- Identify project stack from manifests (Package.swift, composer.json, package.json, etc.)
- Dispatch stack-specific detection tasks as parallel agents
- Detect: languages, frameworks, architecture, quality tools, testing, infrastructure
- Detect integrations: code hosting (git remote), ticket systems, PR CLIs

**Phase 3: Sample Extraction**
- Dispatch Explore agent to sample 5-10 files per category
- Extract: method signatures, return types, error patterns, naming conventions

**Phase 4: Generate Constitution**
- Output `.devwork/constitution.md` using the adaptive template from the old `/constitution` command
- Include only sections relevant to detected stack

**Phase 5: Generate Project CLAUDE.md**
- Analyze project (same as old `/project-init`)
- Interview user for what cannot be inferred (one-liner, users, role)
- Generate project `CLAUDE.md` with persona, workflow, commands, integrations, orchestration sections

**Phase 6: Memory Detection**
- Scan detected tooling patterns (DB connections, SSH hosts, CLI tools, API endpoints)
- For each pattern found, prompt user: "Save to project memory? (y/n)"
- If yes, write operational instructions to `~/.claude/projects/<project>/memory/`
- Update `MEMORY.md` index

**Output:**
```
✓ Constitution: .devwork/constitution.md
✓ Project CLAUDE.md: CLAUDE.md
{✓ Project memory: {n} tooling patterns saved}

Stack: {Language} {X} / {Framework} {X}
Architecture: {Pattern}
Patterns: {N} extracted
Quality: {tools}

Ready: /intake {TICKET} "description"
```

### Update Flag

1. Read existing `.devwork/constitution.md`
2. **Preserve verbatim**: `## Do NOT Touch`, `## Manual Notes`
3. Re-run all detection tasks
4. Diff detected vs existing — show changes
5. Update constitution with new results, preserved sections untouched
6. Re-run project CLAUDE.md generation (preserve `## Current Focus` and custom sections)
7. Check for new tooling patterns → prompt to save to memory

### Reset Flag

1. Backup: `cp .devwork/constitution.md .devwork/constitution.md.bak`
2. Run full setup as if first time
3. Note backup location in output

### Repair Flag

1. Fix directory structure only:
   ```bash
   mkdir -p .devwork/{decisions,specs,feature,hotfix,_archive,_scratch,tasks}
   ```
2. Create missing index files
3. Verify gitignore
4. No scanning, no constitution changes

---

## /work ship

Sequential delivery pipeline with gates. User can bail at any gate.

### Gate 1: Verify

Run verification checklist (same logic as old `/verify`):

1. Find active workspace
2. Determine phase to verify (research/spec/plan/deliver)
3. Run checks:
   - All tasks in tasks.md marked done (or explicitly deferred)
   - Tests pass (detect tools from constitution.md or manifests)
   - Linting/formatting passes
   - No debug code left (search for debug patterns by stack)
   - Acceptance criteria met (check against spec.md if exists)
   - ADR updated if architectural decisions were made

4. Report results:
   ```
   ✓ Verify: {phase}
   Passed: {count} | Failed: {count} | Skipped: {count}
   {Details of failures}
   ```

5. If failures: show what's missing, suggest fix. Ask: "Fix issues and continue, or proceed anyway?"
6. Update task record with verification status

**Gate**: User must confirm to continue to Gate 2.

### Gate 2: Deliver

Run delivery preparation (same logic as old `/deliver`):

1. Load context (status.md, tasks.md, spec.md)
2. Detect project tools from constitution
3. Run pre-delivery checklist:
   - Code quality: linting, no debug code, follows conventions
   - Testing: relevant tests pass, new tests added
   - Functionality: acceptance criteria met, edge cases handled
4. Generate conventional commit message
5. Show delivery summary with git commands

```
## Delivery Summary

Changes: {file list}
Commit: {generated message}

Commands:
  git add {files}
  git commit -m "{message}"
```

6. Update task record: mark deliver step as done
7. Update status.md: set state to DELIVERED

**NEVER auto-commit.** Show message, let user execute.

**Gate**: User must confirm to continue to Gate 3.

### Gate 3: Graduate (optional)

Check if ticket has artifacts worth preserving:

```
This ticket has:
- Spec: {yes/no}
- ADRs: {count}

Graduate significant artifacts? (y/n)
```

If yes:
- Graduate specs to `.devwork/specs/{task-id}-{slug}.md`
- Graduate ADRs to `.devwork/decisions/NNNN-{slug}.md`
- Update decision index
- Same logic as old `/graduate` command

If no: skip to Gate 4.

### Gate 4: Archive (optional)

```
Archive workspace? (y/n)
→ Moves .devwork/{type}/{task-id}/ to .devwork/_archive/{task-id}/
```

If yes:
- Move workspace to `_archive/`
- Update archive index (`.devwork/_archive/README.md`)
- Update task record: mark as archived
- Same logic as old `/archive` command

If no: keep workspace in place.

### Final Output

```
✓ Task {task-id} shipped!

{If committed:}
Commit: {type}({scope}): {description}

{If graduated:}
Graduated:
  Spec → .devwork/specs/{filename}
  ADR → .devwork/decisions/{filename}

{If archived:}
Archived → .devwork/_archive/{task-id}/

Task record: .devwork/tasks/{task-id}.md (updated)
```

---

## Key Rules

- **Conductor pattern**: Main window orchestrates, sub-agents implement
- **Task records first**: Always read `.devwork/tasks/` before acting
- **Project memory**: Load tooling context from Claude memory on every `/work` invocation
- **Never auto-commit**: Always show git commands, let user execute
- **Gates are optional**: User can bail at any point in `/work ship`
- **Backward compatible**: Old workflow paths still work (`/intake` → `/research` → etc.)
