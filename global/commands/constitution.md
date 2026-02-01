# /constitution - Project Setup & AI Coding Guidelines

The **single entry point** for setting up any project with Claude Code. Creates the `.devwork/` structure, scans the project, generates AI coding guidelines, and creates `CLAUDE.md`.

---

## Usage

```bash
/constitution              # Full setup (first time)
/constitution update       # Re-scan project, preserve manual notes
/constitution reset        # Fresh start (backs up existing)
/constitution repair       # Fix structure issues only
```

---

## Modes

### `/constitution` (Full Setup)

**Use when:** First time setting up a project, or want complete refresh.

**What it does:**
1. ✅ Creates `.devwork/` directory structure
2. ✅ Creates `decisions/README.md` and `specs/README.md` indexes
3. ✅ Scans project deeply (tech stack, patterns, conventions)
4. ✅ Generates `.devwork/constitution.md` (AI coding guidelines)
5. ✅ Creates/updates project `CLAUDE.md` (references constitution)
6. ✅ Verifies `.devwork/` is in `.gitignore`

---

### `/constitution update`

**Use when:** Project evolved, dependencies changed, want to refresh guidelines.

**What it does:**
1. ✅ Re-scans project (tech stack, patterns, conventions)
2. ✅ Updates `.devwork/constitution.md`
3. ✅ **Preserves** "Do NOT Touch" section
4. ✅ **Preserves** "Manual Notes" section
5. ✅ Updates `CLAUDE.md` if needed
6. ⏭️ Skips structure creation (already exists)

---

### `/constitution reset`

**Use when:** Constitution is messy, want clean slate.

**What it does:**
1. ✅ Backs up existing constitution to `.devwork/constitution.md.backup-{timestamp}`
2. ✅ Backs up existing CLAUDE.md to `CLAUDE.md.backup-{timestamp}`
3. ✅ Runs full setup fresh
4. ⚠️ Manual notes will need to be re-added from backup

---

### `/constitution repair`

**Use when:** Structure is broken, missing directories, missing indexes.

**What it does:**
1. ✅ Creates missing directories (`decisions/`, `specs/`, etc.)
2. ✅ Creates missing index files (`README.md` files)
3. ✅ Verifies `.gitignore`
4. ⏭️ Does NOT re-scan project
5. ⏭️ Does NOT modify constitution.md

---

## Full Setup Process

### Phase 1: Create Structure

```bash
mkdir -p .devwork/{decisions,specs,feature,hotfix,_archive,_scratch}
```

**Structure created:**
```
.devwork/
├── constitution.md      # AI coding guidelines (Phase 3)
├── decisions/           # Graduated ADRs
│   └── README.md        # Decision index
├── specs/               # Graduated specs
│   └── README.md        # Spec index
├── feature/             # Active feature work
├── hotfix/              # Active hotfix work
├── _archive/            # Completed tickets
└── _scratch/            # Temporary notes
```

### Phase 2: Deep Project Scan

#### Parallel Config Scanning (Task Agent)

**Task 1: Backend Stack**
```bash
cat composer.json | jq '{php: .require.php, laravel: .require["laravel/framework"], packages: .require | keys}'
cat .env.example | grep -E "^(DB_|CACHE_|QUEUE_|SESSION_|MAIL_)" | head -10
ls -la phpunit.xml pest.php 2>/dev/null
```

**Task 2: Frontend Stack**
```bash
cat package.json | jq '{node: .engines.node, dependencies: .dependencies | keys}' 2>/dev/null
ls -la nuxt.config.* next.config.* vite.config.* tsconfig.json 2>/dev/null
```

**Task 3: Quality Tools**
```bash
ls -la pint.json phpstan.neon phpcs.xml .php-cs-fixer.php 2>/dev/null
ls -la .eslintrc* .prettierrc* 2>/dev/null
cat pint.json 2>/dev/null | head -30
cat phpstan.neon 2>/dev/null | head -20
```

**Task 4: Architecture Detection**
```bash
ls -d app/Services app/Repositories app/Actions app/DTOs app/Enums 2>/dev/null
ls -d app/Nova app/Filament 2>/dev/null
ls app/Http/Requests/ 2>/dev/null | head -5
ls app/Http/Resources/ 2>/dev/null | head -5
```

#### Code Analysis (Explore Agent)

Sample 2-3 files from each category to extract **actual patterns**:

**Controllers** → DI pattern, response format, error handling
**Models** → Relationships, casts, scopes, traits
**Services** → Constructor pattern, method signatures
**Tests** → Setup, assertions, database handling
**Vue/JS** → Composition API, props, imports

### Phase 3: Generate constitution.md

Create `.devwork/constitution.md`:

```markdown
# Project Constitution

> AI Coding Guidelines for {PROJECT_NAME}
> Generated: {DATE} | Update: `/constitution update`

This document defines how AI tools should write code for this project.

---

## Tech Stack

### Backend
| Component | Version | Notes |
|-----------|---------|-------|
| PHP | {version} | |
| Laravel | {version} | |
| Database | {type} | |
| Cache | {driver} | |
| Queue | {driver} | |

### Frontend
| Component | Version | Notes |
|-----------|---------|-------|
| Framework | {Vue/Nuxt/React/Inertia} {version} | |
| Build Tool | {Vite/Webpack} | |
| CSS | {Tailwind/Bootstrap} | |
| TypeScript | {Yes/No} | Strict: {Yes/No} |

### Admin Panel
{Nova/Filament/None} at `app/{Panel}/`

### Key Packages
- {important packages that affect code patterns}

---

## AI Coding Guidelines

### 1. File Header & Strict Types

```php
<?php
// {ALWAYS / NEVER / SOMETIMES} use strict_types
declare(strict_types=1);

namespace App\{Namespace};
```

**Rule**: {Always/Never/Sometimes} use `declare(strict_types=1);`

---

### 2. Import Organization

```php
// This project organizes imports as:

// 1. PHP native classes
use Exception;
use InvalidArgumentException;

// 2. Laravel/Framework classes
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

// 3. App classes - {grouped / individual lines}
use App\Http\Requests\StoreUserRequest;
use App\Models\User;
use App\Services\UserService;
```

**Rules**:
- Grouping: {Braces for same namespace / Individual lines}
- Ordering: {Alphabetical / By type / Framework first}
- Aliases: {When used / Never}

---

### 3. Type Declarations

#### Return Types
```php
// {ALWAYS / SOMETIMES / NEVER} declare return types
public function index(): JsonResponse
public function store(Request $request): User
public function delete(): void
```

#### Property Types
```php
// {ALWAYS / SOMETIMES / NEVER} type properties
private UserService $service;
private string $name;
```

#### Parameter Types
```php
// {ALWAYS / SOMETIMES / NEVER} type parameters
public function find(int $id): ?User
public function search(string $query, int $limit = 10): Collection
```

**Nullable**: `?Type` or `Type|null`
**Union types**: {Used / Not used}

---

### 4. Naming Conventions

| Element | Convention | Example | Anti-pattern |
|---------|------------|---------|--------------|
| **Classes** | PascalCase | `UserController` | `userController` |
| **Methods** | camelCase | `getUserById()` | `get_user_by_id()` |
| **Properties** | camelCase | `$firstName` | `$first_name` |
| **Constants** | UPPER_SNAKE | `MAX_ATTEMPTS` | `maxAttempts` |
| **DB Tables** | snake_case plural | `user_profiles` | `userProfile` |
| **DB Columns** | snake_case | `created_at` | `createdAt` |
| **Routes** | kebab-case | `/user-profiles` | `/userProfiles` |
| **Vue Components** | PascalCase | `UserProfile.vue` | `user-profile.vue` |
| **Composables** | use + camelCase | `useAuth()` | `auth()` |

**Method naming patterns**:
- Getters: `getUser()`, `getName()`
- Booleans: `isActive()`, `hasPermission()`, `canEdit()`
- Actions: `createUser()`, `sendEmail()`
- Queries: `findById()`, `findByEmail()`

---

### 5. Formatting

#### Braces
```php
// Opening braces: {same line / new line}
class UserController extends Controller
{
    public function index(): JsonResponse
    {
```

#### Method Chaining
```php
// Short: inline
$query->where('active', true)->orderBy('name')->get();

// Long: multiline
$query
    ->where('active', true)
    ->where('role', 'admin')
    ->orderBy('created_at', 'desc')
    ->paginate(20);
```

#### Arrays
```php
// Trailing comma: {yes / no}
$config = [
    'key' => 'value',
    'another' => 'value',
];
```

**Line length**: {80 / 120 / no limit}
**Blank lines between methods**: {1 / 2}

---

### 6. Error Handling

```php
// This project handles errors by:
{pattern from codebase}

// Example:
public function find(int $id): User
{
    $user = User::find($id);
    
    if (!$user) {
        throw new ModelNotFoundException("User not found");
        // OR: abort(404);
        // OR: return response()->json(['error' => 'Not found'], 404);
    }
    
    return $user;
}
```

**Custom exceptions**: {Used / Laravel defaults only}
**Logging**: {Always / Critical only}

---

### 7. Documentation

```php
// DocBlocks: {Required for public / Optional / Never}

/**
 * @param int $userId
 * @param array<string, mixed> $data
 * @return User
 * @throws UserNotFoundException
 */
public function updateUser(int $userId, array $data): User
```

**@throws**: {Document / Skip}
**Inline comments**: {When complex / Rarely}

---

## Code Patterns

### Controller Pattern
```php
// From: {actual file}
{actual code showing pattern}
```

**Observations**:
- Controllers are: {thin / fat}
- DI: {Constructor / Method}
- Responses: {Resources / Arrays}

### Service Pattern
```php
// From: {actual file or "Not used"}
{code example}
```

### Model Pattern
```php
// From: {actual file}
{code showing relationships, casts, scopes}
```

### Form Request Pattern
```php
// From: {actual file}
{code example}
```

### API Resource Pattern
```php
// From: {actual file or "Returns arrays directly"}
{code example}
```

---

## Directory Structure

| What | Where |
|------|-------|
| Controllers | `app/Http/Controllers/` |
| API Controllers | `app/Http/Controllers/Api/` |
| Models | `app/Models/` |
| Services | `app/Services/` |
| Form Requests | `app/Http/Requests/` |
| API Resources | `app/Http/Resources/` |
| Tests | `tests/Feature/`, `tests/Unit/` |
| Migrations | `database/migrations/` |

### Frontend
| What | Where |
|------|-------|
| Components | `{path}` |
| Pages | `{path}` |
| Composables | `{path}` |

---

## Testing

### Framework
- **PHP**: {Pest / PHPUnit}
- **JS**: {Vitest / Jest / None}

### Commands
```bash
# All tests
{command}

# Filter
{command} --filter=TestName

# File
{command} tests/Feature/UserTest.php
```

### Test Pattern
```php
// From: {actual file}
{test example showing structure}
```

**Database**: {RefreshDatabase / Transactions}
**Factories**: {Yes / No}

---

## Linting & Quality

### PHP
| Tool | Command | Config |
|------|---------|--------|
| Pint | `./vendor/bin/pint` | `pint.json` |
| PHPStan | `./vendor/bin/phpstan` | Level {X} |

### JavaScript
| Tool | Command | Config |
|------|---------|--------|
| ESLint | `npm run lint` | `.eslintrc.*` |
| Prettier | `npm run format` | `.prettierrc` |

### Pre-commit
```bash
./vendor/bin/pint
./vendor/bin/phpstan analyse
npm run lint
```

---

## Do NOT Touch

<!-- 
Areas requiring extra caution - PRESERVED on /constitution update
-->

---

## Manual Notes

<!-- 
Project-specific knowledge - PRESERVED on /constitution update
-->

---

*Generated by /constitution | Run `/constitution update` to refresh*
```

### Phase 4: Create/Update CLAUDE.md

Create `CLAUDE.md` at project root:

```markdown
# CLAUDE.md

> Project configuration for Claude Code

## Project

- **Name**: {from composer.json/package.json}
- **Stack**: {Laravel + Vue / etc}
- **Constitution**: `.devwork/constitution.md`

For AI coding guidelines, patterns, and conventions:
```
→ See .devwork/constitution.md
```

## Quick Commands

```bash
# Development
{detected command}

# Testing  
{detected command}

# Linting
{detected command}
```

## Project Rules

<!-- Project-specific rules beyond constitution -->

## Active Work

- `.devwork/feature/` - Active features
- `.devwork/hotfix/` - Active hotfixes

Each ticket has `status.md` with progress and "Next Action".

## Do NOT Touch

<!-- Fragile areas - also documented in constitution.md -->
```

### Phase 5: Create Index Files

**`.devwork/decisions/README.md`:**
```markdown
# Architecture Decision Records

| ID | Date | Title | Status | Ticket |
|----|------|-------|--------|--------|
<!-- Added by /graduate -->
```

**`.devwork/specs/README.md`:**
```markdown
# Specifications

| Ticket | Date | Title |
|--------|------|-------|
<!-- Added by /graduate -->
```

### Phase 6: Verify .gitignore

Check both project `.gitignore` and global `~/.gitignore_global`:

```bash
grep -q "^\.devwork/$" .gitignore 2>/dev/null || \
grep -q "^\.devwork/$" ~/.gitignore_global 2>/dev/null
```

If not found, offer to add to project `.gitignore`:

```bash
echo "" >> .gitignore
echo "# Claude Code workflow artifacts" >> .gitignore  
echo ".devwork/" >> .gitignore
```

---

## Output

### Full Setup Output
```
✓ Project constitution generated!

Structure:
└── .devwork/
    ├── constitution.md          ✓ Created
    ├── decisions/README.md      ✓ Created
    ├── specs/README.md          ✓ Created
    ├── feature/                 ✓ Ready
    ├── hotfix/                  ✓ Ready
    └── _archive/                ✓ Ready

└── CLAUDE.md                    ✓ Created

AI Coding Guidelines:
- Strict types: {Always/Never}
- Return types: {Always/Sometimes}
- Import style: {Grouped/Individual}
- Naming: {Documented}
- Error handling: {Documented}

Tech Stack:
- {Laravel X / PHP X}
- {Vue X / Nuxt X}
- {Pest / PHPUnit}
- {Pint / PHPStan}

✓ .devwork/ is gitignored

Ready! Start with: /intake {JIRA-ID} "description"
```

### Update Output
```
✓ Constitution updated!

Changes detected:
- PHP: 8.2 → 8.3
- Laravel: 10.x → 11.x
- Added: spatie/laravel-data

Preserved:
- "Do NOT Touch" section
- "Manual Notes" section

Run `/constitution reset` if you want a fresh start.
```

### Repair Output
```
✓ Structure repaired!

Fixed:
- Created missing: .devwork/specs/
- Created missing: .devwork/specs/README.md

No changes to constitution.md
```

---

## Key Principles

1. **Single entry point** - One command to set up any project
2. **AI-actionable output** - Every guideline directly applicable
3. **Extract real patterns** - From actual code, not assumptions
4. **Preserve manual work** - Update mode keeps your notes
5. **Non-destructive** - Reset backs up before overwriting
