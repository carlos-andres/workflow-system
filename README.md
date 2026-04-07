<p align="center">
  <img src="https://img.shields.io/badge/Claude_Code-Workflow_System-blueviolet?style=for-the-badge&logo=anthropic" alt="Claude Code Workflow System"/>
</p>

<h1 align="center">Claude Code Workflow System</h1>

<p align="center">
  <strong>A structured development workflow for AI-assisted coding with Claude Code</strong>
</p>

<p align="center">
  <a href="#-quick-start">Quick Start</a> &bull;
  <a href="#-features">Features</a> &bull;
  <a href="#-commands">Commands</a> &bull;
  <a href="#-philosophy">Philosophy</a> &bull;
  <a href="#-installation">Installation</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/version-2.0.0-blue?style=flat-square" alt="Version"/>
  <img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" alt="License"/>
  <img src="https://img.shields.io/badge/PRs-welcome-brightgreen?style=flat-square" alt="PRs Welcome"/>
</p>

---

## The Problem

Working with AI coding assistants can be chaotic:

- **Scope creep** — Features grow beyond original intent
- **Context loss** — Forgetting where you left off after switching projects
- **Missing edge cases** — Bugs slip through incomplete specs
- **Tooling re-discovery** — Re-discovering DB connections, SSH commands, commit patterns every session
- **Cognitive overhead** — Too many commands to remember

## The Solution

A **structured workflow system** with a smart router, persistent task records, and project memory:

```
/work → /intake → /research → /plan → /dispatch → /work ship
```

One smart router to guide you. Ten commands to master, two reference docs to guide agents. Zero chaos.

---

## Quick Start

```bash
# 1. Install the workflow system
./install.sh

# 2. Open any project in Claude Code, then run:
/work setup

# 3. Start your first task:
/intake AUTH-001 "Add user authentication"

# 4. Let the smart router guide you:
/work
```

**That's it.** The smart router reads your project state, detects what phase you're in, and suggests the right command.

---

## What's New in v2.0

### Conductor Mode
The main window is now a **conductor** — it holds context and orchestrates, never implements. Sub-agents do all the work.

### Task Records
Every task gets a compact, persistent record in `.devwork/tasks/` (max 30 lines). These survive across sessions — no more reconstructing context from scratch.

### Memory Wiring
Tooling patterns (DB connections, SSH commands, CLI preferences) are proactively detected and saved to Claude's project memory. Next session, they're loaded automatically.

### Smart Router
`/work` reads your project state and auto-detects what to do next. No more memorizing 16 commands.

### Always-On Dispatch
`/dispatch` scales from XS (single agent) to XL (split + parallel). No more size refusals.

### Merged Commands (16 → 10 commands + 2 reference docs)
- `constitution` + `project-init` + `rebuild` → `/work setup`
- `verify` + `deliver` + `graduate` + `archive` → `/work ship`
- Added `conductor.md` + `models.md` as reference docs (loaded as `/wosy:conductor`, `/wosy:models`)

---

## Features

### Smart Router (`/work`)

```bash
/work    # Auto-detects: no setup? → /work setup
         #               no tasks? → /intake
         #               has plan? → /dispatch
         #               all done? → /work ship
```

### Task Records (Persistent Clinical Charts)

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

## Workspace
.devwork/feature/AUTH-001/
```

Max 30 lines. Created by `/intake`. Updated by every command. Read by `/work`, `/context`, `/dispatch`.

### Three-Layer Memory

| Layer | Where | What | Lifespan |
|-------|-------|------|----------|
| Project Memory | `~/.claude/projects/<project>/memory/` | Tooling, connections, patterns | Permanent |
| Task Records | `.devwork/tasks/*.md` | Per-task progress | Until archived |
| Tasks API | In-session | Real-time orchestration | Session only |

### Proactive Memory Detection

During `/research` and `/work setup`, the system detects tooling patterns and asks to save them:

```
I found a tooling pattern worth remembering:
- Command: mysql --no-defaults --defaults-group-suffix=-local
- Uses ~/.my.cnf [client-local] group (no inline credentials)
- Needs sandbox override for socket access

Save to project memory? (y/n)
```

Next session, it's loaded automatically — no re-discovery.

### Conductor Pattern

```
Main Window (Conductor)          Sub-Agents (Workers)
├── Holds: task record, plan     ├── Read code
├── Holds: constitution, memory  ├── Write code
├── Dispatches agents            ├── Run tests
├── Updates task records         └── Report results
└── Reports to user
```

---

## Commands

### Primary

| Command | Purpose |
|---------|---------|
| `/work` | **Smart router** — auto-detects phase, suggests next command |
| `/work setup` | Project setup (constitution + project-init). Flags: `update`, `reset`, `repair` |
| `/work ship` | Delivery pipeline: verify → deliver → graduate → archive (with gates) |

### Workflow

| Command | Phase | What it does |
|---------|-------|--------------|
| `/intake` | Start | Classify task, create workspace + task record |
| `/research` | Discover | Explore codebase, detect tooling, save to memory |
| `/spec` | Define | Requirements interview |
| `/plan` | Design | Implementation approach + T-shirt sizing |
| `/dispatch` | Execute | Always-on orchestration (XS→XL) |
| `/status` | Track | Update task records + status files |
| `/context` | Resume | Read memory + task records, show state |
| `/phase0` | Discovery | Greenfield project discovery (rare) |
| `/pr-review` | Review | Code review from commit or branch diff |

### Work Modes

```
Mode 1: Deep Dive (greenfield, complex discovery)
  /phase0 → /work setup → /intake → /research → /spec → /plan → /dispatch → /work ship

Mode 2: Hybrid (existing codebase, feature work)
  /intake → /research → /plan → /dispatch → /work ship
  Skip /spec if requirements clear. Use /status between sessions.

Mode 3: Straight (clear scope, quick tasks, hotfixes)
  /intake → implement → /work ship
  Or skip /intake entirely if no tracking needed.

Cross-cutting:
  /work     — smart router, auto-detects phase
  /context  — resume after context switch (reads memory + task records)
  /status   — update progress
```

---

## Namespaced Commands (wosy:)

All workflow commands are available with the `wosy:` namespace prefix:

```
/wosy:work       # Same as /work
/wosy:intake     # Same as /intake
/wosy:dispatch   # Same as /dispatch
# ... etc for all 12 files
```

---

## Philosophy

### Conductor, Not Worker
The main window orchestrates — it dispatches agents, tracks progress, and updates records. It never writes implementation code directly.

### Extract, Don't Assume
The constitution **reads your actual code** to understand patterns. No generic templates — real examples from your codebase.

### Remember, Don't Re-discover
Tooling patterns are saved to project memory. DB connections, SSH commands, API endpoints — discovered once, used forever.

### Context-Switching Solved
Task records + project memory mean you can return to any project and pick up exactly where you left off.

### Working vs Permanent
Messy drafts stay in ticket folders. Important decisions graduate to shareable directories. Best of both worlds.

---

## Installation

### Automatic (Recommended)

```bash
git clone https://github.com/carlos-andres/workflow-system.git
cd workflow-system
chmod +x install.sh
./install.sh
```

### What Gets Installed

```
~/.claude/
├── CLAUDE.md              # Global configuration (v2.0)
└── commands/
    └── wosy/              # 10 commands + 2 reference docs
        ├── work.md        # Smart router + setup + ship
        ├── phase0.md      # Greenfield discovery
        ├── intake.md      # Task classification + records
        ├── research.md    # Exploration + memory detection
        ├── spec.md        # Requirements interview
        ├── plan.md        # Planning + sizing
        ├── dispatch.md    # Always-on orchestration
        ├── status.md      # Progress tracking
        ├── context.md     # Context resume
        ├── pr-review.md   # Code review
        ├── conductor.md   # Conductor discipline (reference)
        └── models.md      # Model assignment guide (reference)
```

### Manual Installation

1. Copy `global/CLAUDE.md` to `~/.claude/CLAUDE.md`
2. Copy `global/commands/wosy/*.md` to `~/.claude/commands/wosy/`
3. Add `.devwork/` to your global gitignore:
   ```bash
   echo ".devwork/" >> ~/.gitignore_global
   git config --global core.excludesfile ~/.gitignore_global
   ```

---

## Project Structure

After running `/work setup` in a project:

```
your-project/
├── CLAUDE.md                    # Project config (references constitution)
└── .devwork/                    # Gitignored
    ├── constitution.md          # AI coding guidelines
    ├── tasks/                   # Task records (clinical charts)
    │   ├── 001.md
    │   ├── AUTH-001.md
    │   └── UPGRADE-001.md
    ├── decisions/               # Graduated ADRs
    │   ├── README.md
    │   └── 0001-auth-strategy.md
    ├── specs/                   # Graduated specs
    │   ├── README.md
    │   └── auth-001-auth.md
    ├── feature/                 # Active features
    │   └── AUTH-001/
    │       ├── status.md
    │       ├── research.md
    │       ├── spec.md
    │       ├── plan.md
    │       └── tasks.md
    ├── hotfix/                  # Active hotfixes
    ├── _archive/                # Completed work
    └── _scratch/                # Temporary notes (Phase 0)
```

---

## Task Record Example

```markdown
# UPGRADE-001: Joomla → Astro Migration
type: feature | size: L | created: 2026-01-15 | updated: 2026-03-10

## Progress
- [x] research current live site
- [x] inventory (images, content, sitemap)
- [x] Astro local setup
- [x] Astro scaffolding
- [ ] port pages/content (12/28 pages done)
- [ ] QA / end-to-end review

## Active
porting product pages — blocked on image optimization pipeline

## Dependencies
- scaffolding must complete before page porting
- image pipeline must resolve before QA

## Workspace
.devwork/feature/UPGRADE-001/
```

**Relationship**: The task record is the **chart** (compact status). The workspace is the **medical records** (full artifacts). The chart references the workspace but doesn't duplicate it.

---

## Memory Example

```markdown
---
name: database-connection
description: MySQL connection pattern — uses my.cnf groups, no inline credentials
type: reference
---

## MySQL Local
- Command: `mysql --no-defaults --defaults-group-suffix=-local`
- Why `--no-defaults`: multiple MySQL connections, each has its own group
- NEVER use: `mysql -uroot -p` or inline credentials
- Sandbox: requires `dangerouslyDisableSandbox` for socket access
- Verify: `mysql --no-defaults --defaults-group-suffix=-local -e "SELECT 1"`
```

---

## Contributing

Contributions are welcome! This system was born from real pain points in AI-assisted development.

### Ideas for Contribution

- **Language-specific constitutions** — Ruby, Python, Go templates
- **IDE integrations** — VS Code extension, JetBrains plugin
- **Metrics** — Track time saved, decisions made

### How to Contribute

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## License

MIT License — use it, modify it, share it.

---

## Release Notes

See [CHANGELOG.md](CHANGELOG.md) for version history and upgrade notes from v1.x.

---

## References & Industry Standards

This workflow system is built on proven industry standards:

- **[Anthropic Claude Code](https://www.anthropic.com/engineering/claude-code-best-practices)** — CLAUDE.md hierarchy, slash commands
- **[GitHub Spec-Kit](https://github.com/github/spec-kit)** — Spec-driven development, constitution concept
- **[MADR](https://adr.github.io/madr/)** — ADR format
- **[Conventional Commits](https://conventionalcommits.org)** — Commit message standards

---

<p align="center">
  <strong>Stop the chaos. Start the workflow.</strong>
</p>
