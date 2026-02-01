# /constitution - Project Constitution Generator

Scan project and generate `.devwork/constitution.md` for AI coding agents.

## Usage
```bash
/constitution              # Full scan + generate
/constitution update       # Re-scan, preserve Manual Notes & Do NOT Touch
/constitution reset        # Backup existing, start fresh
/constitution repair       # Fix structure only, no scan
```

---

## Phase 1: Structure

```bash
mkdir -p .devwork/{decisions,specs,feature,hotfix,_archive,_scratch}
```

Create indexes if missing: `decisions/README.md`, `specs/README.md`

Verify gitignore: Check `~/.gitignore_global` first, then `.gitignore` for `.devwork`

---

## Phase 2: Parallel Detection

**Tools:** `fd`, `rg`, `jq`, `bat`, `eza` (from global CLAUDE.md)

Dispatch **6 Task agents** in parallel:

### Task 1: Backend Stack
```bash
# PHP/Laravel
jq -r '{php: .require.php, laravel: .require["laravel/framework"], packages: [.require | keys[] | select(startswith("spatie/") or startswith("laravel/"))]}' composer.json
fd -t f -d 1 "phpunit.xml|pest.php" .
fd -t f -d 1 "pint.json|phpstan.neon|.php-cs-fixer.php|psalm.xml|rector.php" .

# Python (if no composer.json)
jq -r '.dependencies' pyproject.toml 2>/dev/null || head -20 requirements.txt 2>/dev/null

# Node backend (if no composer.json)
jq -r '{node: .engines.node, type: .type}' package.json
```

### Task 2: Frontend Stack
```bash
jq -r '{vue: .dependencies.vue, react: .dependencies.react, nuxt: .dependencies.nuxt, next: .dependencies.next, svelte: .dependencies.svelte, inertia: (.dependencies["@inertiajs/vue3"] // .dependencies["@inertiajs/react"]), typescript: .devDependencies.typescript}' package.json
fd -d 1 -t f "nuxt.config|next.config|vite.config|webpack.config|tailwind.config|tsconfig" .
fd -d 1 -t f "livewire.php" config/
```

### Task 3: Quality Tools
```bash
# Linters & formatters
fd -t f -d 1 "pint.json|phpstan.neon|phpcs.xml|.eslintrc*|.prettierrc*|biome.json|.stylelintrc*"

# Git hooks
fd -t f -d 2 "pre-commit|husky" .husky/ .git/hooks/ 2>/dev/null
jq -r '.["lint-staged"]' package.json 2>/dev/null

# CI/CD
fd -t f "*.yml|*.yaml" .github/workflows/ .gitlab-ci* bitbucket-pipelines* 2>/dev/null
```

### Task 4: Infrastructure
```bash
# Docker
fd -d 1 -t f "docker-compose|compose.yml|Dockerfile" .
rg -l "sail" docker-compose.yml 2>/dev/null && echo "Laravel Sail detected"

# Environment
rg "^(APP_|DB_|CACHE_|QUEUE_|SESSION_|REDIS_|MAIL_|FILESYSTEM_)" .env.example | head -25

# Deployment
fd -d 2 -t f "forge|vapor|envoy|deploy" .
```

### Task 5: External Services
```bash
# From Laravel configs
fd -t f . config/ -d 1 -x basename {} .php | rg -w "stripe|cashier|sentry|bugsnag|horizon|telescope|scout|broadcasting|sanctum|passport|fortify|jetstream"

# From composer
jq -r '.require | keys[]' composer.json | rg -w "stripe|sentry|bugsnag|aws|algolia|meilisearch|pusher"

# From .env
rg "^(STRIPE_|SENTRY_|AWS_|ALGOLIA_|MEILISEARCH_|PUSHER_|SCOUT_)" .env.example
```

### Task 6: Architecture Patterns ⭐
```bash
# Directory structure analysis
fd -t d -d 1 . app/ | sort

# Pattern indicators
fd -t d -d 1 "Services|Repositories|Actions|DTOs|Enums|Contracts|Interfaces|Observers|Policies|Events|Jobs|Listeners|ValueObjects|Aggregates|Commands|Queries|Handlers" app/

# DDD / Modular detection
fd -t d -d 1 "Domain|Modules|Bounded|Core|Infrastructure|Application|Presentation" app/ src/

# Admin panels
fd -t d -d 1 "Nova|Filament|Backpack" app/

# API structure
fd -t d -d 2 "Api|API|V1|V2" app/Http/Controllers/
fd -t f -d 1 "api.php" routes/
```

**Architecture Classification Matrix:**

| Pattern | Indicators |
|---------|------------|
| **Monolith (Laravel standard)** | Flat `app/` with Controllers, Models only |
| **Service Layer** | `app/Services/` with business logic |
| **Repository Pattern** | `app/Repositories/` + Interfaces |
| **Action Pattern** | `app/Actions/` single-purpose classes |
| **DDD/Hexagonal** | `Domain/`, `Infrastructure/`, `Application/` dirs |
| **Modular** | `app/Modules/` or `src/` with bounded contexts |
| **CQRS** | Separate `Commands/` and `Queries/` dirs |
| **Event-Driven** | Heavy use of `Events/`, `Listeners/`, `Jobs/` |

**Detect & Document:**
```bash
# Count pattern usage
echo "Services: $(fd -t f . app/Services 2>/dev/null | wc -l)"
echo "Repositories: $(fd -t f . app/Repositories 2>/dev/null | wc -l)"
echo "Actions: $(fd -t f . app/Actions 2>/dev/null | wc -l)"
echo "Events: $(fd -t f . app/Events 2>/dev/null | wc -l)"
echo "Jobs: $(fd -t f . app/Jobs 2>/dev/null | wc -l)"
```

**Fallback: Unknown/Custom Pattern Discovery**

If no standard pattern matches, run full discovery:

```bash
# Full directory tree (2 levels)
eza -T -L 2 app/ --icons=never

# Find all PHP class types
rg "^class\s+\w+" app/ -l | xargs -I{} dirname {} | sort -u

# Detect custom namespaces
rg "^namespace App\\\\" app/ -o | sort -u | head -20

# Find base/abstract classes (often indicate custom patterns)
rg "abstract class|extends Base|implements \w+Interface" app/ -l | head -10

# Check for Traits usage (custom shared behavior)
fd -t f . app/Traits app/Concerns 2>/dev/null
rg "^use App\\\\(Traits|Concerns)" app/ -o | sort -u
```

**Document as Custom Pattern:**
```markdown
## Architecture

| Aspect | Detection |
|--------|-----------|
| Pattern | **Custom** (see structure below) |

### Project Structure
{eza tree output}

### Custom Namespaces
{list discovered namespaces}

### Key Abstractions
{base classes, interfaces, traits found}

### Notes
{Describe observed organization logic - even if non-standard, document the "why" if apparent}
```

### Task 7: Comment & Documentation Style ⭐
```bash
# PHP: Check for redundant docblocks (typed methods with @param/@return duplicating signature)
rg -l "function \w+\([^)]*\):\s*\w+" app/ | head -10 | xargs -I{} rg -B5 "@param|@return" {} | head -30

# PHP: Find docblocks on typed properties (redundant in PHP 7.4+)
rg -B2 "(private|protected|public)\s+(readonly\s+)?\w+\s+\$" app/ | rg "@var" | head -10

# PHP: Detect PHPStan/Psalm generics (these ARE useful)
rg "@template|@extends|@implements|@phpstan-|@psalm-|array<|Collection<" app/ | head -10

# JS/TS: Check for JSDoc on typed TS functions (often redundant)
rg -B3 "function \w+\(.*\):" --include="*.ts" | rg "@param|@returns" | head -10

# Python: Check for docstrings duplicating type hints
rg -B3 "def \w+\(.*\)\s*->" --include="*.py" | rg '"""' | head -10

# General: Find self-explanatory comments (anti-pattern)
rg "//\s*(increment|set|get|return|loop|iterate|check|if|initialize)" app/ resources/ src/ 2>/dev/null | head -10

# General: Find TODO/FIXME style
rg "(TODO|FIXME|HACK|XXX|NOTE):" app/ resources/ src/ 2>/dev/null | head -5
```

**Comment Philosophy Detection:**
avoid build self explanatory comments, You shouldn't document what the code is doing, but you should document why it's doing it. use best practices from Clean Code

| Pattern | Status | Meaning |
|---------|--------|---------|
| Typed signatures WITHOUT docblocks | ✓ Modern | Self-documenting, clean |
| Typed signatures WITH duplicate @param/@return | ⚠ Redundant | Docblock duplicates type hints |
| Untyped methods WITH docblocks | ✓ Necessary | Legacy or mixed types need docs |
| `@throws` documentation | ✓ Useful | Exceptions not in signature |
| PHPStan/Psalm generics (`@template`, `array<T>`) | ✓ Useful | Types beyond PHP native |
| `// increment i` style comments | ✗ Noise | Self-explanatory, remove |
| `// Why: business rule...` comments | ✓ Useful | Explains intent, not mechanics |

**Sampling for Style:**
```bash
# Sample 5 files to determine project's actual comment philosophy
fd -e php -e ts -e js -e py . app/ src/ resources/ -d 3 | shuf | head -5 | while read f; do
  echo "=== $f ==="
  # Count: typed methods, docblocks, inline comments
  echo "Typed methods: $(rg -c 'function \w+\([^)]*\):\s*\w+' "$f" 2>/dev/null || echo 0)"
  echo "Docblocks: $(rg -c '/\*\*' "$f" 2>/dev/null || echo 0)"
  echo "Inline comments: $(rg -c '^\s*//' "$f" 2>/dev/null || echo 0)"
done
```

---

## Phase 3: Sample Extraction

Dispatch **Explore agent** to sample 5-10 files per category:

```
Explore: Sample files to extract actual patterns (not assumptions):

Controllers (5 files): DI style, response format, thin/fat
Models (5 files): relationships, casts, scopes, traits  
Services (5 files if exist): signatures, returns, exceptions
Tests (5 files): setup pattern, assertions, DB handling
Vue/React (5 files if exist): composition/hooks, props, state

Extract ONLY: method signatures, return types, error patterns.
Skip: business logic, full implementations.
```

---

## Phase 4: Generate Constitution

Output: `.devwork/constitution.md`

```markdown
# Constitution: {PROJECT_NAME}
> Generated: {DATE} | `/constitution update` to refresh

---

## Stack

| Layer | Tech | Version |
|-------|------|---------|
| Language | PHP | {x.x} |
| Framework | Laravel | {x.x} |
| Frontend | {Vue/Nuxt/React/Inertia/Livewire} | {x.x} |
| Build | {Vite/Webpack} | |
| CSS | {Tailwind/Bootstrap} | |
| TypeScript | {Yes (strict)/Yes (loose)/No} | |
| Database | {MySQL/PostgreSQL/SQLite} | |
| Cache | {redis/file/database} | |
| Queue | {redis/database/sync} | |
| Admin | {Nova/Filament/None} | |
| Auth | {Sanctum/Passport/Breeze/Fortify/Custom} | |

---

## Architecture

| Aspect | Detection |
|--------|-----------|
| Pattern | {Monolith/Service Layer/Repository/Action/DDD/Modular/CQRS/**Custom**} |
| API Style | {REST/GraphQL/None} |
| API Versioning | {URI (v1/v2)/Header/None} |

### Active Patterns
{Only list patterns with >0 files}
- Services: {N} files → business logic layer
- Actions: {N} files → single-purpose operations
- Repositories: {N} files → data access abstraction
- Events/Listeners: {N} files → event-driven flows
- Jobs: {N} files → async processing

### Custom Structure (if no standard pattern)
{If Pattern = Custom, include:}
```
app/
├── {discovered directories}
└── {with brief purpose annotation}
```
Key abstractions: {base classes, interfaces, traits}
Organization logic: {describe observed pattern even if non-standard}

### Key Packages
{Packages affecting architecture}
- spatie/laravel-permission
- spatie/laravel-data
- lorisleiva/laravel-actions
- {etc}

---

## Code Rules

### Types
| Rule | Value |
|------|-------|
| `declare(strict_types=1)` | {Always/Never} |
| Return types | {Always/Public only/Never} |
| Property types | {Always/Never} |
| Nullable | {`?Type` / `Type\|null`} |

### Naming
| Element | Convention |
|---------|------------|
| Classes | PascalCase |
| Methods | camelCase |
| Properties | camelCase |
| Constants | UPPER_SNAKE |
| Tables | snake_case_plural |
| Columns | snake_case |
| Routes | kebab-case |
| Vue components | PascalCase |
| Composables | useCamelCase |

### Imports
| Rule | Value |
|------|-------|
| Group style | {braces / individual} |
| Order | {framework → app → alpha} |

### Formatting
| Rule | Value |
|------|-------|
| Braces | {same line / new line} |
| Max line | {120 / none} |
| Trailing commas | {yes / no} |
| Chaining | {inline ≤2 / multiline ≥3} |

### Errors
| Scenario | Pattern |
|----------|---------|
| Not found | {throw / abort() / response()} |
| Validation | {FormRequest / inline} |
| Logging | {always / critical only} |

### Docs & Comments
| Rule | Value |
|------|-------|
| Philosophy | {Self-documenting / Docblock everything / Mixed} |
| Docblocks | {Only when adding value / All public / Never} |
| Redundant @param/@return | {Avoid (types in signature) / Allow} |
| @throws | {Document / Skip} |
| Generics/PHPStan | {Used (@template, array<T>) / Not used} |
| Inline comments | {Why-only / Minimal / Verbose} |
| TODO format | {`// TODO:` / `// @todo` / `# TODO`} |

### Comment Rules
```
✓ DO:
- Explain WHY (business logic, non-obvious decisions)
- Document exceptions (@throws)
- Use generics for static analysis (@template, array<Key, Value>)
- Mark incomplete work (TODO with ticket ref)

✗ AVOID:
- @param/@return duplicating typed signatures
- @var on typed properties (PHP 7.4+)
- "What" comments (// loop through users)
- Restating function name in description
```

---

## Patterns

### Controller
```php
// From: {sampled_path}
public function __construct(private UserService $service) {}
public function show(User $user): JsonResponse {}
```

### Service
```php
// From: {sampled_path} or "Not used"
public function process(array $data): Result {}
```

### Action
```php
// From: {sampled_path} or "Not used"
public function execute(User $user, array $data): Result {}
```

### Repository
```php
// From: {sampled_path} or "Not used"
public function findByEmail(string $email): ?User {}
```

### Model
```php
// From: {sampled_path}
protected $casts = ['settings' => 'array'];
public function posts(): HasMany {}
public function scopeActive(Builder $q): Builder {}
```

### Request
```php
// From: {sampled_path} or "Inline validation used"
public function rules(): array {}
public function authorize(): bool {}
```

### Resource
```php
// From: {sampled_path} or "Array responses used"
public function toArray($request): array {}
```

### Vue Component (if applicable)
```vue
// From: {sampled_path}
<script setup lang="ts">
const props = defineProps<{}>()
const emit = defineEmits<{}>()
</script>
```

### Documentation Style
```php
// ✗ REDUNDANT - signature already typed
/**
 * @param string $email
 * @return User|null
 */
public function findByEmail(string $email): ?User {}

// ✓ GOOD - adds value beyond signature  
/**
 * @throws UserNotFoundException When soft-deleted user accessed
 * @throws RateLimitException After 5 failed attempts in 1 hour
 */
public function findByEmail(string $email): User {}

// ✓ GOOD - generics for static analysis
/** @return Collection<int, User> */
public function getActiveUsers(): Collection {}

// ✓ GOOD - explains WHY, not what
// Rate limit: compliance requirement from SEC audit 2024-Q3
private const MAX_ATTEMPTS = 5;
```

```typescript
// ✗ REDUNDANT - TypeScript already typed
/**
 * @param email - The email address
 * @returns The user or null
 */
function findByEmail(email: string): User | null {}

// ✓ GOOD - self-documenting, no JSDoc needed
function findUserByEmail(email: string): User | null {}

// ✓ GOOD - complex types benefit from docs
/** @throws {AuthError} When token expired or revoked */
async function validateSession(token: string): Promise<Session> {}
```

```python
# ✗ REDUNDANT - type hints sufficient
def find_by_email(email: str) -> User | None:
    """Find user by email.
    
    Args:
        email: The email address
    Returns:
        User or None
    """

# ✓ GOOD - docstring adds context beyond types
def find_by_email(email: str) -> User | None:
    """Raises UserNotFoundError for soft-deleted users."""
```

---

## Database

| Rule | Value |
|------|-------|
| Query style | {Eloquent / Query Builder / Raw} |
| N+1 prevention | {`with()` eager loading} |
| Transactions | {multi-write ops} |
| Soft deletes | {standard / per-model / none} |

---

## Testing

| Item | Value |
|------|-------|
| Framework | {Pest / PHPUnit} |
| DB handling | {RefreshDatabase / Transactions} |
| Factories | {always / when needed} |
| JS tests | {Vitest / Jest / None} |
| E2E | {Playwright / Cypress / Dusk / None} |

```bash
{test_command}                    # all tests
{test_command} --filter=Name      # specific
{test_command} --parallel         # parallel
```

---

## Quality

| Tool | Command | Config |
|------|---------|--------|
| Pint | `./vendor/bin/pint` | pint.json |
| PHPStan | `./vendor/bin/phpstan` | Level {X} |
| ESLint | `npm run lint` | .eslintrc |
| Prettier | `npm run format` | .prettierrc |

```bash
# Pre-commit
{lint_command} && {test_command}
```

---

## Directories

| Purpose | Path |
|---------|------|
| Controllers | app/Http/Controllers/ |
| Models | app/Models/ |
| Services | app/Services/ |
| Actions | app/Actions/ |
| Repositories | app/Repositories/ |
| Requests | app/Http/Requests/ |
| Resources | app/Http/Resources/ |
| Tests | tests/Feature/, tests/Unit/ |
| Components | {frontend path} |

---

## External Services

| Service | Config | Status |
|---------|--------|--------|
| Stripe | config/stripe.php | {✓/✗} |
| AWS S3 | config/filesystems.php | {✓/✗} |
| Redis | config/database.php | {✓/✗} |
| Sentry | config/sentry.php | {✓/✗} |
| Horizon | config/horizon.php | {✓/✗} |
| Scout | config/scout.php | {✓/✗} |

---

## Agent Skills

Based on detected stack:
- {primary framework skill}
- {architecture pattern skill}
- {testing/quality skill}

---

## Do NOT Touch
<!-- Preserved on update -->

## Manual Notes
<!-- Preserved on update -->
```

---

## Phase 5: Create CLAUDE.md Reference

Append or create at project root:

```markdown
# CLAUDE.md

Read first: `.devwork/constitution.md`

## Quick Commands
```bash
{dev_command}
{test_command}  
{lint_command}
```
```

---

## Output

```
✓ Constitution: .devwork/constitution.md

Stack: Laravel {X} / PHP {X} / Vue {X}
Architecture: {Pattern} ({N} services, {N} actions)
Patterns: {N} extracted
Quality: {tools}

Ready: /intake {TICKET} "description"
```

---

## Workflow Integration

Constitution auto-referenced by:
- `/intake` → stack context
- `/plan` → follows patterns
- `/deliver` → runs quality tools
