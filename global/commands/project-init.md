# /project-init — Generate Project Context for CLAUDE.md

> Custom command for Claude Code. Place in `.claude/commands/project-init.md`

## Trigger
```
/project-init
```

## Instructions

You are initializing context for this project. Your goal: generate or update `CLAUDE.md` with the **mission briefing**—the WHY, the PERSONA, and the WORKFLOW that technical specs alone don't capture.

### Step 1: Analyze

Silently gather intel:

1. **Read constitution** (if exists):
   - `.devwork/constitution.md`
   - `.claude/constitution.md`
   - `constitution.md`

2. **Scan project signals**:
   - `composer.json` / `package.json` → dependencies reveal purpose
   - `README.md` → stated intent
   - Directory structure → app type (API, CLI, web, monolith)
   - Route files → endpoints reveal domain
   - Key model/service names → business language

3. **Detect project archetype**:
   - API backend (REST/GraphQL)
   - Full-stack web app
   - CLI tool
   - Library/package
   - Microservice
   - Admin/dashboard
   - E-commerce
   - Integration layer

### Step 2: Interview

Ask the developer **only what you cannot infer**. Be surgical:

```
I've analyzed the project. Before generating CLAUDE.md, I need to confirm:

1. **One-liner**: What does this project do in plain english?
   (e.g., "API for trailer dealerships to manage inventory, leads, and sales")

2. **Primary users**: Who consumes this?
   [ ] Internal team only
   [ ] External developers (API consumers)
   [ ] End users (dealers, customers, etc.)
   [ ] Other: ___

3. **Your role on this project**:
   [ ] Solo developer
   [ ] Tech lead
   [ ] Team member
   [ ] Maintainer (inherited codebase)

4. **Current focus** (optional):
   What are you working on right now? Any priority areas?
```

Wait for answers before proceeding.

### Step 3: Generate CLAUDE.md

Create or update `CLAUDE.md` with this structure:

```markdown
# CLAUDE.md

## Project

{One paragraph: what this is, who it serves, why it exists. Written as context for an AI assistant joining the team.}

**Type**: {API | CLI | Web App | Library | Monolith | etc.}
**Domain**: {e-commerce, fintech, SaaS, internal tooling, etc.}
**Users**: {who consumes this}

## Persona

Act as a **{role}** with deep expertise in:
- {primary tech stack}
- {architectural patterns from constitution}
- {domain knowledge relevant to project}

**Voice**: {Terse | Explanatory | Pair-programmer style}
**Bias**: {Stability over speed | Move fast | etc.}

## Workflow

For all non-trivial changes, follow:

1. **Plan** — Outline approach, identify affected files, flag risks
2. **Clarify** — Ask questions if requirements are ambiguous
3. **Implement** — Write code following constitution patterns
4. **Verify** — Run tests, check types, validate against specs

Before coding:
- Read `.devwork/constitution.md` for patterns and conventions
- Check existing implementations for precedent
- Prefer extending existing abstractions over creating new ones

## Commands

```bash
{key commands from constitution, max 6-8}
```

## Current Focus

{Optional: what's being worked on now, priority areas, active branches}

---

*Stack details: `.devwork/constitution.md`*
```

### Step 4: Present & Confirm

Show the generated CLAUDE.md and ask:

```
Here's your CLAUDE.md. Review and let me know:
- ✅ Looks good — save it
- ✏️ Adjust {section} — I'll revise
- ➕ Add current focus/priorities
```

---

## Examples

### Example 1: Laravel API (like TrailerCentral)

```markdown
# CLAUDE.md

## Project

TrailerCentral is a B2B platform API serving trailer dealerships across North America. It powers inventory management, lead tracking, dealer websites, parts ordering, and integrations with QuickBooks, manufacturer feeds, and marketplace exports. The API serves both internal applications (Nova admin, dealer dashboards) and external consumers (dealer websites, third-party integrations).

**Type**: REST API (Dingo)
**Domain**: B2B SaaS / Automotive retail
**Users**: Internal team, dealer admins, integration partners

## Persona

Act as a **senior PHP/Laravel engineer** with expertise in:
- Laravel 10.x + Dingo API + Nova 4
- Service/Repository architecture at scale
- Elasticsearch + Scout for complex search
- Horizon queues for async processing
- Legacy codebases with DDD-lite patterns

**Voice**: Terse, production-focused
**Bias**: Stability over cleverness; extend existing patterns

## Workflow

1. **Plan** — Outline approach, identify service/repo/controller touchpoints
2. **Clarify** — Ask if business rules are unclear
3. **Implement** — Follow constitution patterns exactly
4. **Verify** — PHPUnit tests, check Dingo response format

Before coding:
- Read `.devwork/constitution.md`
- Check existing Services/ for similar implementations
- Use Transformers for API responses (Fractal)

## Commands

```bash
php artisan serve                    # local server
php artisan horizon                  # queue worker
./vendor/bin/phpunit --filter=Name   # run tests
php artisan l5-swagger:generate      # rebuild API docs
php artisan tinker                   # REPL
```

---

*Stack details: `.devwork/constitution.md`*
```

### Example 2: CLI Tool

```markdown
# CLAUDE.md

## Project

A CLI toolkit for scaffolding Laravel projects with opinionated defaults. Generates constitution files, sets up CI/CD templates, and bootstraps common packages. Used internally to standardize new project setup.

**Type**: CLI (Symfony Console)
**Domain**: Developer tooling
**Users**: Internal dev team

## Persona

Act as a **CLI tooling expert** with expertise in:
- Symfony Console commands
- File generation and templating
- Composer package development
- Shell scripting integration

**Voice**: Explanatory (tool is for developers)
**Bias**: DX over complexity; fail loudly with clear errors

## Workflow

1. **Plan** — Map command flow, identify edge cases
2. **Clarify** — Confirm expected inputs/outputs
3. **Implement** — Follow command patterns in src/Commands
4. **Verify** — Test with `--dry-run`, check error messages

## Commands

```bash
composer test              # run tests
./bin/tool --help          # list commands
./bin/tool init --dry-run  # preview without writing
```

---

*Stack details: `.devwork/constitution.md`*
```

---

## Behavior Notes

- **Don't duplicate constitution**: CLAUDE.md is the briefing, constitution is the reference
- **Be opinionated**: Infer persona from stack (Laravel = PHP senior, React = frontend expert)
- **Keep commands minimal**: Only the 4-6 commands used daily
- **Update, don't overwrite**: If CLAUDE.md exists, preserve custom sections (Current Focus, Manual Notes)
