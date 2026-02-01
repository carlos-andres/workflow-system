# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
