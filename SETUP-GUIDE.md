# Claude Code Workflow System - Setup Guide

## Overview

This system provides a structured workflow for working with Claude Code:
- **Organized artifacts** in `.devwork/` (gitignored)
- **Slash commands** for each workflow phase
- **Industry-standard formats** (MADR for ADRs, spec-kit style for specs)
- **Smart routing** based on task complexity

---

## Installation

### Quick Install

```bash
# Make the script executable
chmod +x install.sh

# Run the installer
./install.sh
```

The installer will:
1. Clean ALL existing custom commands (fresh start)
2. Install enhanced `~/.claude/CLAUDE.md`
3. Install workflow commands in `~/.claude/commands/`
4. Add `.devwork/` to global gitignore

### Manual Install (if preferred)

1. Copy `global/CLAUDE.md` to `~/.claude/CLAUDE.md`
2. Copy all files from `global/commands/` to `~/.claude/commands/`
3. Add `.devwork/` to `~/.gitignore_global`:
   ```bash
   echo ".devwork/" >> ~/.gitignore_global
   git config --global core.excludesfile ~/.gitignore_global
   ```

---

## Per-Project Setup

After installing globally, set up each project with **one command**:

### Run Constitution

Open Claude Code in your project and run:

```
/constitution
```

This single command:
- Creates `.devwork/` directory structure
- Creates `decisions/` and `specs/` with index files
- Scans project for tech stack, patterns, conventions
- Generates `.devwork/constitution.md` (AI coding guidelines)
- Creates/updates project `CLAUDE.md`
- Verifies `.devwork/` is in `.gitignore`

### Constitution Flags

```bash
/constitution              # Full setup (first time)
/constitution update       # Re-scan project, preserve manual notes
/constitution reset        # Fresh start (backs up existing)
/constitution repair       # Fix structure issues only
```

### After Setup

1. Review `.devwork/constitution.md` - verify detected patterns are correct
2. Add project-specific knowledge to "Manual Notes" section
3. Add fragile areas to "Do NOT Touch" section
4. Start working: `/intake {JIRA-ID} "description"`

---

## Workflow Usage

### Starting a New Task

```
/intake TASKS-1400 "Add year filter to inventory"
```

Claude will ask:
1. Task type? (Hotfix / Bugfix / Feature / Refactor)
2. Scope clear? (Yes / No)

Then creates workspace in `.devwork/feature/tasks-1400/` or `.devwork/hotfix/tasks-1400/`

### Workflow Paths

**Hotfix (fastest):**
```
/intake → /research (quick) → implement → /deliver
```

**Feature (clear scope):**
```
/intake → /research → /plan → implement → /status → /deliver
```

**Feature (unclear scope):**
```
/intake → /research → /spec → /plan → implement → /status → /deliver
```

### Command Reference

| Command | When to Use | Output |
|---------|-------------|--------|
| `/constitution` | First time + updates | Full setup or refresh |
| `/intake {ID} "desc"` | Starting task | Workspace + `status.md` |
| `/research` | Before coding | `research.md` |
| `/spec` | Unclear requirements | `spec.md` (working draft) |
| `/plan` | Before implementing | `plan.md` + `tasks.md` |
| `/status` | After progress | Updates `status.md` |
| `/status check` | View status only | Console output |
| `/deliver` | Task complete | Commit message + graduation prompt |
| `/graduate` | Preserve important work | Moves to `specs/` or `decisions/` |

### Constitution Flags

| Flag | Purpose |
|------|---------|
| (none) | Full setup - structure + scan + CLAUDE.md |
| `update` | Re-scan, preserve "Manual Notes" and "Do NOT Touch" |
| `reset` | Backup existing, start fresh |
| `repair` | Fix missing directories/files only |

---

## Folder Structure

### Global (`~/.claude/`)
```
~/.claude/
├── CLAUDE.md           # Your identity, communication rules, workflow awareness
└── commands/           # Slash commands
    ├── constitution.md # /constitution
    ├── intake.md       # /intake
    ├── research.md     # /research
    ├── spec.md         # /spec
    ├── plan.md         # /plan
    ├── status.md       # /status
    └── deliver.md      # /deliver
```

### Per Project
```
project/
├── CLAUDE.md                    # Project-specific rules (links to constitution)
└── .devwork/                    # All working artifacts (gitignored)
    │
    │── constitution.md          # Tech stack, conventions
    │
    │── decisions/               # GRADUATED ADRs (shareable)
    │   ├── README.md            # Decision index
    │   ├── 0001-use-nova.md
    │   └── 0002-caching.md
    │
    │── specs/                   # GRADUATED specs (shareable)
    │   ├── README.md            # Spec index
    │   └── nt-0001-user-auth.md
    │
    ├── feature/                 # ACTIVE feature work
    │   └── nt-0001/
    │       ├── README.md        # Scope, context
    │       ├── status.md        # Progress tracking
    │       ├── research.md      # Codebase findings
    │       ├── spec.md          # Working spec (draft)
    │       ├── plan.md          # Implementation approach
    │       ├── tasks.md         # Checklist
    │       └── adr/             # Working decisions
    │           └── 001-auth-choice.md
    │
    ├── hotfix/                  # ACTIVE hotfix work (lighter)
    │   └── nt-0002/
    │       └── status.md
    │
    ├── _archive/                # COMPLETED tickets
    │   └── nt-0001/
    │
    └── _scratch/                # Temporary notes, brainstorming
```

### Key Concept: Working vs Graduated

| Location | Purpose | Shareable? |
|----------|---------|------------|
| `feature/{id}/spec.md` | Working draft | No |
| `specs/{id}-{name}.md` | Final spec | ✅ Yes |
| `feature/{id}/adr/*.md` | Working decision | No |
| `decisions/NNNN-{name}.md` | Final ADR | ✅ Yes |

**Graduation workflow:**
1. Work in ticket folder (drafts)
2. When done, `/graduate` moves final versions to global directories
3. Graduated files follow industry formats and can be shared

---

## Status Tracking

### Status Tags
- `[TODO]` - Not started
- `[DONE]` - Completed
- `[BLOCKED]` - Waiting on something

### Example status.md
```markdown
# Status: TASKS-1400

> Add year filter to inventory

## Current State
Phase 2: Implemented filter class, working on integration.

## Tasks
[DONE] Research codebase
[DONE] Create implementation plan
[DONE] Create YearFilter class
[TODO] Register filter in Inventory resource
[TODO] Test changes

## Next Action
Add YearFilter to Inventory::filters() method in app/Nova/Resources/Inventory.php

## Session Log
### 2025-01-31
- Created workspace
- Completed research, found existing FactoryFeedFilter pattern
- Created plan with 2 phases
- Implemented YearFilter class
```

### Key Rule
Always write a specific "Next Action" so you know exactly where to pick up after context-switching.

---

## Graduation Workflow

### What is Graduation?

Working artifacts live in ticket folders during development. When finalized, important ones "graduate" to project-wide directories for permanent record.

```
WORKING (in-progress)              GRADUATED (final)
─────────────────────              ─────────────────
feature/nt-0001/spec.md      →     specs/nt-0001-user-auth.md
feature/nt-0001/adr/001.md   →     decisions/0001-auth-choice.md
```

### When to Graduate

| Artifact | Graduate? | Why |
|----------|-----------|-----|
| Major feature spec | ✅ Yes | Reference for future work |
| Architectural decision | ✅ Yes | Project knowledge |
| Minor bugfix spec | ❌ No | Not worth preserving |
| Research notes | ❌ No | Ticket-specific |
| Plans | ❌ Usually no | Outdated after implementation |

### How to Graduate

**Option 1: During /deliver**
```
/deliver

✓ Task complete!
This ticket has:
- 1 spec (not graduated)
- 1 ADR (not graduated)

Graduate artifacts? (y/n) → y
```

**Option 2: Manual**
```
/graduate           # Interactive menu
/graduate spec      # Graduate spec only
/graduate adr       # Graduate ADR(s) only
/graduate all       # Graduate everything
```

### Benefits

1. **Shareable format** - Graduated files follow industry standards
2. **Easy to find** - All specs in one place, all ADRs numbered
3. **Clean tickets** - Working folder can be archived/deleted
4. **Onboarding** - New team members can browse decisions/specs

---

## Tips

### Context Switching
When switching projects:
1. Run `/status` to save where you are
2. Make sure "Next Action" is specific
3. When returning: read `.devwork/{type}/{jira-id}/status.md`

### Decisions
When making significant decisions:
1. Document in ticket's `adr.md`
2. Add entry to `.devwork/decision-log.md`

### Quick Updates
```
/status "completed validation logic"    # Quick done
/status blocked "waiting for API keys"  # Mark blocked
/status check                           # View only
```

### Archiving Completed Work
After delivering, move completed tickets:
```bash
mv .devwork/feature/tasks-1400 .devwork/_archive/
```

---

## Troubleshooting

### Commands not working
1. Check `~/.claude/commands/` exists
2. Check command files have `.md` extension
3. Restart Claude Code

### .devwork/ not ignored
1. Check `~/.gitignore_global` contains `.devwork/`
2. Run: `git config --global core.excludesfile ~/.gitignore_global`
3. Or add `.devwork/` to project's `.gitignore`

### Constitution not detecting stack
The `/constitution` command looks for:
- `composer.json` (PHP)
- `package.json` (Node/JS)
- Directory structure (`app/Services/`, etc.)

If detection fails, manually edit `.devwork/constitution.md`

---

## Updating

To update the workflow system:

```bash
# Re-run installer (will overwrite commands)
./install.sh
```

Your project-specific `.devwork/` content is preserved.
