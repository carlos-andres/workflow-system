# /intake - Task Intake & Workspace Setup

Classify the task and create the working environment.

## Usage
```
/intake {JIRA-ID} "{brief description}"
```

## Example
```
/intake TASKS-1400 "Add year filter to inventory"
```

## Instructions

### Step 1: Ensure Project Structure

First, ensure the global `.devwork/` structure exists:

```bash
mkdir -p .devwork/{decisions,specs,feature,hotfix,_archive}
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

### Step 2: Classify the Task

Ask me ONE question:

> **What type of task is this?**
> 1. **Hotfix** - Urgent production fix (light docs)
> 2. **Bugfix** - Non-urgent bug fix (medium docs)  
> 3. **Feature** - New functionality (full docs)
> 4. **Refactor** - Code improvement (full docs)

### Step 3: Determine Scope (for Feature/Refactor)

If Feature or Refactor, ask:

> **Is the scope clear?**
> 1. **Yes** - I know exactly what to build (skip /spec)
> 2. **No** - Requirements need clarification (full workflow with /spec)

### Step 4: Create Ticket Workspace

Based on classification, create the workspace:

**For Hotfix:**
```
.devwork/hotfix/{jira-id}/
└── status.md
```

**For Bugfix/Feature/Refactor:**
```
.devwork/feature/{jira-id}/
├── README.md
├── status.md
├── research.md     # (filled by /research)
├── spec.md         # (filled by /spec - working draft)
├── plan.md         # (filled by /plan)
├── tasks.md        # (generated from plan)
└── adr/            # (decisions for this ticket)
    └── .gitkeep
```

**Note:** Working `spec.md` stays here during development. When finalized, graduate to `.devwork/specs/` for permanent record.

### Step 5: Initialize status.md

Create initial status file:

```markdown
# Status: {JIRA-ID}

> {brief description}

## Task Info
- **Type**: {hotfix|bugfix|feature|refactor}
- **Created**: {YYYY-MM-DD}
- **Scope Clear**: {yes|no}

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
Run `/research` to explore the codebase.

## Session Log
### {YYYY-MM-DD}
- Created workspace
```

### Step 6: Initialize README.md (for non-hotfix)

```markdown
# {JIRA-ID}: {Brief Description}

## Objective
{To be filled after /spec or /plan}

## Scope
### Included
- {To be defined}

### Excluded
- {To be defined}

## Context
- **Jira**: {JIRA-ID}
- **Type**: {type}
- **Created**: {date}

## Related Files
{To be filled by /research}

## Artifacts
- Working spec: `spec.md` → Graduates to `.devwork/specs/{jira-id}-{slug}.md`
- Decisions: `adr/*.md` → Graduate to `.devwork/decisions/NNNN-{slug}.md`
```

### Step 7: Confirm & Guide

Output:

```
✓ Project structure verified: .devwork/
  ├── constitution.md
  ├── decisions/          # Graduated ADRs
  ├── specs/              # Graduated specs
  └── ...

✓ Workspace created: .devwork/{type}/{jira-id}/

Task: {JIRA-ID} - {description}
Type: {type}
Path: {hotfix|feature} workflow

Next steps:
1. /research - Explore codebase for patterns and conventions
{2. /spec - Clarify requirements (if scope unclear)}
{3. /plan - Design implementation approach}
```

## Workflow Paths

### Hotfix Path (fastest)
```
/intake → /research (quick) → implement → /deliver
```

### Bugfix Path (medium)
```
/intake → /research → /plan (light) → implement → /deliver
```

### Feature Path - Clear Scope
```
/intake → /research → /plan → implement → /status → /deliver
```

### Feature Path - Unclear Scope
```
/intake → /research → /spec → /plan → implement → /status → /deliver
```
