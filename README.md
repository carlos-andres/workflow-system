# Wosy — Workflow System for Claude Code

A plugin that orchestrates development workflows inside Claude Code. One smart router, structured phases, persistent task records, zero chaos.

```
/work → /intake → /research → /plan → /dispatch → /work ship
```

## Structure

```
~/.claude/
├── CLAUDE.md                          # Global config (customize)
├── skills/
│   ├── wosy-work/SKILL.md             # Smart router + setup + ship
│   ├── wosy-intake/SKILL.md           # Task intake & workspace
│   ├── wosy-research/SKILL.md         # Codebase exploration
│   ├── wosy-spec/SKILL.md             # Requirements interview
│   ├── wosy-plan/SKILL.md             # Implementation planning
│   ├── wosy-dispatch/SKILL.md         # Task orchestration
│   ├── wosy-status/SKILL.md           # Progress tracking
│   ├── wosy-context/SKILL.md          # Quick resume
│   ├── wosy-phase0/SKILL.md           # Greenfield discovery
│   ├── wosy-pr-review/SKILL.md        # Code review from diff
│   ├── wosy-models/SKILL.md           # Model assignment
│   ├── debugging/SKILL.md             # Systematic debugging
│   ├── tdd/SKILL.md                   # Test-driven development
│   └── verify/SKILL.md                # Verification discipline
├── agents/
│   ├── code-reviewer.md               # Code review agent
│   └── security-auditor.md            # Security audit agent
└── rules/
    └── wosy-conductor.md              # Conductor discipline (always-on)
```

## Installation

```bash
git clone https://github.com/carlos-andres/workflow-system.git
cd workflow-system && ./install.sh
```

Use `./install.sh --preserve` to keep your existing `~/.claude/CLAUDE.md`.

After install, open any project in Claude Code and run `/work setup`.

## Skills

**Workflow Skills:**
- `/work` — Smart router: detects phase, suggests next step
- `/work setup` — Project setup: constitution, directories, memory wiring
- `/work ship` — Delivery pipeline: verify, deliver, graduate, archive
- `/intake` — Classify task, create workspace + task record
- `/research` — Explore codebase, detect tooling, save to memory
- `/spec` — Structured interview, edge cases, acceptance criteria
- `/plan` — Implementation plan + T-shirt sizing (XS-XL)
- `/dispatch` — Orchestrate sub-agents (scales XS to XL)
- `/status` — Update task records and status files
- `/context` — Read memory + task records, show current state
- `/phase0` — Discovery for brand-new projects
- `/pr-review` — Three-pass review from commit or branch diff
- `/models` — Model assignment guide (which model for what)

**Supporting Skills:**
- `debugging` — Systematic root-cause debugging
- `tdd` — Red-green-refactor with framework auto-detection
- `verify` — Evidence-based verification before claiming done

## Workflow Modes

**Deep Dive** — Greenfield or complex discovery:
`/phase0 → /work setup → /intake → /research → /spec → /plan → /dispatch → /work ship`

**Hybrid** — Existing codebase, feature work (most common):
`/intake → /research → /plan → /dispatch → /work ship`

**Straight** — Clear scope, quick tasks, hotfixes:
`/intake → implement → /work ship`

Cross-cutting: `/work` (router), `/context` (resume), `/status` (progress).

## Key Concepts

- **Conductor pattern** — Main window orchestrates; sub-agents do all implementation. Conductor holds context, dispatches, updates records.
- **Task records** — Compact files in `.devwork/tasks/` (max 30 lines). Created by `/intake`, updated by every command, survive across sessions.
- **T-shirt sizing** — `/plan` scores XS-XL by file count, coupling, unknowns. Size determines dispatch strategy.
- **Script-and-defer** — Long-running commands written to `.sh` scripts, handed to user. Never executed inline.
- **Three-layer memory** — Project memory (permanent), task records (per-task), Tasks API (in-session).

## Philosophy

- **Token efficiency** — Every instruction earns its bytes. If removing a line doesn't change behavior, remove it.
- **Port, don't copy** — Extract patterns from your actual codebase. No generic templates.
- **Evidence-driven** — `verify` demands proof before any "done" claim.
- **Remember, don't re-discover** — Tooling patterns saved to project memory. Discovered once, used forever.

## Migration from v2

v2 used `commands/wosy/*.md` (slash commands). v3 uses `skills/wosy-*/SKILL.md` plus `rules/` and `agents/`. The installer handles this automatically.

## Project Structure (after `/work setup`)

```
your-project/
├── CLAUDE.md                    # Project config
└── .devwork/                    # Gitignored
    ├── constitution.md          # AI coding guidelines
    ├── tasks/                   # Task records
    ├── decisions/               # Graduated ADRs
    ├── specs/                   # Graduated specs
    ├── feature/                 # Active feature workspaces
    ├── hotfix/                  # Active hotfix workspaces
    ├── _archive/                # Completed work
    └── _scratch/                # Temporary notes
```

## License

MIT — use it, modify it, share it. See [CHANGELOG.md](CHANGELOG.md) for version history.
