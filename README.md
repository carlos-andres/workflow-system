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
  <img src="https://img.shields.io/badge/version-1.1.0-blue?style=flat-square" alt="Version"/>
  <img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" alt="License"/>
  <img src="https://img.shields.io/badge/PRs-welcome-brightgreen?style=flat-square" alt="PRs Welcome"/>
</p>

---

## The Problem

Working with AI coding assistants can be chaotic:

- **Scope creep** — Features grow beyond original intent
- **Context loss** — Forgetting where you left off after switching projects
- **Missing edge cases** — Bugs slip through incomplete specs
- **Breaking changes** — Modifications that break existing functionality
- **Unclear requirements** — Starting to code before understanding the problem

## The Solution

A **structured workflow system** that brings order to AI-assisted development:

```
/phase0 → /constitution → /intake → /research → /spec → /plan → implement → /verify → /deliver → /graduate → /archive
```

One command to set up. Thirteen commands to master. Zero chaos.

---

## Quick Start

```bash
# 1. Install the workflow system
./install.sh

# 2. Open any project in Claude Code, then run:
/constitution

# 3. Start your first task:
/intake AUTH-001 "Add user authentication"

# 4. Follow the workflow:
/research    # Understand the codebase
/spec        # Define requirements (if unclear)
/plan        # Design implementation
# ... implement ...
/status      # Track progress
/verify      # Validate before shipping
/deliver     # Prepare commit
/graduate    # Preserve important decisions
/archive     # Clean up workspace
```

**That's it.** Your project now has AI coding guidelines, organized artifacts, and a repeatable process.

---

## Features

### Single Setup Command

```bash
/constitution
```

One command creates everything:
- `.devwork/` directory structure
- AI coding guidelines document
- Project `CLAUDE.md` configuration
- Decision and spec indexes

### AI Coding Guidelines

The constitution extracts **real patterns** from your codebase:

```markdown
## AI Coding Guidelines

### Type Declarations
- Return types: ALWAYS
- Property types: ALWAYS
- Strict types: YES

### Naming Conventions
| Element      | Convention     | Example          |
|--------------|----------------|------------------|
| Classes      | PascalCase     | `UserController` |
| Methods      | camelCase      | `getUserById()`  |
| DB Tables    | snake_case     | `user_profiles`  |
```

Claude Code reads this and writes code that **fits your project**.

### Organized Artifacts

```
.devwork/
├── constitution.md          # AI coding guidelines
├── decisions/               # Graduated ADRs (shareable)
│   └── 0001-use-sanctum.md
├── specs/                   # Graduated specs (shareable)
│   └── auth-001-auth.md
├── feature/                 # Active work
│   └── auth-001/
│       ├── status.md        # "Next Action" for context-switching
│       ├── spec.md          # Working requirements
│       └── plan.md          # Implementation approach
└── _archive/                # Completed tickets
```

### Two-Tier Document System

| Tier | Location | Purpose |
|------|----------|---------|
| **Working** | `feature/{id}/spec.md` | Drafts, iterations, messy notes |
| **Graduated** | `specs/{id}-name.md` | Final, shareable, industry-format |

Graduate important work with `/graduate`. Keep your knowledge, clean your repos.

### Smart Flags

```bash
/constitution              # Full setup
/constitution update       # Re-scan, preserve notes
/constitution reset        # Fresh start (with backup)
/constitution repair       # Fix structure only
```

---

## Commands

### Setup

| Command | Purpose |
|---------|---------|
| `/phase0` | Greenfield discovery — idea to structured docs |
| `/constitution` | **The only setup command you need** |
| `/project-init` | Generate project CLAUDE.md |

### Workflow

| Command | Phase | What it does |
|---------|-------|--------------|
| `/intake` | Start | Classify task, create workspace, suggest work mode |
| `/research` | Discover | Explore codebase, find patterns |
| `/spec` | Define | Requirements interview |
| `/plan` | Design | Implementation approach + tasks |
| `/status` | Track | Update progress, set "Next Action" |
| `/context` | Resume | Quick state summary after context switch |
| `/verify` | Checkpoint | Validate phase/task completion |
| `/deliver` | Ship | Pre-commit checklist, generate message |
| `/graduate` | Preserve | Promote artifacts to shareable location |
| `/archive` | Cleanup | Archive completed workspaces |

### Work Modes

```
Mode 1: Deep Dive (greenfield, complex discovery)
  /phase0 → /constitution → /intake → /research → /spec → /plan → implement → /verify → /deliver → /graduate

Mode 2: Hybrid (existing codebase, feature work)
  /intake → /research → /plan → implement → /verify → /deliver
  Skip /spec if requirements clear. Use /status between sessions.

Mode 3: Straight (clear scope, quick tasks, hotfixes)
  /intake → implement → /deliver
  Or skip /intake entirely if no tracking needed.

Cross-cutting:
  /context — resume any mode after context switch
  /status  — update progress in any mode
  /verify  — checkpoint before /deliver in any mode
```

---

## Philosophy

### Industry Standards, Solo Dev Reality

We use **industry-standard formats** (MADR for ADRs, spec-kit style for specs) inside a **lightweight workflow** designed for individual developers.

### Extract, Don't Assume

The constitution **reads your actual code** to understand patterns. No generic templates—real examples from your codebase.

### Working vs Permanent

Messy drafts stay in ticket folders. Important decisions graduate to shareable directories. Best of both worlds.

### Context-Switching Solved

Every `status.md` has a "Next Action" field. Come back after a week? You know exactly where to pick up.

```markdown
## Next Action
Implement the `validateYear()` method in YearFilter.php, then write test.
```

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
├── CLAUDE.md              # Global configuration
└── commands/
    ├── phase0.md          # Greenfield discovery
    ├── constitution.md    # Setup + AI guidelines
    ├── project-init.md    # Project CLAUDE.md generator
    ├── intake.md          # Task classification
    ├── research.md        # Codebase exploration
    ├── spec.md            # Requirements interview
    ├── plan.md            # Implementation planning
    ├── status.md          # Progress tracking
    ├── context.md         # Context switch resume
    ├── verify.md          # Phase validation
    ├── deliver.md         # Commit preparation
    ├── graduate.md        # Artifact promotion
    └── archive.md         # Workspace cleanup
```

### Manual Installation

1. Copy `global/CLAUDE.md` to `~/.claude/CLAUDE.md`
2. Copy `global/commands/*.md` to `~/.claude/commands/`
3. Add `.devwork/` to your global gitignore:
   ```bash
   echo ".devwork/" >> ~/.gitignore_global
   git config --global core.excludesfile ~/.gitignore_global
   ```

---

## Project Structure

After running `/constitution` in a project:

```
your-project/
├── CLAUDE.md                    # Project config (references constitution)
└── .devwork/                    # Gitignored
    ├── constitution.md          # AI coding guidelines
    ├── decisions/               # Graduated ADRs
    │   ├── README.md
    │   ├── 0001-auth-strategy.md
    │   └── 0002-caching-layer.md
    ├── specs/                   # Graduated specs
    │   ├── README.md
    │   └── auth-001-notifications.md
    ├── feature/                 # Active features
    │   └── auth-001/
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

## Constitution Example

Here's what gets generated:

```markdown
# Project Constitution

> AI Coding Guidelines for acme-api
> Generated: 2025-01-31

## Tech Stack

| Component | Version |
|-----------|---------|
| PHP       | 8.3     |
| Laravel   | 11.x    |
| Database  | MySQL   |

## AI Coding Guidelines

### Type Declarations
- Return types: **ALWAYS**
- Strict types: **YES**

### Import Organization
// Framework first, then App classes, alphabetized
use Illuminate\Http\JsonResponse;
use App\Models\User;
use App\Services\UserService;

### Controller Pattern
// From: app/Http/Controllers/UserController.php
class UserController extends Controller
{
    public function __construct(
        private UserService $userService
    ) {}

    public function show(int $id): JsonResponse
    {
        return UserResource::make(
            $this->userService->find($id)
        );
    }
}

## Do NOT Touch
<!-- Your notes here -->

## Manual Notes
<!-- Your notes here -->
```

---

## Contributing

Contributions are welcome! This system was born from real pain points in AI-assisted development.

### Ideas for Contribution

- **Language-specific constitutions** — Ruby, Python, Go templates
- **IDE integrations** — VS Code extension, JetBrains plugin
- **Metrics** — Track time saved, decisions made
- **Themes** — Different constitution styles

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

## References & Industry Standards

This workflow system is built on proven industry standards and best practices:

### Claude Code (Anthropic)
- **Source**: [Claude Code Best Practices](https://www.anthropic.com/engineering/claude-code-best-practices)
- **Used for**: CLAUDE.md hierarchy, slash commands, skills structure
- **Key insight**: Global → Project → Subdirectory configuration inheritance

### Spec-Kit (GitHub)
- **Source**: [github/spec-kit](https://github.com/github/spec-kit)
- **Used for**: Spec-driven development, spec.md format, tasks.md structure
- **Key insight**: Constitution concept, branch-based specs, requirements-first approach

### MADR (Markdown ADR)
- **Source**: [adr.github.io/madr](https://adr.github.io/madr/)
- **Used for**: ADR format, decision documentation structure
- **Key insight**: Status lifecycle, decision drivers, consequences documentation

### ADR Standards
- **Sources**:
  - [AWS Prescriptive Guidance](https://docs.aws.amazon.com/prescriptive-guidance/latest/architectural-decision-records/welcome.html)
  - [Microsoft Azure Architecture](https://learn.microsoft.com/en-us/azure/architecture/decision-log/)
  - [Nygard's Original ADR](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions)
- **Used for**: Numbering convention, decision log index, status management
- **Key insight**: Never delete ADRs, mark as superseded instead

### Cursor AI
- **Source**: Cursor IDE documentation
- **Used for**: Hierarchical rules concept, `.cursor/rules/` pattern
- **Key insight**: Team-shareable AI configuration files

### Conventional Commits
- **Source**: [conventionalcommits.org](https://www.conventionalcommits.org/)
- **Used for**: Commit message format in `/deliver` command
- **Key insight**: `feat:`, `fix:`, `refactor:` prefixes for clear history

---

## Why This Hybrid Approach?

We analyzed existing standards and found a gap:

| Standard | Designed For | Limitation for Solo + AI |
|----------|--------------|--------------------------|
| Spec-Kit | Teams, committed to git | Too heavy, pollutes repo |
| MADR | Team decisions | No working/draft workflow |
| Cursor Rules | AI configuration | No project management |
| Claude CLAUDE.md | AI context | No artifact organization |

**Our solution**: Take the best document formats from industry (MADR, spec-kit) and wrap them in a lightweight workflow designed for solo developers using AI assistants.

### Key Innovations

1. **Two-tier documents** — Working drafts vs graduated finals
2. **Gitignored artifacts** — Keep repos clean, knowledge preserved
3. **Single setup command** — `/constitution` does everything
4. **AI coding guidelines** — Extracted from actual code, not templates
5. **Context-switching support** — "Next Action" in every status.md
6. **Work modes** — Deep Dive, Hybrid, Straight for different task types
7. **Phase 0** — Pre-code discovery for greenfield projects

---

## Acknowledgments

- **[Anthropic](https://anthropic.com)** — For Claude Code and the CLAUDE.md concept
- **[GitHub Spec-Kit](https://github.com/github/spec-kit)** — For spec-driven development inspiration
- **[MADR](https://adr.github.io/madr/)** — For the ADR format we adopted
- **[Conventional Commits](https://conventionalcommits.org)** — For commit message standards
- **The developer community** — For feedback, ideas, and real-world testing

---

<p align="center">
  <strong>Stop the chaos. Start the workflow.</strong>
</p>
