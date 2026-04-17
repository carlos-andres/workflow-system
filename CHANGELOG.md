# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.0.0] - 2026-04-16

### Breaking

- Commands moved from `global/commands/wosy/*.md` to `~/.claude/skills/wosy-*/SKILL.md`
- `conductor.md` is now a rule in `~/.claude/rules/wosy-conductor.md` (always loaded, not a slash command)

### Added

- `code-reviewer` and `security-auditor` agents in `~/.claude/agents/`
- Mandatory verify gate with agent review in `/work ship`
- Script-and-defer pattern in dispatch (long-running commands written to `.sh`, never run inline)
- `debugging`, `tdd`, `verify` skills tracked in repo under `skills/`
- `--preserve` flag in `install.sh` to keep existing `CLAUDE.md`
- `templates/.claudeignore` — starter ignore patterns for Claude Code
- `templates/settings.json` — starter Claude Code settings with sensible defaults

### Changed

- `CLAUDE.md` template reduced from 291 to ~40 lines (agnostic, no stack-specific content)
- All skills optimized — ~75% line reduction (~3,100 to ~1,030 lines total)
- `install.sh` rewritten for `skills/agents/rules` structure (replaces `commands/` installer)
- `templates/project-CLAUDE.md` trimmed to ~30 lines

### Removed

- `superpowers:*` references from all files
- Standalone command files in `~/.claude/commands/wosy/` (no longer installed)

### Deprecated

- `global/commands/wosy/` directory (legacy, kept in repo for reference only)

---

## [2.0.1] - 2026-04-07

### Added

- **`conductor.md`** — Reference guide for main-window orchestration discipline (not a slash command; loaded as `/wosy:conductor`)
- **`models.md`** — Reference guide for model assignment strategy (not a slash command; loaded as `/wosy:models`)

### Changed

- `install.sh` updated: 10 → 12 files installed in `wosy/` namespace (includes conductor.md and models.md)
- `models.md` model names changed to generic aliases (`opus`, `sonnet`) — version-agnostic, resolved by Claude Code at runtime
- `plan.md` XL sizing: removed external skill escalation, replaced with native split+dispatch strategy
- `work.md` removed v1.x legacy command references ("same as old /verify", etc.)
- `global/CLAUDE.md` made fully agnostic: removed plugin-specific sections, added placeholder Project Roots

---

## [2.0.0] - 2026-03-15

### Added

- **`/work`** — Smart router + conductor entrypoint
  - Auto-detects project state and suggests next command
  - Reads task records and project memory before acting
  - Enforces conductor pattern: main window orchestrates, agents implement

- **`/work setup`** — Unified project setup (merges constitution + project-init + rebuild)
  - Single command with flags: `update`, `reset`, `repair`
  - Phase 6: proactive memory detection for tooling patterns
  - Replaces 3 standalone commands with one

- **`/work ship`** — Delivery pipeline with gates (merges verify + deliver + graduate + archive)
  - Sequential: verify → deliver → graduate → archive
  - User can bail at any gate
  - Updates task records at each step

- **Task Records** — Persistent clinical charts in `.devwork/tasks/`
  - Max 30 lines per task record
  - Auto-created by `/intake`, auto-updated by every wosy command
  - Auto-numbering (001.md, 002.md) or custom IDs (AUTH-001.md)
  - Read-first: `/work`, `/context`, `/dispatch` all read before acting
  - Survives across sessions — no more reconstructing context

- **Memory Wiring** — Proactive tooling persistence
  - Detects DB connections, SSH patterns, CLI commands, API endpoints during `/research` and `/work setup`
  - Prompts to save as operational instructions to Claude project memory
  - Memory entries include: command, why this way, prerequisites, verify one-liner
  - Next session reads memory automatically — no re-discovery

- **Three-Layer Memory Model**
  - Project memory (`~/.claude/projects/<project>/memory/`) — permanent tooling patterns
  - Task records (`.devwork/tasks/*.md`) — per-task progress until archived
  - Tasks API (in-session) — real-time orchestration

- **Always-On Dispatch** — `/dispatch` scales XS→XL
  - XS: single inline agent
  - S: single agent with task record updates
  - M: 2-3 parallel agents, conductor coordinates
  - L: parallel agents + verification review
  - XL: auto-split into sub-tasks, then dispatch each

### Changed

- Command count reduced: 16 → 10 visible commands
- `/intake` now creates task records in `.devwork/tasks/` alongside workspace
- `/status` reads/writes task records alongside status.md
- `/context` reads project memory and task records first
- `/research` includes proactive memory detection (Step 6)
- `/plan` updates task records with sizing and phase breakdown
- `/dispatch` rewritten for always-on orchestration + conductor pattern
- `global/CLAUDE.md` updated: v2.0 command table, conductor pattern, three-layer memory model
- `install.sh` updated: v2.0 command list, merged commands removed
- `README.md` rewritten for v2.0 features
- `SETUP-GUIDE.md` updated for v2.0 workflow

### Removed (merged)

- `constitution.md` → merged into `/work setup`
- `project-init.md` → merged into `/work setup`
- `rebuild.md` → merged into `/work setup update`
- `verify.md` → merged into `/work ship` (Gate 1)
- `deliver.md` → merged into `/work ship` (Gate 2)
- `graduate.md` → merged into `/work ship` (Gate 3)
- `archive.md` → merged into `/work ship` (Gate 4)

**Note:** The logic from removed commands is preserved verbatim inside `/work setup` and `/work ship`. Only the standalone command files are removed.

---

## [1.3.0] - 2026-03-09

### Added

- **`/dispatch`** — Wosy's own task orchestrator
  - Dispatches parallel sub-agents for M/L-sized tasks from tasks.md dependency graph
  - Validates sizing before dispatch (refuses XS/S/XL)
  - Merges results, updates tasks.md checkboxes, never auto-commits

- **T-Shirt Sizing in `/plan`** — Effort + complexity + risk scoring
  - XS→XL based on file count, coupling, unknowns from research.md
  - Determines execution strategy: manual, dispatch, or superpowers escalation
  - Extended tasks.md template with dependency graph for M+ tasks

- **Parallel Research mode in `/research`** — Step 2a
  - When task touches 3+ subsystems, offers parallel Explore agent dispatch
  - Merges agent findings, de-duplicates, flags conflicts

- **Integrations detection in `/constitution`** — Phase 2 task
  - Auto-detects code hosting (git remote), ticket CLIs (jira, linear), PR CLIs
  - User confirms/completes, chooses global vs local scope
  - New `## Integrations` section in constitution template

### Changed

- `project-init.md` template includes Integrations + Orchestration sections
- `pr-review.md` reads PR CLI from constitution integrations (Step 0)
- `global/CLAUDE.md` updated command routing with orchestration rule + integrations
- Workflow commands table now includes `/wosy:dispatch` (16 commands total)
- `install.sh` updated to include dispatch.md

---

## [1.2.0] - 2026-03-08

### Added

- **`/pr-review`** - Code review from commit or branch diff
  - Three-pass review: correctness, performance, constitution compliance
  - Confidence-based filtering (HIGH/MEDIUM/LOW)
  - Structured report output to `.devwork/reviews/`

- **`wosy:` namespace** - All 14 commands available as `/wosy:command`
  - Coexists with superpowers plugin without ambiguity
  - Flat files kept as aliases (`/plan` still works)
  - `~/.claude/commands/wosy/` subfolder with canonical copies

### Changed

- `constitution.md` expanded PHP detection beyond Laravel (Symfony, Slim, CakePHP, vanilla), dynamic architecture scanning (`app/`/`src/`/`lib/`), and `jq`-based external service detection
- `deliver.md` added debug pattern detection table for 9 stacks (PHP, JS/TS, Swift, Python, Rust, Go, Ruby, Java/Kotlin, Dart)
- `project-init.md` added Example 2 (Next.js SaaS) and Example 3 (Swift/iOS), renumbered CLI example to 4
- CLAUDE.md updated with command routing section
- CLAUDE.md updated with CARL Integration block
- CLI tool preferences expanded: sd, zoxide, glow, htop, btm, procs, dust, ncdu, httpie, tokei, hyperfine, zellij/tmux, direnv
- Constitution Flags section added to installed CLAUDE.md
- install.sh updated to install `wosy/` subfolder
- README command count updated: 13 → 14

---

## [1.1.0] - 2026-02-09

### Added

- **`/phase0`** - Greenfield project discovery and structured documentation
  - Adaptive cascading interview (not fixed script)
  - Generates 4 living documents + comprehensive README.md
  - Resumable sessions with `phase0 resume`

- **`/context`** - Quick resume after context switch
  - Read-only state summary
  - Shows task, phase, progress, next action

- **`/verify`** - Phase checkpoint validation
  - Checks research, spec, plan, and deliver phases
  - Detects test/lint tools from constitution or manifests

- **`/archive`** - Archive completed workspaces
  - Move to `.devwork/_archive/` with index
  - Batch clean delivered tasks

- **Work Modes**: Deep Dive, Hybrid, Straight
  - `/intake` now suggests work mode based on task type and context
  - Cross-cutting commands: `/context`, `/status`, `/verify`

- Multi-stack support for testing and quality tools
  - Swift: XCTest, Swift Testing, SwiftLint, SwiftFormat
  - Python: pytest, Ruff, Black, mypy
  - Rust: cargo test, clippy, rustfmt
  - Go: go test, golangci-lint, gofmt

- Extended CLI tool preferences
  - `sd` instead of `sed`, `zoxide` instead of `cd`, `glow` for Markdown
  - System monitoring: htop, bottom, procs, dust, ncdu
  - HTTP: httpie
  - Code analysis: tokei, hyperfine
  - Terminal: zellij/tmux, direnv

- Constitution Flags section in CLAUDE.md

### Changed

- All commands now use `{task-id}` instead of `{jira-id}` (tracker-agnostic)
- `constitution.md` updated with latest improvements (Phase 0 pre-flight, multi-stack detection, comment philosophy)
- `intake.md` now suggests Work Mode and checks for Phase 0 docs; only creates `status.md` (lazy file creation)
- `deliver.md` detects tools from constitution/manifests instead of hardcoding
- `research.md` template is now stack-agnostic (removed PHP-specific code block examples)
- `plan.md` tasks template uses detected tools instead of hardcoded linters
- `install.sh` now copies source files from `global/` instead of embedding heredocs (cleaner, maintainable)

---

## [1.0.0] - 2025-01-31

### Added

- **`/constitution`** - Single entry point for project setup
  - Creates `.devwork/` directory structure
  - Generates AI coding guidelines from codebase analysis
  - Creates project `CLAUDE.md`
  - Supports `update`, `reset`, and `repair` flags

- **`/intake`** - Task classification and workspace creation
  - Hotfix, bugfix, feature, refactor classification
  - Automatic workspace setup based on task type

- **`/research`** - Codebase exploration
  - Pattern discovery using `rg` and `fd`
  - Documents findings in `research.md`

- **`/spec`** - Requirements interview
  - Structured questioning for edge cases
  - Generates `spec.md` with acceptance criteria

- **`/plan`** - Implementation planning
  - Phase-based task breakdown
  - Generates `plan.md` and `tasks.md`

- **`/status`** - Progress tracking
  - `[TODO]`, `[DONE]`, `[BLOCKED]` tags
  - "Next Action" for context-switching

- **`/deliver`** - Commit preparation
  - Pre-commit checklist
  - Conventional commit message generation
  - Graduation prompt

- **`/graduate`** - Artifact promotion
  - Moves working specs to `specs/` directory
  - Moves working ADRs to `decisions/` directory
  - Maintains indexes

### Architecture

- Two-tier document system (working vs graduated)
- Industry-standard formats (MADR for ADRs, spec-kit style for specs)
- Gitignored `.devwork/` folder for clean repositories

### Documentation

- Comprehensive SETUP-GUIDE.md
- ADR-001 documenting architecture decisions
- README.md with quick start guide

---

## [Unreleased]

### Planned

- hooks/ support — pre/post tool-use validation scripts (validate-bash.sh, lint-on-save)
- .mcp.json template — starter MCP integration config for team sharing
- Language-specific constitution templates
- Cross-project task record dashboard
