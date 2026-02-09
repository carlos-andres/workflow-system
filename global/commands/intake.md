# /intake - Task Intake & Workspace Setup

Classify the task and create the working environment.

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
mkdir -p .devwork/{decisions,specs,feature,hotfix,_archive,_scratch}
```

**Global Structure** (created once per project):
```
.devwork/
├── constitution.md      # Project-wide (run /constitution)
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

### Step 5: Suggest Work Mode

Based on classification and context:

| Condition | Suggested Mode |
|-----------|---------------|
| Phase 0 docs exist + greenfield | **Mode 1: Deep Dive** — `/phase0` → `/constitution` → `/intake` → `/research` → `/spec` → `/plan` → implement → `/verify` → `/deliver` → `/graduate` |
| Existing codebase + feature/refactor | **Mode 2: Hybrid** — `/intake` → `/research` → `/plan` → implement → `/verify` → `/deliver`. Skip `/spec` if requirements clear. |
| Hotfix / bugfix / clear scope | **Mode 3: Straight** — `/intake` → implement → `/deliver`. Or skip `/intake` entirely if no tracking needed. |

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

### Step 7: Initialize status.md

Create initial status file:

```markdown
# Status: {task-id}

> {brief description}

## Task Info
- **Type**: {hotfix|bugfix|feature|refactor}
- **Created**: {YYYY-MM-DD}
- **Scope Clear**: {yes|no}
- **Work Mode**: {Deep Dive|Hybrid|Straight}

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
{- Phase 0 docs found: referencing .devwork/_scratch/phase0/}
```

### Step 8: Confirm & Guide

Output:

```
✓ Project structure verified: .devwork/
✓ Workspace created: .devwork/{type}/{task-id}/
Work mode: {mode}

Task: {task-id} - {description}
Type: {type}

Next: {suggested command based on mode}
```

## Workflow Paths

### Mode 1: Deep Dive (greenfield)
```
/phase0 → /constitution → /intake → /research → /spec → /plan → implement → /verify → /deliver → /graduate
```

### Mode 2: Hybrid (existing codebase)
```
/intake → /research → /plan → implement → /verify → /deliver
Skip /spec if requirements clear. Use /status between sessions.
```

### Mode 3: Straight (hotfix, clear scope)
```
/intake → implement → /deliver
Or skip /intake entirely if no tracking needed.
```

### Cross-cutting (any mode)
```
/context — resume after context switch
/status  — update progress
/verify  — checkpoint before /deliver
```
