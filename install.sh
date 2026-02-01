#!/bin/bash

#===============================================================================
# Claude Code Workflow System - Installer
#===============================================================================
#
# This script installs the complete workflow system for Claude Code:
# - Cleans ALL existing custom commands (fresh start)
# - Installs new CLAUDE.md with workflow awareness
# - Installs all slash commands
# - Adds .devwork/ to global gitignore
#
# Usage: ./install.sh
#
#===============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Paths
CLAUDE_DIR="$HOME/.claude"
COMMANDS_DIR="$CLAUDE_DIR/commands"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GLOBAL_GITIGNORE="$HOME/.gitignore_global"

#-------------------------------------------------------------------------------
# Helper Functions
#-------------------------------------------------------------------------------

print_header() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
}

print_step() {
    echo -e "${YELLOW}▶ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_info() {
    echo -e "  $1"
}

#-------------------------------------------------------------------------------
# Step 1: Clean Up Existing Commands
#-------------------------------------------------------------------------------

clean_existing() {
    print_header "Step 1: Cleaning Existing Setup"
    
    # Remove all existing commands
    if [ -d "$COMMANDS_DIR" ]; then
        print_step "Removing existing commands..."
        rm -rf "$COMMANDS_DIR"
        print_success "Removed $COMMANDS_DIR"
    else
        print_info "No existing commands directory found"
    fi
    
    # We keep the existing CLAUDE.md as backup reference
    if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
        print_step "Backing up existing CLAUDE.md..."
        mv "$CLAUDE_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md.old"
        print_success "Backed up to CLAUDE.md.old (for reference)"
    fi
    
    # Remove USAGE.md if exists (replaced by workflow)
    if [ -f "$CLAUDE_DIR/USAGE.md" ]; then
        print_step "Removing old USAGE.md..."
        mv "$CLAUDE_DIR/USAGE.md" "$CLAUDE_DIR/USAGE.md.old"
        print_success "Backed up to USAGE.md.old (for reference)"
    fi
}

#-------------------------------------------------------------------------------
# Step 2: Create Directory Structure
#-------------------------------------------------------------------------------

create_structure() {
    print_header "Step 2: Creating Directory Structure"
    
    # Create commands directory
    print_step "Creating commands directory..."
    mkdir -p "$COMMANDS_DIR"
    print_success "Created $COMMANDS_DIR"
}

#-------------------------------------------------------------------------------
# Step 3: Install CLAUDE.md
#-------------------------------------------------------------------------------

install_claude_md() {
    print_header "Step 3: Installing CLAUDE.md"
    
    print_step "Installing enhanced CLAUDE.md..."
    
    cat > "$CLAUDE_DIR/CLAUDE.md" << 'CLAUDE_EOF'
# Claude Code - Senior Full Stack Configuration

## Identity
You are working with a Senior Full Stack Developer.
- Expert in: PHP, Laravel, MySQL, PostgreSQL, Vue, Nuxt, Next.js, Nginx
- Prefers: Terminal-first workflow, direct communication
- Reviews code in IDE, not terminal

## Communication Rules

### DO
- Be terse. One thought per message when possible
- Challenge vague requirements immediately
- State risks and tradeoffs without being asked
- Say "I don't know" when you don't know
- Correct mistakes directly
- Use exact file paths, line numbers, commands

### DON'T
- Preamble: "Great!", "Sure!", "I'll help you with that"
- Explain what you're about to do - just do it
- Summarize what you did - I can see it
- Restate what I said
- Hedge: "maybe", "perhaps", "I think"
- Show full file contents after edits
- Echo code back to me
- Be verbose

## Output After File Operations
- Edits: `Updated src/Http/Controllers/UserController.php: added validation`
- Creates: `Created app/Services/PaymentService.php`
- Errors: Show error + fix. Nothing else.

---

## Workflow System

### Project Setup
Every project should have:
- `CLAUDE.md` at project root → links to `.devwork/constitution.md`
- `.devwork/` folder (gitignored) → all working artifacts

### Workflow Commands
| Command | Phase | Purpose |
|---------|-------|---------|
| `/constitution` | Setup | Scan project, generate tech stack doc |
| `/intake` | Start | Classify task, create workspace |
| `/research` | Discover | Explore codebase, find patterns |
| `/spec` | Define | Requirements interview |
| `/plan` | Design | Implementation approach + tasks |
| `/status` | Track | Update progress |
| `/deliver` | Ship | Generate commit, final check |

### Task Type Routing
```
/intake determines the path:

HOTFIX (urgent production fix):
  → /intake → quick /research → execute → /deliver
  → Light docs: status.md only

FEATURE (clear scope, < 1 day):
  → /intake → /research → /plan → execute → /deliver
  → Full docs except spec.md

FEATURE (unclear scope, complex):
  → /intake → /research → /spec → /plan → execute → /deliver
  → Full docs
```

### Status Tracking
- ALWAYS update `.devwork/{type}/{jira-id}/status.md` after significant changes
- Status tags: `[TODO]`, `[DONE]`, `[BLOCKED]`
- Include "Next Action" so context-switching is easy

### Git Rules
- NEVER auto-commit
- ALWAYS offer conventional commit message via `/deliver`
- Format: `feat:`, `fix:`, `refactor:`, `chore:`, `docs:`

---

## CLI Tool Preferences (Homebrew)

### File & Search
- `fd` instead of `find` - faster, respects .gitignore
- `rg` (ripgrep) instead of `grep` - faster, better defaults
- `eza` instead of `ls` - better formatting, git integration
- `bat` instead of `cat` - syntax highlighting (display only)

### JSON & Data
- `jq` for JSON processing
- `fzf` for fuzzy finding

### Git
- `delta` for diffs (default pager)
- `difft` for code review: `GIT_EXTERNAL_DIFF=difft git diff`

---

## Testing Rules

### By Task Type
| Task Type | Test Behavior |
|-----------|---------------|
| NEW FEATURE | Ask what tests to run |
| BUG FIX | Run tests matching changed class/method |
| REFACTOR | Run both unit + integration tests |

### Test Commands
- Check `composer.json` for PHP test framework (PHPUnit/Pest)
- Check `package.json` for JS test framework (Vitest/Jest)
- Use appropriate filter: `--filter=ClassName`, `--filter=methodName`, or path

### Quality Tools (run before /deliver)
- PHP: `./vendor/bin/pint` (Laravel Pint)
- PHP: `./vendor/bin/phpstan analyse` (if configured)
- PHP: `./vendor/bin/phpcs` (if configured)
- JS: `npm run lint` or `npx eslint`

---

## Large File Handling
NEVER read these file types fully into context:
- Documents: `.txt`, `.pdf`, `.doc`, `.docx`
- Data: `.json`, `.xml`, `.csv`, `.xlsx`

Instead:
- Use `jq` to extract specific fields from JSON
- Use Python script with pandas for CSV/Excel
- Use chunked reading with offset/limit

---

## Stack-Specific Rules

### Laravel
- Eloquent over raw SQL
- Watch for N+1 queries
- Use Form Requests for validation
- Use Resources for API responses
- Services for business logic
- Repository pattern for data access

### Database
- Always check EXPLAIN plans for complex queries
- Suggest indexes when appropriate
- Use transactions for multi-step operations
- Flag potential lock issues

### Frontend (Vue/Nuxt)
- Composition API with `<script setup>`
- TypeScript strict mode
- SSR-aware code
- Minimize bundle size

---

## Research
- Use WebSearch for: docs lookup, GitHub issues, Stack Overflow
- Use WebFetch for: specific documentation pages, API references
- Always research codebase BEFORE making changes

---

## When I Say...
- "review" → Find problems only, no praise
- "optimize" → Performance focus, show benchmarks if possible
- "refactor" → Maintainability focus, preserve behavior
- "fix" → Root cause + minimal fix
- "explain" → Brief, assume I understand basics
CLAUDE_EOF
    
    print_success "Installed CLAUDE.md"
}

#-------------------------------------------------------------------------------
# Step 4: Install Commands
#-------------------------------------------------------------------------------

install_commands() {
    print_header "Step 4: Installing Workflow Commands"
    
    # /constitution
    print_step "Installing /constitution..."
    cat > "$COMMANDS_DIR/constitution.md" << 'CMD_EOF'
# /constitution - Project Setup & AI Coding Guidelines

The **single entry point** for setting up any project with Claude Code.

## Usage

```bash
/constitution              # Full setup (first time)
/constitution update       # Re-scan, preserve manual notes
/constitution reset        # Fresh start (backs up existing)
/constitution repair       # Fix structure issues only
```

## What It Does (Full Setup)

1. Creates `.devwork/` directory structure
2. Creates `decisions/README.md` and `specs/README.md` indexes
3. Scans project deeply (tech stack, patterns, conventions)
4. Generates `.devwork/constitution.md` (AI coding guidelines)
5. Creates/updates project `CLAUDE.md`
6. Verifies `.devwork/` is gitignored

## Structure Created

```
project/
├── CLAUDE.md                    # References constitution
└── .devwork/
    ├── constitution.md          # AI coding guidelines
    ├── decisions/README.md      # ADR index
    ├── specs/README.md          # Spec index
    ├── feature/                 # Active features
    ├── hotfix/                  # Active hotfixes
    ├── _archive/                # Completed work
    └── _scratch/                # Temp notes
```

## Constitution Contains

- **Tech Stack**: PHP, Laravel, Vue versions, etc.
- **AI Coding Guidelines**:
  - Strict types rules
  - Import organization
  - Type declarations
  - Naming conventions
  - Formatting rules
  - Error handling patterns
  - Documentation style
- **Code Patterns**: Controller, Service, Model examples
- **Directory Structure**: Where to put things
- **Testing**: Framework and commands
- **Linting**: Tools and configs

## Flags

- `update`: Re-scan, preserves "Do NOT Touch" and "Manual Notes"
- `reset`: Backs up existing, starts fresh
- `repair`: Fix missing directories only, no scanning
CMD_EOF
    print_success "Installed /constitution"

    # /intake
    print_step "Installing /intake..."
    cat > "$COMMANDS_DIR/intake.md" << 'CMD_EOF'
# /intake - Task Intake & Workspace Setup

Classify the task and create the working environment.

## Usage
```
/intake {JIRA-ID} "{brief description}"
```

## Instructions

1. **Ask task type**: Hotfix | Bugfix | Feature | Refactor

2. **For Feature/Refactor, ask scope**: Clear (skip /spec) | Unclear (full workflow)

3. **Create workspace**:
   - Hotfix: `.devwork/hotfix/{jira-id}/status.md`
   - Others: `.devwork/feature/{jira-id}/` with README.md, status.md, research.md, spec.md, plan.md, tasks.md, adr.md

4. **Initialize status.md** with:
   - Task info (type, date, scope)
   - Current state: "Just started"
   - Tasks checklist with [TODO] tags
   - Next Action: "Run /research"
   - Session Log with creation entry

5. **Output**:
   ```
   ✓ Workspace created: .devwork/{type}/{jira-id}/
   
   Next steps based on task type...
   ```
CMD_EOF
    print_success "Installed /intake"

    # /research
    print_step "Installing /research..."
    cat > "$COMMANDS_DIR/research.md" << 'CMD_EOF'
# /research - Codebase Exploration

Explore the codebase before making changes.

## Prerequisites
- Run `/intake` first
- Read `.devwork/constitution.md` if exists

## Instructions

1. **Load context** from status.md and constitution.md

2. **Search codebase** using `rg` and `fd` for:
   - Similar functionality and patterns
   - Related files (controllers, models, services, tests)
   - Conventions (imports, naming, error handling)
   - Dependencies and potential conflicts

3. **Document in `.devwork/{type}/{jira-id}/research.md`**:
   - Files to modify and reference
   - Patterns to follow (with code examples)
   - Conventions detected
   - Risks and considerations
   - Existing tests

4. **Update status.md**: Mark research done, set next action

5. **Output summary**:
   ```
   ✓ Research complete
   
   Key findings:
   - Pattern to follow: {pattern}
   - Files to modify: {count}
   - Risks: {brief}
   
   Next: /spec or /plan
   ```
CMD_EOF
    print_success "Installed /research"

    # /spec
    print_step "Installing /spec..."
    cat > "$COMMANDS_DIR/spec.md" << 'CMD_EOF'
# /spec - Requirements Interview

Clarify requirements through structured interview.

## Prerequisites
- Run `/intake` and `/research` first

## Instructions

1. **Load context** from status.md and research.md

2. **Interview in categories** (2-3 questions at a time):
   - Core functionality (what, who, trigger, output)
   - Edge cases (empty input, permissions, failures)
   - Data & validation (required fields, rules, limits)
   - Error handling (messages, atomicity, logging)
   - Performance (scale, caching, timeouts)
   - Integration (other features, APIs, frontend)
   - Acceptance criteria (how to verify done)

3. **Document in `.devwork/{type}/{jira-id}/spec.md`**:
   - Overview and user stories
   - Functional requirements (input/output)
   - Edge cases table
   - Error handling table
   - Non-functional requirements
   - Acceptance criteria checkboxes
   - Out of scope items

4. **Update status.md and README.md**

5. **Output**:
   ```
   ✓ Specification complete
   
   Summary:
   - Requirements: {count}
   - Edge cases: {count}
   - Acceptance criteria: {count}
   
   Ready for /plan
   ```
CMD_EOF
    print_success "Installed /spec"

    # /plan
    print_step "Installing /plan..."
    cat > "$COMMANDS_DIR/plan.md" << 'CMD_EOF'
# /plan - Implementation Planning

Design implementation approach and create task breakdown.

## Prerequisites
- Run `/intake` and `/research` first
- Run `/spec` if requirements were unclear

## Instructions

1. **Load context** from all existing docs + constitution.md

2. **Design approach** considering:
   - Patterns from research.md
   - Conventions from constitution.md
   - Dependencies and order
   - Testing strategy

3. **Create `.devwork/{type}/{jira-id}/plan.md`**:
   - Approach summary
   - Architecture (components, data flow, diagram)
   - Files to create/modify
   - Implementation phases with checkpoints
   - Technical decisions (document significant ones in adr.md)
   - Testing strategy
   - Risks and mitigations
   - Estimated effort

4. **Generate `.devwork/{type}/{jira-id}/tasks.md`**:
   - Checklist organized by phase
   - Each task is checkable `- [ ]`
   - Checkpoint verification after each phase
   - Progress tracking section

5. **Update status.md**: Mark plan done, set next action to Phase 1

6. **Output**:
   ```
   ✓ Plan complete
   ✓ Tasks generated
   
   Phases: {count}
   Tasks: {count}
   Estimated: {time}
   
   Ready to implement. Start with Phase 1.
   ```
CMD_EOF
    print_success "Installed /plan"

    # /status
    print_step "Installing /status..."
    cat > "$COMMANDS_DIR/status.md" << 'CMD_EOF'
# /status - Progress Update

Update status file with current progress.

## Usage
```
/status                           # Interactive update
/status "completed validation"    # Quick update
/status blocked "waiting on API"  # Mark blocked
/status check                     # View only, no update
```

## Instructions

1. **Load current** `.devwork/{type}/{jira-id}/status.md`

2. **Determine update**:
   - If message provided: mark related task [DONE] or [BLOCKED]
   - If no message: ask "What did you accomplish?"

3. **Update status.md**:
   - Current State description
   - Tasks with updated tags
   - Clear "Next Action" for context-switching
   - Session Log entry with date and accomplishment

4. **Update tasks.md**: Check off completed items

5. **Output**:
   ```
   ✓ Status updated
   
   Done: {what was marked done}
   Next: {next action}
   Progress: {n}/{total} tasks
   ```

## Key Rule
Always write a specific "Next Action" so future-you knows exactly where to pick up.
CMD_EOF
    print_success "Installed /status"

    # /deliver
    print_step "Installing /deliver..."
    cat > "$COMMANDS_DIR/deliver.md" << 'CMD_EOF'
# /deliver - Delivery Preparation

Final verification and commit message generation. NEVER auto-commits.

## Usage
```
/deliver
```

## Instructions

1. **Run verification checklist** (ask to confirm):
   - Linting passes (pint, phpstan, eslint)
   - No debug code left
   - Tests pass
   - Acceptance criteria met
   - ADR updated if decisions made

2. **Generate conventional commit message**:
   ```
   {type}({scope}): {description}
   
   {body - what and why}
   
   Closes {JIRA-ID}
   ```
   
   Types: feat, fix, refactor, chore, docs, test

3. **Show summary**:
   - Files changed
   - Commit message
   - Git commands to run

4. **Update status.md**: Mark as DELIVERED

5. **Offer archive**: Move to `.devwork/_archive/`

## Key Rules
- NEVER run git commit automatically
- ALWAYS show commit message for review
- ALWAYS let user execute the commit
CMD_EOF
    print_success "Installed /deliver"

    # /graduate
    print_step "Installing /graduate..."
    cat > "$COMMANDS_DIR/graduate.md" << 'CMD_EOF'
# /graduate - Promote Artifacts to Shareable Location

Move finalized working artifacts from ticket folders to project-wide directories.

## Usage
```
/graduate                # Interactive
/graduate spec           # Graduate current ticket's spec
/graduate adr            # Graduate current ticket's ADR(s)
/graduate all            # Graduate all from current ticket
```

## Purpose

**Working artifacts** (drafts, in-progress):
```
.devwork/feature/nt-0001/
├── spec.md              # Working draft
└── adr/
    └── 001-choice.md    # Working decision
```

**Graduated artifacts** (final, shareable):
```
.devwork/
├── specs/
│   └── nt-0001-feature-name.md    # Final spec
└── decisions/
    └── 0001-choice.md             # Final ADR (numbered)
```

## When to Graduate

- **ADRs**: Significant architectural decisions
- **Specs**: Major features others might reference
- **Skip**: Hotfixes, minor bugfixes, research notes

## Integration

`/deliver` will prompt for graduation before archiving.
CMD_EOF
    print_success "Installed /graduate"
}

#-------------------------------------------------------------------------------
# Step 5: Configure Global Gitignore
#-------------------------------------------------------------------------------

configure_gitignore() {
    print_header "Step 5: Configuring Global Gitignore"
    
    # Check if .devwork/ is already in global gitignore
    if [ -f "$GLOBAL_GITIGNORE" ]; then
        if grep -q "^\.devwork/$" "$GLOBAL_GITIGNORE" 2>/dev/null; then
            print_info ".devwork/ already in global gitignore"
            return
        fi
    fi
    
    # Add .devwork/ to global gitignore
    print_step "Adding .devwork/ to global gitignore..."
    echo "" >> "$GLOBAL_GITIGNORE"
    echo "# Claude Code workflow artifacts" >> "$GLOBAL_GITIGNORE"
    echo ".devwork/" >> "$GLOBAL_GITIGNORE"
    print_success "Added .devwork/ to $GLOBAL_GITIGNORE"
    
    # Ensure git is configured to use global gitignore
    print_step "Configuring git to use global gitignore..."
    git config --global core.excludesfile "$GLOBAL_GITIGNORE"
    print_success "Git configured to use global gitignore"
}

#-------------------------------------------------------------------------------
# Step 6: Verify Installation
#-------------------------------------------------------------------------------

verify_installation() {
    print_header "Step 6: Verifying Installation"
    
    local errors=0
    
    # Check CLAUDE.md
    if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
        print_success "CLAUDE.md installed"
    else
        print_error "CLAUDE.md missing"
        ((errors++))
    fi
    
    # Check commands
    local commands=("constitution" "intake" "research" "spec" "plan" "status" "deliver" "graduate")
    for cmd in "${commands[@]}"; do
        if [ -f "$COMMANDS_DIR/$cmd.md" ]; then
            print_success "/$cmd command installed"
        else
            print_error "/$cmd command missing"
            ((errors++))
        fi
    done
    
    # Check gitignore
    if grep -q "^\.devwork/$" "$GLOBAL_GITIGNORE" 2>/dev/null; then
        print_success ".devwork/ in global gitignore"
    else
        print_error ".devwork/ not in global gitignore"
        ((errors++))
    fi
    
    return $errors
}

#-------------------------------------------------------------------------------
# Step 7: Print Summary
#-------------------------------------------------------------------------------

print_summary() {
    print_header "Installation Complete!"
    
    echo -e "Installed to: ${GREEN}$CLAUDE_DIR${NC}"
    echo ""
    echo "Files created:"
    echo "  ~/.claude/CLAUDE.md              # Global config"
    echo "  ~/.claude/commands/constitution.md"
    echo "  ~/.claude/commands/intake.md"
    echo "  ~/.claude/commands/research.md"
    echo "  ~/.claude/commands/spec.md"
    echo "  ~/.claude/commands/plan.md"
    echo "  ~/.claude/commands/status.md"
    echo "  ~/.claude/commands/deliver.md"
    echo "  ~/.claude/commands/graduate.md"
    echo ""
    echo -e "${YELLOW}Quick Start:${NC}"
    echo ""
    echo "  1. Open a project in Claude Code"
    echo ""
    echo "  2. Run the single setup command:"
    echo "     /constitution"
    echo ""
    echo "  3. Start a new task:"
    echo "     /intake JIRA-123 \"Add user authentication\""
    echo ""
    echo "  4. Follow the workflow:"
    echo "     /research → /spec (if needed) → /plan → implement → /status → /deliver → /graduate"
    echo ""
    echo -e "${BLUE}Commands:${NC}"
    echo "  /constitution        - Full project setup + AI coding guidelines"
    echo "  /constitution update - Re-scan, preserve manual notes"
    echo "  /constitution reset  - Fresh start (backs up existing)"
    echo "  /constitution repair - Fix structure issues only"
    echo ""
    echo "  /intake        - Classify task, create workspace"
    echo "  /research      - Explore codebase"
    echo "  /spec          - Requirements interview"
    echo "  /plan          - Implementation planning"
    echo "  /status        - Update progress"
    echo "  /deliver       - Final check, commit message"
    echo "  /graduate      - Promote artifacts to shareable location"
    echo ""
    
    if [ -f "$CLAUDE_DIR/CLAUDE.md.old" ]; then
        echo -e "${YELLOW}Note:${NC} Your old CLAUDE.md was backed up to CLAUDE.md.old"
    fi
}

#-------------------------------------------------------------------------------
# Main
#-------------------------------------------------------------------------------

main() {
    print_header "Claude Code Workflow System Installer"
    
    echo "This will:"
    echo "  1. Clean ALL existing commands (fresh start)"
    echo "  2. Install enhanced CLAUDE.md"
    echo "  3. Install workflow commands"
    echo "  4. Add .devwork/ to global gitignore"
    echo ""
    
    read -p "Continue? (y/n) " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
    
    clean_existing
    create_structure
    install_claude_md
    install_commands
    configure_gitignore
    
    if verify_installation; then
        print_summary
    else
        print_error "Installation completed with errors. Please check above."
        exit 1
    fi
}

main "$@"
