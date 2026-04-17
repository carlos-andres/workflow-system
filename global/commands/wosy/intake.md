> **DEPRECATED (v3.0)** — Legacy v2.0 command file kept for reference only.  
> Active version: `~/.claude/skills/wosy-intake/SKILL.md`  
> See [CHANGELOG.md](../../../CHANGELOG.md) for migration details.

---

# /intake - Task Intake & Workspace Setup

Classify the task and create the working environment + task record.

## Usage
```
/intake {task-id} "{brief description}"
```

## Example
```
/intake AUTH-001 "Add user authentication"
```

## Instructions

### Step 1: Ensure Project Structure

First, ensure the global `.devwork/` structure exists:

```bash
mkdir -p .devwork/{decisions,specs,feature,hotfix,_archive,_scratch,tasks}
```

**Global Structure** (created once per project):
```
.devwork/
├── constitution.md      # Project-wide (run /work setup)
├── tasks/               # Task records (clinical charts)
├── decisions/           # Graduated ADRs (numbered, shareable)
├── specs/               # Graduated specs (final, shareable)
├── feature/             # Active feature work
├── hotfix/              # Active hotfix work
└── _archive/            # Completed tickets
```

### Step 2: Check for Phase 0 Docs

Look for `.devwork/_scratch/phase0/` — if found:
- Read `01-idea.md`, `03-decisions.md`, `04-specs.md` for context
- Use them to pre-populate task context in status.md
- Note Phase 0 docs in workspace references

### Step 3: Classify the Task

Ask me ONE question:

> **What type of task is this?**
> 1. **Hotfix** - Urgent production fix (light docs)
> 2. **Bugfix** - Non-urgent bug fix (medium docs)
> 3. **Feature** - New functionality (full docs)
> 4. **Refactor** - Code improvement (full docs)

### Step 4: Determine Scope (for Feature/Refactor)

If Feature or Refactor, ask:

> **Is the scope clear?**
> 1. **Yes** - I know exactly what to build (skip /spec)
> 2. **No** - Requirements need clarification (full workflow with /spec)

### Step 4b: Define Intent

Before proceeding, state explicitly:

> **Goal**: What specific outcome does this task produce?
> **Touches**: What part of the system is being changed? (e.g., "API auth layer", "checkout flow")
> **Stack**: What stack/tools will this touch? (verify against constitution.md)

**Anti-assumption rules:**
- If the description is vague, challenge it. Ask "what does X mean in this codebase?"
- Never infer architecture from the description alone — flag unknowns for `/research`
- If the task touches code you haven't read, mark scope as **unclear** regardless of what the user said

### Step 5: Suggest Work Mode

Based on classification and context:

| Condition | Suggested Mode |
|-----------|---------------|
| Phase 0 docs exist + greenfield | **Mode 1: Deep Dive** — `/phase0` → `/work setup` → `/intake` → `/research` → `/spec` → `/plan` → `/dispatch` → `/work ship` |
| Existing codebase + feature/refactor | **Mode 2: Hybrid** — `/intake` → `/research` → `/plan` → `/dispatch` → `/work ship`. Skip `/spec` if requirements clear. |
| Hotfix / bugfix / clear scope | **Mode 3: Straight** — `/intake` → implement → `/work ship`. Or skip `/intake` entirely if no tracking needed. |

### Step 6: Create Ticket Workspace

Based on classification, create the workspace:

**For Hotfix:**
```
.devwork/hotfix/{task-id}/
└── status.md
```

**For Bugfix/Feature/Refactor:**
```
.devwork/feature/{task-id}/
└── status.md
```

**Only create `status.md`** — other files (research.md, spec.md, plan.md, tasks.md, adr/) are created by their respective commands when needed.

### Step 7: Create Task Record

Create a compact task record in `.devwork/tasks/`. This is the **clinical chart** — a durable summary that survives across sessions.

**Auto-numbering logic:**
- If user provided an ID (e.g., `AUTH-001`, `INTEGRATIONS-123`), use it as filename: `.devwork/tasks/AUTH-001.md`
- If no ID provided, auto-increment: find highest numbered `NNN.md` in `.devwork/tasks/`, add 1, zero-pad to 3 digits → `.devwork/tasks/001.md`, `002.md`, etc.

**Task Record Format** (max 30 lines):

```markdown
# {TASK-ID}: {Brief Description}
type: {hotfix|bugfix|feature|refactor} | size: pending | created: {YYYY-MM-DD} | updated: {YYYY-MM-DD}

## Progress
- [ ] research codebase
- [ ] define requirements (if scope unclear)
- [ ] create implementation plan
- [ ] implement solution
- [ ] test changes
- [ ] deliver

## Active
just started — workspace created

## Dependencies
none identified yet

## Workspace
.devwork/{type}/{task-id}/
```

**Rules:**
- Max 30 lines — if longer, it's documentation, not a chart
- No tooling info — tooling goes in Claude project memory
- Human-editable — user can add/reorder steps manually
- Updated by every wosy command that changes task state

### Step 8: Initialize status.md

Create initial status file in workspace:

```markdown
# Status: {task-id}

> {brief description}

## Task Info
- **Type**: {hotfix|bugfix|feature|refactor}
- **Created**: {YYYY-MM-DD}
- **Scope Clear**: {yes|no}
- **Work Mode**: {Deep Dive|Hybrid|Straight}
- **Goal**: {one-line outcome}
- **Touches**: {system area — from Step 4b}
- **Unknowns**: {list anything not yet verified in code}

## Current State
Just started. Workspace created.

## Tasks
[TODO] Research codebase
[TODO] {Define requirements - if scope unclear}
[TODO] Create implementation plan
[TODO] Implement solution
[TODO] Test changes
[TODO] Deliver
[TODO] Graduate artifacts (if significant)

## Next Action
{Based on work mode — e.g., "Run `/research` to explore the codebase."}

## Session Log
### {YYYY-MM-DD}
- Created workspace
- Task record created: .devwork/tasks/{task-id}.md
{- Phase 0 docs found: referencing .devwork/_scratch/phase0/}
```

### Step 9: Confirm & Guide

Output:

```
✓ Project structure verified: .devwork/
✓ Workspace created: .devwork/{type}/{task-id}/
✓ Task record created: .devwork/tasks/{task-id}.md
Work mode: {mode}

Task: {task-id} - {description}
Type: {type}

Next: {suggested command based on mode}
```

## Workflow Paths

### Mode 1: Deep Dive (greenfield)
```
/phase0 → /work setup → /intake → /research → /spec → /plan → /dispatch → /work ship
```

### Mode 2: Hybrid (existing codebase)
```
/intake → /research → /plan → /dispatch → /work ship
Skip /spec if requirements clear. Use /status between sessions.
```

### Mode 3: Straight (hotfix, clear scope)
```
/intake → implement → /work ship
Or skip /intake entirely if no tracking needed.
```

### Cross-cutting (any mode)
```
/work     — smart router, auto-detects phase
/context  — resume after context switch
/status   — update progress
```
