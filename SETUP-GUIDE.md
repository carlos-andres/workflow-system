# Claude Code Workflow System - Setup Guide

## Overview

This system provides a structured workflow for working with Claude Code:
- **Smart router** (`/work`) auto-detects phase and suggests next command
- **Task records** in `.devwork/tasks/` persist across sessions
- **Project memory** saves tooling patterns for automatic reuse
- **Conductor pattern** — main window orchestrates, sub-agents implement
- **Industry-standard formats** (MADR for ADRs, spec-kit style for specs)

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
2. Install enhanced `~/.claude/CLAUDE.md` (v2.0)
3. Install 10 workflow commands in `~/.claude/commands/wosy/`
4. Add `.devwork/` to global gitignore

Commands are available as `/wosy:command` (namespaced).

### Manual Install (if preferred)

1. Copy `global/CLAUDE.md` to `~/.claude/CLAUDE.md`
2. Copy all files from `global/commands/wosy/` to `~/.claude/commands/wosy/`
3. Add `.devwork/` to `~/.gitignore_global`:
   ```bash
   echo ".devwork/" >> ~/.gitignore_global
   git config --global core.excludesfile ~/.gitignore_global
   ```

### Upgrading from v1.x

Run `./install.sh` — it removes old commands and installs the v2.0 set. Your project `.devwork/` content is preserved. The merged commands (constitution, project-init, rebuild, verify, deliver, graduate, archive) are replaced by `/work setup` and `/work ship`.

---

## Per-Project Setup

After installing globally, set up each project with **one command**:

### Run Setup

Open Claude Code in your project and run:

```
/work setup
```

This single command:
- Creates `.devwork/` directory structure (including `tasks/`)
- Scans project for tech stack, patterns, conventions
- Generates `.devwork/constitution.md` (AI coding guidelines)
- Creates/updates project `CLAUDE.md`
- Detects tooling patterns and offers to save to project memory
- Verifies `.devwork/` is in `.gitignore`

### Setup Flags

```bash
/work setup              # Full setup (first time)
/work setup update       # Re-scan project, preserve manual notes
/work setup reset        # Fresh start (backs up existing)
/work setup repair       # Fix missing directories/files only
```

### After Setup

1. Review `.devwork/constitution.md` — verify detected patterns are correct
2. Add project-specific knowledge to "Manual Notes" section
3. Add fragile areas to "Do NOT Touch" section
4. Start working: `/intake {TICKET} "description"` or just `/work`

---

## Workflow Usage

### Starting a New Task

```
/intake AUTH-001 "Add user authentication"
```

Claude will ask:
1. Task type? (Hotfix / Bugfix / Feature / Refactor)
2. Scope clear? (Yes / No)

Then creates:
- Workspace in `.devwork/feature/AUTH-001/` or `.devwork/hotfix/AUTH-001/`
- Task record in `.devwork/tasks/AUTH-001.md`

### Smart Router

After `/intake`, just run `/work` — it reads your project state and suggests the next command:

```
/work

→ Active: AUTH-001 — Add user authentication
  Progress: 1/6 steps
  Next: Run /research to explore the codebase
```

### Workflow Paths

**Deep Dive (greenfield):**
```
/phase0 → /work setup → /intake → /research → /spec → /plan → /dispatch → /work ship
```

**Hybrid (existing codebase — most common):**
```
/intake → /research → /plan → /dispatch → /work ship
Skip /spec if requirements clear. Use /status between sessions.
```

**Straight (hotfix, clear scope):**
```
/intake → implement → /work ship
Or skip /intake entirely if no tracking needed.
```

### Command Reference

| Command | When to Use | Output |
|---------|-------------|--------|
| `/work` | Anytime — auto-detects phase | Recommendation + execute |
| `/work setup` | First time + updates | Constitution + CLAUDE.md |
| `/work ship` | Task complete | Verify → deliver → graduate → archive |
| `/intake {ID} "desc"` | Starting task | Workspace + task record |
| `/research` | Before coding | `research.md` + tooling detection |
| `/spec` | Unclear requirements | `spec.md` (working draft) |
| `/plan` | Before implementing | `plan.md` + `tasks.md` + sizing |
| `/dispatch` | Execute plan | Sub-agent orchestration (XS→XL) |
| `/status` | After progress | Updates task record + `status.md` |
| `/status check` | View status only | Console output |
| `/context` | After context switch | Memory + task record summary |
| `/pr-review` | After commit/branch | `.devwork/reviews/{ticket}-code-review.md` |

---

## Task Records

### What Are They?

Compact, persistent progress files in `.devwork/tasks/`. Think "medical chart" — just enough to know the patient's status at a glance.

### Format

```markdown
# AUTH-001: Add user authentication
type: feature | size: M | created: 2026-01-15 | updated: 2026-03-10

## Progress
- [x] research codebase
- [x] create implementation plan
- [ ] Phase 1: database + models
- [ ] Phase 2: auth service
- [ ] deliver

## Active
implementing auth middleware

## Dependencies
- Phase 2 depends on Phase 1

## Workspace
.devwork/feature/AUTH-001/
```

### Rules

- **Max 30 lines** — if longer, it's documentation, not a chart
- **Auto-created** by `/intake`
- **Auto-updated** by every wosy command
- **Human-editable** — add/reorder steps manually
- **Read-first** — `/work`, `/context`, `/dispatch` read these before acting
- **No tooling** — tooling goes in project memory

### Auto-Numbering

- Provide an ID: `AUTH-001` → `.devwork/tasks/AUTH-001.md`
- No ID: auto-increment → `.devwork/tasks/001.md`, `002.md`, `003.md`

---

## Project Memory

### What Gets Saved

| Pattern | Example | Memory File |
|---------|---------|-------------|
| DB connections | `mysql --defaults-group-suffix=-local` | `tooling_database.md` |
| SSH connections | `ssh tower` | `tooling_ssh.md` |
| Environment | .test domains, PHP versions | `tooling_environment.md` |
| CLI patterns | Custom scripts, flags | `tooling_cli.md` |
| API endpoints | Internal APIs, auth | `tooling_api.md` |
| Git conventions | Branch naming, prefixes | `tooling_git.md` |

### When It's Detected

1. During `/work setup` — auto-detect from config files
2. During `/research` — when exploring code reveals patterns
3. During implementation — when agents discover working commands

### Memory File Format

```markdown
---
name: database-connection
description: MySQL connection pattern — uses my.cnf groups
type: reference
---

## MySQL Local
- Command: `mysql --no-defaults --defaults-group-suffix=-local`
- Why this way: multiple connections configured, defaults picks wrong one
- NEVER use: `mysql -uroot -p` or inline credentials
- Sandbox: requires dangerouslyDisableSandbox for socket access
- Verify: `mysql --no-defaults --defaults-group-suffix=-local -e "SELECT 1"`
```

---

## Folder Structure

### Global (`~/.claude/`)
```
~/.claude/
├── CLAUDE.md           # Global configuration (v2.0)
└── commands/
    └── wosy/           # 10 workflow commands
        ├── work.md
        ├── phase0.md
        ├── intake.md
        ├── research.md
        ├── spec.md
        ├── plan.md
        ├── dispatch.md
        ├── status.md
        ├── context.md
        └── pr-review.md
```

### Per Project
```
project/
├── CLAUDE.md                    # Project-specific rules
└── .devwork/                    # All working artifacts (gitignored)
    ├── constitution.md          # Tech stack, conventions
    ├── tasks/                   # Task records (persistent)
    │   ├── 001.md
    │   └── AUTH-001.md
    ├── decisions/               # Graduated ADRs
    ├── specs/                   # Graduated specs
    ├── feature/                 # Active feature work
    │   └── AUTH-001/
    │       ├── status.md
    │       ├── research.md
    │       ├── spec.md
    │       ├── plan.md
    │       └── tasks.md
    ├── hotfix/                  # Active hotfix work
    ├── _archive/                # Completed tickets
    └── _scratch/                # Phase 0 temporary notes
```

---

## Tips

### Context Switching
When switching projects:
1. Run `/status` to save where you are
2. Make sure "Next Action" is specific
3. When returning: run `/work` or `/context` — reads task records + memory automatically

### Quick Updates
```
/status "completed validation logic"    # Quick done
/status blocked "waiting for API keys"  # Mark blocked
/status check                           # View only
```

### Dispatch Sizing
| Size | Behavior |
|------|----------|
| XS | Single inline agent |
| S | Single agent with tracking |
| M | 2-3 parallel agents |
| L | Parallel + verification |
| XL | Split into sub-tasks first |

---

## Troubleshooting

### Commands not working
1. Check `~/.claude/commands/wosy/` exists
2. Check command files have `.md` extension
3. Restart Claude Code

### Old commands still showing
The v2.0 installer removes old flat aliases. If you see old commands (constitution, verify, deliver, etc.), re-run `./install.sh`.

### .devwork/ not ignored
1. Check `~/.gitignore_global` contains `.devwork/`
2. Run: `git config --global core.excludesfile ~/.gitignore_global`
3. Or add `.devwork/` to project's `.gitignore`

### Task records not found
Run `/intake` to create a task record, or create one manually in `.devwork/tasks/`.

---

## Updating

To update the workflow system:

```bash
# Re-run installer (will overwrite commands)
./install.sh
```

Your project-specific `.devwork/` content is preserved.
