# Wosy System — Evidence-Based Inventory

> Generated: 2026-04-07
> Source: 18 `.devwork` directories, 4 plan files, 2,541 history entries, 12 project memory dirs
> Purpose: Ground truth for wosy v3 improvements

---

## 1. Task Type Taxonomy

Derived from actual project artifacts — not assumptions.

| Type | Examples | Actors | Output | Git? | Commit? |
|------|----------|--------|--------|------|---------|
| **Feature** | NextAlarm NA-001–006, DotEdit UI redesign, CDW-2364, ohana onboarding | Planner + Implementer + Reviewer | Code + PR | Yes | Offer text |
| **Hotfix** | NTGRTNS-1399, DT-2604, CDW-2364 prod | Researcher + Implementer + Reviewer | Code + PR | Yes | Offer text |
| **Bugfix** | PHP static analysis fixes, email conflict handler | Researcher + Implementer | Code + PR | Yes | Offer text |
| **Refactor** | Memory management, TEQ handler cleanup | Researcher + Implementer + Reviewer | Code + PR | Yes | Offer text |
| **Release** | freeze-release-48, branch promotion, GitFlow sync | Researcher + Architect | Branch + PR list | Yes | No (text only) |
| **Report** | ATW lifecycle HTML, log-report.py, dealer_report.py, audit HTML | Researcher + Reporter | HTML/MD file | No | No |
| **Research/Audit** | VIN dedup ADR-006/007, NTGRTNS-1400 audit, mapper verification | Researcher + Architect | Research docs + ADR | No | No |
| **QA/Testing** | ohana playwright smoke, CRUD validation, E2E before deploy | Reviewer + Reporter | Test results doc | No | No |
| **Deployment** | ohana rsync, ssh artisan optimize, migration runs | Implementer | Confirmation | No | No |
| **Brainstorm** | DotEdit _scratch/phase0 docs, phase0-idea.md | Facilitator | Discovery docs | No | No |
| **Infrastructure/ADR** | Server ADRs — PostgreSQL upgrade, TLS, ports | Architect | ADR file | Optional | Optional |

---

## 2. Actor Inventory

Roles that appear across actual tasks. Mapped to optimal Claude models.

| Actor | Model | Responsibilities | Evidence |
|-------|-------|-----------------|----------|
| **Conductor** | sonnet | Orchestrates, reads context, dispatches, never implements | Main window in all sessions |
| **Researcher** | sonnet | Explores codebase, produces research.md, verifies patterns | research/ dirs, investigation.md files |
| **Architect** | opus | Writes spec, plan, ADRs, designs system | 25+ ADR files, plan.md in workspaces |
| **Implementer** | sonnet | Writes code, bug fixes, file edits | feature/hotfix workspaces across all projects |
| **Reviewer** | opus | Code review, security audit, PR review | pr-102-review.md, code review artifacts |
| **Reporter** | sonnet | Generates HTML/MD reports, documents findings | atw-lifecycle-report.html, log-report.py, audit HTML |
| **QA Tester** | sonnet | Playwright smoke tests, CRUD validation, E2E | ohana playwright sessions, smoke test artifacts |
| **Deployer** | sonnet | rsync, SSH commands, artisan, migrations | ohana deploy sessions, RUNBOOK.md |

---

## 3. Workflow Lifecycle by Task Type

### Code Tasks (feature/hotfix/bugfix/refactor)
```
/intake → /research → [/spec if unclear] → /plan → /dispatch(Implementer:sonnet)
       → tests → /dispatch(Reviewer:opus) → /work ship → offer commit text + PR text
```

### Report Generation
```
/intake → /research(Researcher:sonnet) → /plan → /dispatch(Reporter:sonnet) → output file
No git steps. No commit. Output is the deliverable.
```

### Research / Audit
```
/intake → /research(Researcher:sonnet) → document findings → ADR if needed
No implementation. Output is the research doc.
```

### QA / Smoke Testing
```
/intake (type=QA) → /dispatch(QA Tester:sonnet) → test results doc
No code changes. No commit. May trigger follow-up feature task if issues found.
```

### Deployment
```
/intake (type=Deployment) → verify prerequisites → /dispatch(Deployer:sonnet) → confirmation
No commit. Pre-deployment: ensure all code tasks completed.
```

### Release Management
```
/intake (type=Release) → /research (branch state) → /plan (promotion list) → manual execution
Present PR/merge text for each branch. Never auto-merge.
```

### Brainstorm / Discovery
```
/phase0 → discovery docs (01-idea.md → 06-build-roadmap.md)
May lead to /work setup + full feature cycle.
```

---

## 4. Project Context Map

### Personal Projects (`PERSONAL_ROOT` — defined in `~/.claude/CLAUDE.md`)
- iOS apps: NextAlarm, NextBep, Keys (Swift/SwiftUI, XCTest)
- macOS apps: DotEdit (MVVM, 54 source files)
- Websites: carlos-andres.pro (Astro), DotEditWebsite (Astro), kreata, ohana (Laravel/Filament)
- Mobile: luisquintero/anagramas (Windows C# + macOS Swift), palindromos
- Infrastructure: server (PostgreSQL, TLS, nginx ADRs)
- Full git workflow. Commits offered; execute only if user explicitly approves per project.

### Work Projects (`WORK_ROOT` — defined in `~/.claude/CLAUDE.md`)
- Backend: tc-api-new (PHP 8.3 / Laravel 10), worker-integrations (PHP CLI), api-php
- Frontend: trailertrader-fe (React), dashboard-v2
- Integration: Integrations workspace (wrapper for tc-api-new + worker-integrations)
- **Commit policy**: Present commit text + PR description as copy-ready blocks. User executes manually. Never run git.

---

## 5. Status Tracking Model (v3)

### What changed
| Aspect | v2 (old) | v3 (new) |
|--------|----------|----------|
| `status.md` content | [TODO], [DONE], [BLOCKED] mix | Done log only — verified items |
| Pending work | In status.md [TODO] | In `tasks.md` (checkboxes) or `backlog.md` |
| Current focus | In status.md ## Current State | In task record `## Active` (single line) |
| Max lines | not enforced | 20 lines |

### status.md format (v3)
```markdown
# Status: {task-id}

## Current
{single line: what's being worked on. Or "complete"}

## Done
- [x] Research codebase (YYYY-MM-DD)
- [x] Implementation plan (YYYY-MM-DD)

## Blocked
{if applicable}

## Session Log
### YYYY-MM-DD
- {brief entry}
```

---

## 6. Scope Gate

Every task must have a scope document before any subagent is dispatched.

| Size | Scope Document |
|------|---------------|
| XS | Inline spec block embedded in task record (no separate file) |
| S | `spec.md` or light `plan.md` in workspace |
| M/L | Full `spec.md` + `plan.md` + `tasks.md` with dependency graph |
| XL | All of M/L + sub-task breakdown |

Non-code tasks (report, QA, deployment) need at minimum a goal statement + output path in the task record.

---

## 7. Gaps Found in v2 (Fixed in v3)

| Gap | Fix |
|-----|-----|
| No model assignment anywhere | `models.md` reference + model required in every Agent call |
| Conventional commit offered for all tasks | Git-context gate: only if `.git` + code changes produced |
| Corporate project commit behavior undefined | Explicit: text only, user executes |
| status.md mixed TODO/DONE | Flipped to done-log only |
| Subagent dispatch without scope doc | Scope gate in `/dispatch` Step 0 |
| Task types only: hotfix/bugfix/feature/refactor | Expanded to 11 types covering all observed patterns |
| Conductor discipline not documented | `conductor.md` with 5 rules + context budget |
| No reference to research/audit workflow | Added to intake classification + lifecycle map |
| Deployment/QA had no formal path | Added as task types with correct skip-git behavior |

---

## 8. Observed Tooling Patterns

Consistent across multiple projects — already in project memories.

| Tool | Use | Projects |
|------|-----|---------|
| MySQL aliases (prod_ro, staging, etc.) | DB access — NEVER inline credentials | work projects (WORK_ROOT) |
| rsync + SSH | Deployment (personal sites) | personal projects |
| Playwright (MCP) | E2E/smoke testing | personal projects |
| PHPUnit/Pest | PHP testing | work projects (WORK_ROOT) |
| XCTest/Swift Testing | iOS/macOS testing | personal projects |
| pnpm | Node projects | personal projects (per project memory) |
| iPhone 16e simulator | iOS builds | personal projects (per project memory) |
