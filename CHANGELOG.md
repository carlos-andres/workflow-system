# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

- Language-specific constitution templates (Python, Ruby, Go)
- VS Code extension for command palette integration
- Metrics tracking for workflow efficiency
