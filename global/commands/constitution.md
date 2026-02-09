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

## Phase 0: Pre-flight — Read Phase 0 Docs & README

**Before scanning code, check if Phase 0 documentation exists.** This is critical for greenfield projects where no code exists yet.

```bash
# Check for Phase 0 artifacts
ls -la .devwork/_scratch/phase0/ 2>/dev/null
ls -la README.md 2>/dev/null
```

**If `.devwork/_scratch/phase0/` exists**, read documents **in this order**:

1. `README.md` (project root) — consolidated overview, primary source of truth
2. `.devwork/_scratch/phase0/01-idea.md` — vision, problem, users, scope
3. `.devwork/_scratch/phase0/02-discovery.md` — interview findings, resolved questions
4. `.devwork/_scratch/phase0/03-decisions.md` — all architectural decisions (DEC-XXX) and rules
5. `.devwork/_scratch/phase0/04-specs.md` — UI specs, components, features, settings, parsing rules
6. `.devwork/_scratch/phase0/05-backlog.md` — deferred items + edge cases (EC-XXX)
7. `.devwork/_scratch/phase0/06-build-roadmap.md` — phased build sequence with dependencies

**How Phase 0 docs feed into Constitution:**

| Phase 0 Source | Constitution Section | What to Extract |
|---------------|---------------------|-----------------|
| README.md Tech Stack | → Stack table | Languages, frameworks, versions |
| 03-decisions.md | → Code Rules, Architecture | Decisions that become rules |
| 04-specs.md | → Patterns, Directories | Component structure, data models |
| 06-build-roadmap.md | → Agent Skills, Testing | Build phases, test strategy |
| 01-idea.md rules | → Do NOT Touch | Project constraints (RULE-XXX) |
| 05-backlog.md edge cases | → Manual Notes | Known edge cases to track |

**If Phase 0 exists but NO code exists yet:**
- Skip Phase 2 detection tasks that scan code (they'll find nothing)
- Skip Phase 3 sample extraction (no files to sample)
- Generate constitution from Phase 0 docs + README only
- Mark detected sections as `(from Phase 0 — no code yet)`
- On next `/constitution update` (after code exists), detection tasks run and enrich

**If both Phase 0 docs AND code exist:**
- Read Phase 0 docs first for context
- Run all detection tasks normally
- Cross-reference: Phase 0 decisions should align with detected patterns
- Flag any conflicts: "DEC-003 says SwiftUI but detected React" (if mismatch)

**If no Phase 0 docs exist:**
- Skip this phase entirely, proceed to Phase 1 as normal

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

### Step 2.0: Identify Project Stack

**Run first — determines which detection tasks to dispatch.**

```bash
# Detect project type by manifest files
ls Package.swift 2>/dev/null && echo "SWIFT_SPM"
ls *.xcodeproj 2>/dev/null && echo "XCODE"
ls *.xcworkspace 2>/dev/null && echo "XCODE_WORKSPACE"
ls composer.json 2>/dev/null && echo "PHP"
ls package.json 2>/dev/null && echo "NODE"
ls pyproject.toml requirements.txt 2>/dev/null && echo "PYTHON"
ls Cargo.toml 2>/dev/null && echo "RUST"
ls go.mod 2>/dev/null && echo "GO"
ls Gemfile 2>/dev/null && echo "RUBY"
ls build.gradle* pom.xml 2>/dev/null && echo "JVM"
ls pubspec.yaml 2>/dev/null && echo "DART_FLUTTER"

# Detect primary language by file count
echo "=== File counts ==="
echo "Swift: $(fd -e swift -t f | wc -l)"
echo "PHP: $(fd -e php -t f | wc -l)"
echo "TypeScript: $(fd -e ts -e tsx -t f | wc -l)"
echo "JavaScript: $(fd -e js -e jsx -t f | wc -l)"
echo "Python: $(fd -e py -t f | wc -l)"
echo "Rust: $(fd -e rs -t f | wc -l)"
echo "Go: $(fd -e go -t f | wc -l)"
echo "Ruby: $(fd -e rb -t f | wc -l)"
echo "Java/Kotlin: $(fd -e java -e kt -t f | wc -l)"
echo "Dart: $(fd -e dart -t f | wc -l)"
```

**Stack Classification:**

| Detected | Stack Profile | Detection Tasks to Run |
|----------|--------------|----------------------|
| `XCODE` or `SWIFT_SPM` | Apple (Swift/SwiftUI/UIKit) | Apple + Quality + Infra + Architecture |
| `PHP` + `composer.json` | PHP/Laravel | PHP + Frontend + Quality + Infra + Services + Architecture |
| `NODE` only | Node/Web | Node + Frontend + Quality + Infra + Services + Architecture |
| `PYTHON` | Python | Python + Quality + Infra + Architecture |
| `RUST` | Rust | Rust + Quality + Infra + Architecture |
| `GO` | Go | Go + Quality + Infra + Architecture |
| `DART_FLUTTER` | Flutter/Dart | Flutter + Quality + Infra + Architecture |
| Multiple manifests | Polyglot | Run all relevant detection tasks |

**Based on detected stack, dispatch the relevant Task agents in parallel from the sections below.**

---

### Task: Apple Stack (Swift/SwiftUI/Xcode)
```bash
# Swift version & project type
swift --version 2>/dev/null
xcodebuild -version 2>/dev/null

# SwiftUI vs UIKit vs AppKit
rg "import SwiftUI" -l | head -5 && echo "SwiftUI detected"
rg "import UIKit" -l | head -5 && echo "UIKit detected"
rg "import AppKit" -l | head -5 && echo "AppKit detected"

# Platform targets
rg "platforms:" Package.swift 2>/dev/null
fd -d 1 -t f "*.plist" | head -5
rg "MACOSX_DEPLOYMENT_TARGET|IPHONEOS_DEPLOYMENT_TARGET" *.pbxproj 2>/dev/null | head -5

# Package dependencies (SPM)
rg "\.package\(url:" Package.swift 2>/dev/null
# CocoaPods
ls Podfile 2>/dev/null && head -30 Podfile

# Architecture patterns
fd -t d -d 2 "Models|Views|ViewModels|Services|Managers|Coordinators|Protocols|Extensions|Utils|Helpers|Networking" .
echo "MVVM: $(fd -t d "ViewModels|ViewModel" | wc -l)"
echo "Coordinators: $(fd -t d "Coordinators|Coordinator" | wc -l)"
echo "Services: $(fd -t d "Services" | wc -l)"

# Testing
fd -t f "*.swift" -p "Test|Spec" | head -5
rg "import XCTest|import Testing|@testable import" -l | head -5
fd -d 1 -t d "*Tests" .

# Data persistence
rg "import CoreData|import SwiftData|import RealmSwift|import GRDB|import SQLite" -l | head -5

# Combine / async-await
rg "import Combine|@Published|@Observable|async func|await " -l | head -10
```

**Apple Architecture Classification:**

| Pattern | Indicators |
|---------|------------|
| **MVVM** | `ViewModels/` dir, `@Observable`/`@Published` |
| **MVC** | No ViewModels, logic in controllers |
| **VIPER** | `Router/`, `Presenter/`, `Interactor/` dirs |
| **TCA (Composable)** | `import ComposableArchitecture`, `Reducer` |
| **Coordinator** | `Coordinators/` dir, navigation protocols |
| **Clean Architecture** | `Domain/`, `Data/`, `Presentation/` layers |

---

### Task: PHP/Laravel Stack
```bash
# PHP/Laravel
jq -r '{php: .require.php, laravel: .require["laravel/framework"], packages: [.require | keys[] | select(startswith("spatie/") or startswith("laravel/"))]}' composer.json
fd -t f -d 1 "phpunit.xml|pest.php" .
fd -t f -d 1 "pint.json|phpstan.neon|.php-cs-fixer.php|psalm.xml|rector.php" .

# Architecture
fd -t d -d 1 . app/ | sort
fd -t d -d 1 "Services|Repositories|Actions|DTOs|Enums|Contracts|Interfaces|Observers|Policies|Events|Jobs|Listeners|ValueObjects|Aggregates|Commands|Queries|Handlers" app/
fd -t d -d 1 "Domain|Modules|Bounded|Core|Infrastructure|Application|Presentation" app/ src/
fd -t d -d 1 "Nova|Filament|Backpack" app/
fd -t d -d 2 "Api|API|V1|V2" app/Http/Controllers/

# Count patterns
echo "Services: $(fd -t f . app/Services 2>/dev/null | wc -l)"
echo "Repositories: $(fd -t f . app/Repositories 2>/dev/null | wc -l)"
echo "Actions: $(fd -t f . app/Actions 2>/dev/null | wc -l)"
echo "Events: $(fd -t f . app/Events 2>/dev/null | wc -l)"
echo "Jobs: $(fd -t f . app/Jobs 2>/dev/null | wc -l)"

# External services
fd -t f . config/ -d 1 -x basename {} .php | rg -w "stripe|cashier|sentry|bugsnag|horizon|telescope|scout|broadcasting|sanctum|passport|fortify|jetstream"
jq -r '.require | keys[]' composer.json | rg -w "stripe|sentry|bugsnag|aws|algolia|meilisearch|pusher"
```

**Laravel Architecture Classification:**

| Pattern | Indicators |
|---------|------------|
| **Monolith (standard)** | Flat `app/` with Controllers, Models only |
| **Service Layer** | `app/Services/` with business logic |
| **Repository Pattern** | `app/Repositories/` + Interfaces |
| **Action Pattern** | `app/Actions/` single-purpose classes |
| **DDD/Hexagonal** | `Domain/`, `Infrastructure/`, `Application/` dirs |
| **Modular** | `app/Modules/` or `src/` with bounded contexts |
| **CQRS** | Separate `Commands/` and `Queries/` dirs |
| **Event-Driven** | Heavy use of `Events/`, `Listeners/`, `Jobs/` |

---

### Task: Node/Frontend Stack
```bash
# Package detection
jq -r '{vue: .dependencies.vue, react: .dependencies.react, nuxt: .dependencies.nuxt, next: .dependencies.next, svelte: .dependencies.svelte, angular: .dependencies["@angular/core"], inertia: (.dependencies["@inertiajs/vue3"] // .dependencies["@inertiajs/react"]), typescript: .devDependencies.typescript, node: .engines.node, type: .type}' package.json

# Config files
fd -d 1 -t f "nuxt.config|next.config|vite.config|webpack.config|tailwind.config|tsconfig|angular.json|svelte.config" .

# Monorepo detection
ls pnpm-workspace.yaml lerna.json turbo.json nx.json 2>/dev/null
jq -r '.workspaces' package.json 2>/dev/null
```

---

### Task: Python Stack
```bash
# Framework detection
rg "django|flask|fastapi|starlette|celery|sqlalchemy|pydantic" pyproject.toml requirements.txt 2>/dev/null | head -15
ls manage.py 2>/dev/null && echo "Django detected"

# Project structure
eza -T -L 2 --icons=never src/ app/ 2>/dev/null

# Testing
fd -t f "conftest.py|pytest.ini|setup.cfg" -d 2
rg "pytest|unittest|nose" pyproject.toml 2>/dev/null
```

---

### Task: Rust Stack
```bash
# Cargo analysis
rg "^\[dependencies\]" -A 30 Cargo.toml | head -35
rg "edition|name|version" Cargo.toml | head -5

# Framework detection
rg "actix-web|axum|rocket|tokio|serde|clap" Cargo.toml | head -10

# Workspace
rg "^\[workspace\]" Cargo.toml && rg "members" Cargo.toml
```

---

### Task: Go Stack
```bash
# Module info
head -5 go.mod
rg "require" go.mod | head -15

# Framework detection
rg "gin-gonic|echo|fiber|chi|gorilla" go.mod | head -5
```

---

### Task: Quality Tools (All Stacks)
```bash
# Universal linters & formatters
fd -t f -d 1 ".editorconfig|.prettierrc*|.eslintrc*|biome.json|.stylelintrc*|.swiftlint.yml|.swiftformat|rustfmt.toml|.golangci.yml|.flake8|.ruff.toml|pyproject.toml|pint.json|phpstan.neon|phpcs.xml"

# Git hooks
fd -t f -d 2 "pre-commit|husky" .husky/ .git/hooks/ 2>/dev/null
jq -r '.["lint-staged"]' package.json 2>/dev/null
ls .pre-commit-config.yaml 2>/dev/null

# CI/CD
fd -t f "*.yml|*.yaml" .github/workflows/ 2>/dev/null | head -10
ls .gitlab-ci.yml bitbucket-pipelines.yml Jenkinsfile .circleci/config.yml 2>/dev/null
ls Makefile Taskfile.yml justfile 2>/dev/null
```

---

### Task: Infrastructure (All Stacks)
```bash
# Docker
fd -d 1 -t f "docker-compose*|compose.yml|compose.yaml|Dockerfile" .

# Environment
fd -d 1 -t f ".env*" . | head -10

# Deployment
fd -d 2 -t f "Procfile|fly.toml|vercel.json|netlify.toml|railway.json|render.yaml" .
ls Fastfile Appfile 2>/dev/null && echo "Fastlane detected"
fd -d 2 -t f "*.xcconfig" . | head -5
```

---

### Task: Comment & Documentation Style (All Stacks)

```bash
# Detect based on primary language
# Swift
rg "/// " -l | head -5 && echo "Swift doc comments found"
rg "// MARK:" -l | head -5 && echo "MARK sections found"

# PHP
rg -l "function \w+\([^)]*\):\s*\w+" app/ 2>/dev/null | head -10 | xargs -I{} rg -B5 "@param|@return" {} 2>/dev/null | head -30
rg "@template|@extends|@implements|@phpstan-|@psalm-|array<|Collection<" app/ 2>/dev/null | head -10

# TypeScript/JavaScript
rg -B3 "function \w+\(.*\):" --include="*.ts" 2>/dev/null | rg "@param|@returns" | head -10

# Python
rg -B3 "def \w+\(.*\)\s*->" --include="*.py" 2>/dev/null | rg '"""' | head -10

# Rust
rg "^///" --include="*.rs" -l | head -5

# General: self-explanatory comments (anti-pattern) & TODOs
rg "//\s*(increment|set|get|return|loop|iterate|check|if|initialize)" 2>/dev/null | head -10
rg "(TODO|FIXME|HACK|XXX|NOTE):" 2>/dev/null | head -5
```

**Comment Philosophy Detection (language-agnostic):**

| Pattern | Status | Meaning |
|---------|--------|---------|
| Typed signatures WITHOUT doc comments | ✓ Modern | Self-documenting, clean |
| Typed signatures WITH duplicate param docs | ⚠ Redundant | Docs duplicate type info |
| `@throws` / error documentation | ✓ Useful | Exceptions/errors not in signature |
| Static analysis annotations | ✓ Useful | Types beyond language native |
| `// increment i` style comments | ✗ Noise | Self-explanatory, remove |
| `// Why: business rule...` comments | ✓ Useful | Explains intent, not mechanics |

**Sampling for Style:**
```bash
# Sample 5 files from primary language to determine comment philosophy
PRIMARY_EXT=$(fd -t f -e swift -e php -e ts -e js -e py -e rs -e go | head -1 | rg -o '\.\w+$')
fd -t f -e "${PRIMARY_EXT#.}" -d 3 | shuf | head -5 | while read f; do
  echo "=== $f ==="
  echo "Doc comments: $(rg -c '///|/\*\*|"""' "$f" 2>/dev/null || echo 0)"
  echo "Inline comments: $(rg -c '^\s*//' "$f" 2>/dev/null || echo 0)"
done
```

---

### Fallback: Unknown/Custom Pattern Discovery

If no standard pattern matches for any stack:

```bash
# Full directory tree (2 levels)
eza -T -L 2 --icons=never

# Find all class/struct/module types
rg "^(class|struct|enum|protocol|interface|trait|module|object)\s+\w+" -l | xargs -I{} dirname {} | sort -u

# Find base/abstract types (often indicate custom patterns)
rg "abstract class|protocol \w+|trait \w+|interface \w+" -l | head -10
```

---

## Phase 3: Sample Extraction

Dispatch **Explore agent** to sample 5-10 files per category **based on detected stack**:

```
Explore: Sample files to extract actual patterns (not assumptions).
Adapt categories to the detected stack:

Apple/Swift:
  Views (5 files): SwiftUI vs UIKit, view composition, property wrappers
  ViewModels (5 files): @Observable, data flow, async patterns
  Models (5 files): Codable, persistence, relationships
  Services (5 files if exist): network layer, data access, business logic
  Tests (5 files): XCTest vs Swift Testing, async tests, mocks

PHP/Laravel:
  Controllers (5 files): DI style, response format, thin/fat
  Models (5 files): relationships, casts, scopes, traits
  Services (5 files if exist): signatures, returns, exceptions
  Tests (5 files): setup pattern, assertions, DB handling
  Vue/React (5 files if exist): composition/hooks, props, state

Node/Web:
  Components (5 files): framework patterns, state, props
  API routes/handlers (5 files): validation, responses, middleware
  Utils/Services (5 files): shared logic patterns
  Tests (5 files): test runner, mocks, assertions

Python:
  Views/Routes (5 files): framework patterns, validation
  Models (5 files): ORM patterns, serialization
  Services (5 files): business logic, typing
  Tests (5 files): fixtures, assertions

Rust/Go:
  Handlers (5 files): error handling, types
  Models/Types (5 files): structs, traits/interfaces
  Tests (5 files): test patterns, mocks

Extract ONLY: method signatures, return types, error patterns, naming conventions.
Skip: business logic, full implementations.
```

---

## Phase 4: Generate Constitution

Output: `.devwork/constitution.md`

**The template adapts to the detected stack.** Include only sections relevant to the project. Do not include empty sections.

```markdown
# Constitution: {PROJECT_NAME}
> Generated: {DATE} | `/constitution update` to refresh

---

## Stack

| Layer | Tech | Version |
|-------|------|---------|
{Rows generated dynamically based on detected stack. Examples:}

{For Apple:}
| Language | Swift | {x.x} |
| Framework | SwiftUI | |
| Platform | macOS | {15.0+} |
| IDE | Xcode | {x.x} |
| Package Manager | SPM | |
| Persistence | {SwiftData/CoreData/None} | |

{For PHP/Laravel:}
| Language | PHP | {x.x} |
| Framework | Laravel | {x.x} |
| Frontend | {Vue/Nuxt/React/Inertia/Livewire} | {x.x} |
| Build | {Vite/Webpack} | |
| CSS | {Tailwind/Bootstrap} | |
| TypeScript | {Yes (strict)/Yes (loose)/No} | |
| Database | {MySQL/PostgreSQL/SQLite} | |
| Cache | {redis/file/database} | |
| Queue | {redis/database/sync} | |

{For Node/Web:}
| Runtime | Node.js | {x.x} |
| Framework | {Next.js/Nuxt/Express/Fastify} | {x.x} |
| Language | {TypeScript/JavaScript} | |
| Build | {Vite/Webpack/Turbopack} | |
| CSS | {Tailwind/styled-components} | |

{For Python:}
| Language | Python | {x.x} |
| Framework | {Django/FastAPI/Flask} | {x.x} |
| ORM | {Django ORM/SQLAlchemy/None} | |
| Async | {asyncio/celery/None} | |

{For Rust:}
| Language | Rust | {edition} |
| Framework | {Axum/Actix/Rocket/None} | |
| Async runtime | {Tokio/async-std} | |

---

## Architecture

| Aspect | Detection |
|--------|-----------|
| Pattern | {detected pattern} |
| API Style | {REST/GraphQL/gRPC/None/N/A} |

### Active Patterns
{Only list patterns with >0 files, adapted to stack}

### Project Structure
```
{eza tree output or planned directory structure from Phase 0}
```

### Key Dependencies
{Packages/crates/gems/pods affecting architecture}

---

## Code Rules

### Types & Safety
{Adapted to language:}

{Swift:}
| Rule | Value |
|------|-------|
| Access control | {explicit / default internal} |
| Optionals | {guard let / if let / forced unwrap policy} |
| Error handling | {throws / Result / async throws} |
| Concurrency | {async/await / Combine / GCD} |

{PHP:}
| Rule | Value |
|------|-------|
| `declare(strict_types=1)` | {Always/Never} |
| Return types | {Always/Public only/Never} |
| Property types | {Always/Never} |
| Nullable | {`?Type` / `Type\|null`} |

{TypeScript:}
| Rule | Value |
|------|-------|
| Strict mode | {Yes/No} |
| `any` usage | {Forbidden/Discouraged/Allowed} |
| Null handling | {strict null checks / optional chaining} |

### Naming
{Universal structure, fill based on language conventions:}
| Element | Convention |
|---------|------------|
| Types/Classes | {PascalCase} |
| Functions/Methods | {camelCase / snake_case} |
| Variables/Properties | {camelCase / snake_case} |
| Constants | {UPPER_SNAKE / camelCase} |
| Files | {PascalCase / kebab-case / snake_case} |
{Add language-specific rows as needed}

### Formatting
| Rule | Value |
|------|-------|
| Indentation | {spaces/tabs, count} |
| Max line | {120 / none} |
| Trailing commas | {yes / no} |
| Braces | {same line / new line} |

### Error Handling
| Scenario | Pattern |
|----------|---------|
{Adapted to language — throw, Result, abort(), try/except, etc.}

### Docs & Comments
| Rule | Value |
|------|-------|
| Philosophy | {Self-documenting / Doc everything / Mixed} |
| When to document | {Only when adding value beyond types} |
| Inline comments | {Why-only / Minimal} |
| TODO format | {`// TODO:` / `// FIXME:` / `# TODO`} |

### Comment Rules
```
✓ DO:
- Explain WHY (business logic, non-obvious decisions)
- Document thrown errors/exceptions
- Use type annotations for static analysis when language types insufficient
- Mark incomplete work (TODO with ticket/context ref)

✗ AVOID:
- Docs duplicating type signatures
- "What" comments (// loop through users)
- Restating function name in description
```

---

## Patterns

{Sample code blocks from Phase 3, in the project's actual language.}
{Include 3-5 key patterns detected. Example headers:}

### {Pattern Name} (e.g., ViewModel, Controller, Service, Handler)
```{language}
// From: {sampled_path}
{minimal signature example}
```

### Documentation Style
{Show good vs bad examples in the project's language}

---

## Database / Persistence
{Only if applicable}

| Rule | Value |
|------|-------|
{Adapted: Eloquent, CoreData, SQLAlchemy, Prisma, SwiftData, etc.}

---

## Testing

| Item | Value |
|------|-------|
| Framework | {XCTest / Swift Testing / Pest / PHPUnit / Vitest / Jest / pytest / cargo test} |
| Pattern | {describe, it / test functions / XCTestCase} |
{Add stack-specific rows}

```bash
{test_command}                    # all tests
{test_command_filtered}           # specific
```

---

## Quality

| Tool | Command | Config |
|------|---------|--------|
{Detected tools — SwiftLint, Pint, ESLint, rustfmt, black, etc.}

```bash
# Pre-commit
{lint_command} && {test_command}
```

---

## Directories

| Purpose | Path |
|---------|------|
{Detected or planned directory structure}

---

## External Services / Integrations
{Only if applicable — list detected services with config status}

| Service | Config | Status |
|---------|--------|--------|
{Detected services}

---

## Agent Skills

Based on detected stack:
- {primary framework/language skill}
- {architecture pattern skill}
- {testing/quality skill}

---

## Do NOT Touch
<!-- Preserved on update -->
{RULE-XXX from Phase 0 if applicable}

## Manual Notes
<!-- Preserved on update -->
{Edge cases from Phase 0 backlog if applicable}
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

Stack: {Language} {X} / {Framework} {X}
Architecture: {Pattern}
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

### Phase 0 → Constitution Flow
```
/phase0 "idea"
  └── Generates: README.md + .devwork/_scratch/phase0/ (6 docs)

/constitution
  ├── Reads Phase 0 docs in order (01→06)
  ├── Reads README.md
  ├── Detects stack (Step 2.0)
  ├── Runs stack-specific detection tasks
  ├── Skips code detection if no code exists
  ├── Generates constitution from Phase 0 context + detected patterns
  └── On future `/constitution update`: enriches with real code patterns
```
