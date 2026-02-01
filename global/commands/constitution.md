# /constitution - Project Setup & AI Coding Guidelines

Single entry point for Claude Code project setup.

## Usage

```bash
/constitution              # Full setup
/constitution update       # Re-scan, preserve manual sections
/constitution reset        # Backup existing, start fresh
/constitution repair       # Fix structure only, no scan
```

---

## Phase 1: Create Structure

```bash
mkdir -p .devwork/{decisions,specs,feature,hotfix,_archive,_scratch}
```

Create indexes: `decisions/README.md`, `specs/README.md`

Verify gitignore: Check `~/.gitignore_global` first, then `.gitignore`

---

## Phase 2: Scan Project

### Tools
Use CLI tools from global CLAUDE.md: `fd`, `rg`, `jq`, `bat`, `eza`

### Agent Instructions

**Dispatch parallel Task agents:**

```
Task 1 - Config Files:
  jq '{php: .require.php, laravel: .require["laravel/framework"]}' composer.json
  jq '{deps: .dependencies | keys}' package.json
  
Task 2 - Quality Tools:
  fd -t f "pint.json|phpstan.neon|phpcs.xml|.eslintrc*|.prettierrc*" -d 1
  
Task 3 - Architecture:
  fd -t d "Services|Repositories|Actions|DTOs|Enums|Nova|Filament" app/ -d 1
  
Task 4 - Environment:
  rg "^(DB_|CACHE_|QUEUE_|SESSION_)" .env.example
```

**Dispatch Explore agent for pattern extraction:**

```
Sample 10-20 files per category using fd + bat:
- Controllers: DI pattern, response format, error handling
- Models: relationships, casts, scopes, traits  
- Services: signatures, return types, exceptions
- Tests: setup, assertions, database handling
- Vue/JS: composition API, props, imports
```

---

## Phase 3: Generate Constitution

Output: `.devwork/constitution.md`

### Template Structure

```markdown
# Constitution: {PROJECT_NAME}
> Generated: {DATE} | Update: `/constitution update`

---

## Stack

| Layer | Technology | Version |
|-------|------------|---------|
| Backend | PHP | {x.x} |
| Framework | Laravel | {x.x} |
| Frontend | {Vue/Nuxt/React} | {x.x} |
| Database | {MySQL/PostgreSQL} | |
| Cache | {redis/file} | |
| Queue | {redis/database/sync} | |
| Admin | {Nova/Filament/None} | |

---

## Coding Rules

### Types & Declarations

| Rule | Setting |
|------|---------|
| `declare(strict_types=1)` | {ALWAYS/NEVER} |
| Return types | {ALWAYS/SOMETIMES} |
| Property types | {ALWAYS/SOMETIMES} |
| Parameter types | {ALWAYS} |
| Nullable style | {`?Type`/`Type\|null`} |

### Naming

| Element | Convention | Example |
|---------|------------|---------|
| Classes | PascalCase | `UserController` |
| Methods | camelCase | `getUserById()` |
| Properties | camelCase | `$firstName` |
| Constants | UPPER_SNAKE | `MAX_ATTEMPTS` |
| Tables | snake_case_plural | `user_profiles` |
| Columns | snake_case | `created_at` |
| Routes | kebab-case | `/user-profiles` |

### Imports

| Rule | Setting |
|------|---------|
| Grouping | {braces/individual} |
| Order | {framework→app→alphabetical} |
| Aliases | {when/never} |

### Formatting

| Rule | Setting |
|------|---------|
| Braces | {same line/new line} |
| Line length | {120/unlimited} |
| Trailing commas | {yes/no} |
| Method chaining | {inline <3 / multiline ≥3} |

### Error Handling

| Scenario | Pattern |
|----------|---------|
| Not found | {`throw`/`abort()`/`response()`} |
| Validation | {FormRequest/inline} |
| Exceptions | {custom/Laravel defaults} |
| Logging | {always/critical only} |

### Documentation

| Rule | Setting |
|------|---------|
| DocBlocks | {public methods/complex only/never} |
| @throws | {document/skip} |
| Inline comments | {complex logic only} |
| TODO format | {`// TODO:`/`// @todo`} |

---

## Patterns

### Controller
```php
// From: {path}
{extracted pattern - constructor DI, thin/fat, response style}
```

### Service
```php
// From: {path} or "Not used"
{extracted pattern}
```

### Model
```php
// From: {path}
{relationships, casts, scopes pattern}
```

### Request Validation
```php
// From: {path} or "Inline validation"
{extracted pattern}
```

### API Response
```php
// Pattern: {Resource/array/wrapper}
{extracted pattern}
```

---

## Database

| Rule | Setting |
|------|---------|
| Eloquent vs Raw | {Eloquent preferred} |
| N+1 prevention | {eager load with `with()`} |
| Transactions | {multi-write operations} |
| Soft deletes | {standard/per-model} |

---

## Testing

| Item | Value |
|------|-------|
| Framework | {Pest/PHPUnit} |
| DB handling | {RefreshDatabase/Transactions} |
| Factories | {always/when needed} |

```bash
# Commands
{test command}
{test command} --filter=Name
```

---

## Quality

| Tool | Command | Level/Preset |
|------|---------|--------------|
| Pint | `./vendor/bin/pint` | {laravel/psr12} |
| PHPStan | `./vendor/bin/phpstan` | {level 5} |
| ESLint | `npm run lint` | |

---

## Directories

| What | Where |
|------|-------|
| Controllers | `app/Http/Controllers/` |
| Models | `app/Models/` |
| Services | `app/Services/` |
| Requests | `app/Http/Requests/` |
| Resources | `app/Http/Resources/` |
| Tests | `tests/Feature/`, `tests/Unit/` |

---

## Do NOT Touch
<!-- Preserved on update -->

## Manual Notes  
<!-- Preserved on update -->
```

---

## Phase 4: Create CLAUDE.md

Output: `CLAUDE.md` at project root

```markdown
# CLAUDE.md

Constitution: `.devwork/constitution.md`

## Commands
```bash
{dev command}
{test command}
{lint command}
```

## Project Rules
<!-- Overrides beyond constitution -->
```

---

## Output

```
✓ Constitution generated

Stack: {Laravel X / PHP X / Vue X}
Rules: {X categories documented}
Patterns: {X extracted from codebase}

Ready: /intake {JIRA-ID} "description"
```
