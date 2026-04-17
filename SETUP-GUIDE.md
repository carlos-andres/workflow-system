# Claude Code Workflow System — Setup Guide

## Overview

v3.0 ships skills, agents, and rules — replacing the old namespaced commands architecture.

- **Smart router** (`/work`) auto-detects phase and suggests next command
- **Task records** in `.devwork/tasks/` persist across sessions
- **Project memory** saves tooling patterns for automatic reuse
- **Conductor rule** — always-on discipline, not a slash command
- **Agent review gate** — code-reviewer + security-auditor agents run on `/work ship`
- **Tool skills** — debugging, tdd, verify available in every project
- **Hooks** — pre-tool-use validation blocks dangerous bash commands

---

## Installation

### Quick Install

```bash
chmod +x install.sh
./install.sh
```

Flags:
- `--preserve` — skip overwriting `~/.claude/CLAUDE.md` (keep your customizations)
- `--yes` / `-y` — skip all interactive prompts

### What the Installer Does (11 steps)

1. **Preflight** — verifies source dirs exist
2. **Backup** — backs up existing wosy-* skills, tool skills, agents, rules, CLAUDE.md as `.bak`
3. **Create dirs** — `~/.claude/skills/`, `~/.claude/agents/`, `~/.claude/rules/`
4. **Install 14 skills** — 11 wosy + 3 tool skills into `~/.claude/skills/*/SKILL.md`
5. **Install 2 agents** — code-reviewer, security-auditor into `~/.claude/agents/`
6. **Install 1 rule** — wosy-conductor into `~/.claude/rules/`
7. **Install hooks** — validate-bash.sh into `~/.claude/hooks/` (chmod +x)
8. **Install CLAUDE.md** — `global/CLAUDE.md` → `~/.claude/CLAUDE.md` (skipped with `--preserve`)
9. **Configure global gitignore** — adds `.devwork/` to `~/.gitignore_global`
10. **Legacy cleanup** — offers to remove `~/.claude/commands/wosy/` if found
11. **Verify installation** — confirms all files landed correctly

### What Gets Installed

```
~/.claude/
├── CLAUDE.md                          # Global config (~40 lines, stack-agnostic)
├── skills/
│   ├── wosy-work/SKILL.md             # Smart router + setup + ship
│   ├── wosy-intake/SKILL.md           # Task classification + workspace creation
│   ├── wosy-research/SKILL.md         # Codebase exploration + memory detection
│   ├── wosy-spec/SKILL.md             # Requirements interview → spec.md
│   ├── wosy-plan/SKILL.md             # Implementation plan + T-shirt sizing
│   ├── wosy-dispatch/SKILL.md         # Task orchestration (XS→XL)
│   ├── wosy-status/SKILL.md           # Progress tracking + task records
│   ├── wosy-context/SKILL.md          # Quick resume after context switch
│   ├── wosy-phase0/SKILL.md           # Greenfield discovery
│   ├── wosy-pr-review/SKILL.md        # Code review from diff (3-pass)
│   ├── wosy-models/SKILL.md           # Model assignment guide
│   ├── debugging/SKILL.md             # Systematic root-cause debugging
│   ├── tdd/SKILL.md                   # Red-green-refactor + framework detection
│   └── verify/SKILL.md                # Evidence-based verification
├── agents/
│   ├── code-reviewer.md               # Bugs/logic/edge cases (dispatched by /work ship)
│   └── security-auditor.md            # OWASP Top 10 audit (dispatched by /work ship)
├── rules/
│   └── wosy-conductor.md              # Conductor discipline (always-on)
└── hooks/
    └── validate-bash.sh               # Blocks dangerous commands (pre-tool-use)
```

### Upgrading from v2.x

Run `./install.sh` — it backs up existing commands, installs skills/agents/rules, then offers to remove `~/.claude/commands/wosy/`. Project `.devwork/` content is preserved. Old `/wosy:command` syntax no longer works — use `/command` directly.

---

## Per-Project Setup

Open Claude Code in your project and run:

```
/work setup
```

This creates `.devwork/` structure, scans the tech stack, generates `constitution.md`, creates/updates project `CLAUDE.md`, detects tooling patterns, and verifies `.devwork/` is gitignored.

Setup flags:
- `/work setup` — full setup (first time)
- `/work setup update` — re-scan, preserve manual notes
- `/work setup reset` — fresh start (backs up existing)
- `/work setup repair` — fix missing directories/files only

After setup:
1. Review `.devwork/constitution.md` — verify detected patterns
2. Add project-specific knowledge to "Manual Notes" section
3. Add fragile areas to "Do NOT Touch" section
4. Start: `/intake {TICKET} "description"` or just `/work`

---

## Workflow Usage

### Starting a Task

```
/intake AUTH-001 "Add user authentication"
```

Claude classifies type (Hotfix / Bugfix / Feature / Refactor), confirms scope, then creates:
- Workspace → `.devwork/feature/AUTH-001/`
- Task record → `.devwork/tasks/AUTH-001.md`

### Smart Router

After `/intake`, run `/work` — it reads project state and recommends next step:

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
Skip /spec if requirements are clear. Use /status between sessions.
```

**Straight (hotfix, clear scope):**
```
/intake → implement → /work ship
Or skip /intake entirely if no tracking needed.
```

### Command Reference

**Workflow skills** (slash commands):
- `/work` — auto-detect phase, recommend next command
- `/work setup` — project setup: constitution + CLAUDE.md
- `/work ship` — verify → agent review → deliver → graduate → archive
- `/intake {ID} "desc"` — classify task, create workspace + task record
- `/research` — codebase exploration + tooling detection
- `/spec` — requirements interview → spec.md
- `/plan` — implementation plan + T-shirt sizing
- `/dispatch` — sub-agent orchestration (XS→XL)
- `/status` — update task record + status.md
- `/status check` — view status only (no write)
- `/context` — quick resume after context switch
- `/pr-review` — code review from diff, 3-pass analysis
- `/models` — model assignment reference

**Tool skills** (available in every project):
- `/debugging` — systematic root-cause analysis
- `/tdd` — red-green-refactor cycle with framework auto-detection
- `/verify` — evidence-based verification before claiming done

**Rules** (always-on, not slash commands):
- `wosy-conductor.md` — 5 rules: never implement in main window, 5-line context budget, handoff contract, done-log-only returns, model assignment at dispatch time. Includes script-and-defer pattern.

### /work ship — Agent Review Gate (new in v3.0)

`/work ship` now includes an agent review gate before delivery:

**Gate 1: Agent Review** — dispatches code-reviewer + security-auditor agents (both Opus). Review must pass before any delivery proceeds.

Full sequence: verify → agent review → deliver → graduate → archive.

---

## Task Records

Compact, persistent progress files in `.devwork/tasks/`. Think "medical chart" — just enough to know status at a glance.

Format:
```markdown
# AUTH-001: Add user authentication
type: feature | size: M | created: {YYYY-MM-DD} | updated: {YYYY-MM-DD}

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

Rules:
- **Max 30 lines** — longer means it's docs, not a chart
- **Auto-created** by `/intake`
- **Auto-updated** by every wosy command
- **Human-editable** — add/reorder steps manually
- **Read-first** — `/work`, `/context`, `/dispatch` read these before acting
- **No tooling** — tooling goes in project memory

Auto-numbering: provide `AUTH-001` → `AUTH-001.md`; no ID → auto-increment `001.md`, `002.md`.

---

## Project Memory

Patterns detected during setup/research/implementation, saved to `.devwork/`:

- **DB connections** → `tooling_database.md`
- **SSH connections** → `tooling_ssh.md`
- **Environment** → `tooling_environment.md`
- **CLI patterns** → `tooling_cli.md`
- **API endpoints** → `tooling_api.md`
- **Git conventions** → `tooling_git.md`

When detected: during `/work setup` (auto-scan), during `/research` (code exploration), during implementation (agents surface working commands).

Memory file format:
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
```

---

## Folder Structure

### Global (`~/.claude/`)

See "What Gets Installed" above — skills/agents/rules replace the old `commands/wosy/` layout.

### Per Project (unchanged from v2.x)

```
project/
├── CLAUDE.md
└── .devwork/
    ├── constitution.md
    ├── tasks/
    ├── decisions/
    ├── specs/
    ├── feature/
    ├── hotfix/
    ├── _archive/
    └── _scratch/
```

---

## Templates

Files in `templates/`:
- `project-CLAUDE.md` — copy to project root as `CLAUDE.md` (~30 lines)
- `adr-template.md` — architecture decision records (MADR format)
- `decision-log.md` — decision index for `.devwork/decisions/`
- `settings.json` — NEW: starter Claude Code settings (permissions, terse output)
- `.claudeignore` — NEW: starter ignore patterns (node_modules, vendor, dist, lock files)
- `.mcp.json` — NEW: starter MCP integration config (GitHub server example)

---

## Tips

### Context Switching
1. Run `/status` to save where you are — make "Next Action" specific
2. When returning: run `/work` or `/context` — reads task records + memory automatically

### Quick Status Updates
- `/status "completed validation logic"` — quick done
- `/status blocked "waiting for API keys"` — mark blocked
- `/status check` — view only

### Dispatch Sizing
- **XS** → single inline agent
- **S** → single agent with tracking
- **M** → 2-3 parallel agents
- **L** → parallel + verification
- **XL** → split into sub-tasks first

---

## Troubleshooting

### Skills not working
1. Check `~/.claude/skills/` exists with `*/SKILL.md` files
2. Restart Claude Code
3. Skills invoke as `/command` — no namespace (old `/wosy:command` no longer works)

### Still seeing old `/wosy:*` commands
Re-run `./install.sh` — the legacy cleanup step offers to remove `~/.claude/commands/wosy/`.

### `.devwork/` not ignored
1. Check `~/.gitignore_global` contains `.devwork/`
2. Run: `git config --global core.excludesfile ~/.gitignore_global`
3. Or add `.devwork/` to the project's `.gitignore`

### Task records not found
Run `/intake` to create one, or create manually in `.devwork/tasks/`.

---

## Release Notes

See [CHANGELOG.md](CHANGELOG.md) for full version history and upgrade notes.
