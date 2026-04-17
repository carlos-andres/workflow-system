#!/bin/bash

#===============================================================================
# Claude Code Workflow System - Installer v3.0.0
#===============================================================================
#
# This script installs the complete Wosy workflow system for Claude Code:
# - 14 skills (11 wosy + 3 tool skills)
# - 2 agents (code-reviewer, security-auditor)
# - 1 rule (wosy-conductor)
# - hooks (validate-bash.sh)
# - Global CLAUDE.md (unless --preserve)
# - .devwork/ in global gitignore
#
# Usage: ./install.sh [--preserve]
#
# Flags:
#   --preserve    Skip overwriting ~/.claude/CLAUDE.md (user guardrail)
#
#===============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Paths
CLAUDE_DIR="$HOME/.claude"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_SKILLS="$SCRIPT_DIR/.claude/skills"
SOURCE_AGENTS="$SCRIPT_DIR/.claude/agents"
SOURCE_RULES="$SCRIPT_DIR/.claude/rules"
SOURCE_HOOKS="$SCRIPT_DIR/.claude/hooks"
SOURCE_CLAUDE_MD="$SCRIPT_DIR/global/CLAUDE.md"
GLOBAL_GITIGNORE="$HOME/.gitignore_global"

# Counters
SKILLS_INSTALLED=0
AGENTS_INSTALLED=0
RULES_INSTALLED=0
HOOKS_INSTALLED=0
CLAUDE_MD_INSTALLED=0

# Flags
PRESERVE_CLAUDE_MD=false
AUTO_YES=false

#-------------------------------------------------------------------------------
# Parse Arguments
#-------------------------------------------------------------------------------

for arg in "$@"; do
    case "$arg" in
        --preserve)
            PRESERVE_CLAUDE_MD=true
            ;;
        --yes|-y)
            AUTO_YES=true
            ;;
        --help|-h)
            echo "Usage: ./install.sh [--preserve] [--yes]"
            echo ""
            echo "Flags:"
            echo "  --preserve    Skip overwriting ~/.claude/CLAUDE.md"
            echo "  --yes, -y     Skip confirmation prompts"
            exit 0
            ;;
        *)
            echo "Unknown flag: $arg"
            echo "Usage: ./install.sh [--preserve]"
            exit 1
            ;;
    esac
done

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
# Step 1: Preflight Checks
#-------------------------------------------------------------------------------

preflight() {
    print_header "Step 1: Preflight Checks"

    # Check source directories exist
    local missing=0

    if [ ! -d "$SOURCE_SKILLS" ]; then
        print_error "Skills source not found: $SOURCE_SKILLS"
        missing=$((missing + 1))
    else
        print_success "Skills source found"
    fi

    if [ ! -d "$SOURCE_AGENTS" ]; then
        print_error "Agents source not found: $SOURCE_AGENTS"
        missing=$((missing + 1))
    else
        print_success "Agents source found"
    fi

    if [ ! -d "$SOURCE_RULES" ]; then
        print_error "Rules source not found: $SOURCE_RULES"
        missing=$((missing + 1))
    else
        print_success "Rules source found"
    fi

    if [ ! -d "$SOURCE_HOOKS" ]; then
        print_error "Hooks source not found: $SOURCE_HOOKS"
        missing=$((missing + 1))
    else
        print_success "Hooks source found"
    fi

    if [ ! -f "$SOURCE_CLAUDE_MD" ]; then
        print_error "CLAUDE.md source not found: $SOURCE_CLAUDE_MD"
        missing=$((missing + 1))
    else
        print_success "CLAUDE.md source found"
    fi

    if [ "$missing" -gt 0 ]; then
        print_error "Missing source files. Run this script from the workflow-system repo root."
        exit 1
    fi

    if [ "$PRESERVE_CLAUDE_MD" = true ]; then
        print_info "--preserve flag set: CLAUDE.md will not be overwritten"
    fi
}

#-------------------------------------------------------------------------------
# Step 2: Backup Existing Files
#-------------------------------------------------------------------------------

backup_existing() {
    print_header "Step 2: Backing Up Existing Files"

    local backed_up=0

    # Backup CLAUDE.md (unless --preserve, where we just skip entirely)
    if [ "$PRESERVE_CLAUDE_MD" = false ] && [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
        print_step "Backing up CLAUDE.md..."
        /bin/cp "$CLAUDE_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md.bak"
        print_success "CLAUDE.md -> CLAUDE.md.bak"
        ((backed_up++))
    fi

    # Backup existing wosy-* skill directories
    for skill_dir in "$CLAUDE_DIR"/skills/wosy-*; do
        if [ -d "$skill_dir" ]; then
            local name=$(basename "$skill_dir")
            print_step "Backing up skill $name..."
            /bin/cp -R "$skill_dir" "${skill_dir}.bak"
            print_success "$name -> ${name}.bak"
            backed_up=$((backed_up + 1))
        fi
    done

    # Backup existing tool skill directories (debugging, tdd, verify)
    for tool_skill in debugging tdd verify; do
        if [ -d "$CLAUDE_DIR/skills/$tool_skill" ]; then
            print_step "Backing up skill $tool_skill..."
            /bin/cp -R "$CLAUDE_DIR/skills/$tool_skill" "$CLAUDE_DIR/skills/${tool_skill}.bak"
            print_success "$tool_skill -> ${tool_skill}.bak"
            backed_up=$((backed_up + 1))
        fi
    done

    # Backup existing agent files
    for agent_file in "$CLAUDE_DIR"/agents/*.md; do
        if [ -f "$agent_file" ]; then
            local name=$(basename "$agent_file")
            print_step "Backing up agent $name..."
            /bin/cp "$agent_file" "${agent_file}.bak"
            print_success "$name -> ${name}.bak"
            backed_up=$((backed_up + 1))
        fi
    done

    # Backup existing wosy rule files
    for rule_file in "$CLAUDE_DIR"/rules/wosy-*.md; do
        if [ -f "$rule_file" ]; then
            local name=$(basename "$rule_file")
            print_step "Backing up rule $name..."
            /bin/cp "$rule_file" "${rule_file}.bak"
            print_success "$name -> ${name}.bak"
            backed_up=$((backed_up + 1))
        fi
    done

    # Backup existing hook files
    for hook_file in "$CLAUDE_DIR"/hooks/*.sh; do
        if [ -f "$hook_file" ]; then
            local name=$(basename "$hook_file")
            print_step "Backing up hook $name..."
            /bin/cp "$hook_file" "${hook_file}.bak"
            print_success "$name -> ${name}.bak"
            backed_up=$((backed_up + 1))
        fi
    done

    if [ "$backed_up" -eq 0 ]; then
        print_info "No existing files to back up (fresh install)"
    else
        print_success "Backed up $backed_up items"
    fi
}

#-------------------------------------------------------------------------------
# Step 3: Create Directory Structure
#-------------------------------------------------------------------------------

create_structure() {
    print_header "Step 3: Creating Directory Structure"

    mkdir -p "$CLAUDE_DIR/skills"
    print_success "~/.claude/skills/"

    mkdir -p "$CLAUDE_DIR/agents"
    print_success "~/.claude/agents/"

    mkdir -p "$CLAUDE_DIR/rules"
    print_success "~/.claude/rules/"

    mkdir -p "$CLAUDE_DIR/hooks"
    print_success "~/.claude/hooks/"
}

#-------------------------------------------------------------------------------
# Step 4: Install Skills
#-------------------------------------------------------------------------------

install_skills() {
    print_header "Step 4: Installing Skills (14)"

    # Wosy skills (11)
    local wosy_skills=(
        "wosy-work"
        "wosy-intake"
        "wosy-research"
        "wosy-spec"
        "wosy-plan"
        "wosy-dispatch"
        "wosy-status"
        "wosy-context"
        "wosy-phase0"
        "wosy-pr-review"
        "wosy-models"
    )

    print_step "Installing wosy skills..."
    for skill in "${wosy_skills[@]}"; do
        if [ -d "$SOURCE_SKILLS/$skill" ]; then
            mkdir -p "$CLAUDE_DIR/skills/$skill"
            /bin/cp -R "$SOURCE_SKILLS/$skill/." "$CLAUDE_DIR/skills/$skill/"
            print_success "  $skill"
            SKILLS_INSTALLED=$((SKILLS_INSTALLED + 1))
        else
            print_error "  $skill — source not found: $SOURCE_SKILLS/$skill"
        fi
    done

    # Tool skills (3)
    local tool_skills=(
        "debugging"
        "tdd"
        "verify"
    )

    print_step "Installing tool skills..."
    for skill in "${tool_skills[@]}"; do
        if [ -d "$SOURCE_SKILLS/$skill" ]; then
            mkdir -p "$CLAUDE_DIR/skills/$skill"
            /bin/cp -R "$SOURCE_SKILLS/$skill/." "$CLAUDE_DIR/skills/$skill/"
            print_success "  $skill"
            SKILLS_INSTALLED=$((SKILLS_INSTALLED + 1))
        else
            print_error "  $skill — source not found: $SOURCE_SKILLS/$skill"
        fi
    done

    print_success "Installed $SKILLS_INSTALLED skills"
}

#-------------------------------------------------------------------------------
# Step 5: Install Agents
#-------------------------------------------------------------------------------

install_agents() {
    print_header "Step 5: Installing Agents (2)"

    local agents=(
        "code-reviewer.md"
        "security-auditor.md"
    )

    for agent in "${agents[@]}"; do
        if [ -f "$SOURCE_AGENTS/$agent" ]; then
            /bin/cp "$SOURCE_AGENTS/$agent" "$CLAUDE_DIR/agents/$agent"
            print_success "  $agent"
            AGENTS_INSTALLED=$((AGENTS_INSTALLED + 1))
        else
            print_error "  $agent — source not found: $SOURCE_AGENTS/$agent"
        fi
    done

    print_success "Installed $AGENTS_INSTALLED agents"
}

#-------------------------------------------------------------------------------
# Step 6: Install Rules
#-------------------------------------------------------------------------------

install_rules() {
    print_header "Step 6: Installing Rules (1)"

    local rules=(
        "wosy-conductor.md"
    )

    for rule in "${rules[@]}"; do
        if [ -f "$SOURCE_RULES/$rule" ]; then
            /bin/cp "$SOURCE_RULES/$rule" "$CLAUDE_DIR/rules/$rule"
            print_success "  $rule"
            RULES_INSTALLED=$((RULES_INSTALLED + 1))
        else
            print_error "  $rule — source not found: $SOURCE_RULES/$rule"
        fi
    done

    print_success "Installed $RULES_INSTALLED rules"
}

#-------------------------------------------------------------------------------
# Step 6b: Install Hooks
#-------------------------------------------------------------------------------

install_hooks() {
    print_header "Step 6b: Installing Hooks"

    for hook_file in "$SOURCE_HOOKS"/*.sh; do
        if [ -f "$hook_file" ]; then
            local name=$(basename "$hook_file")
            /bin/cp "$hook_file" "$CLAUDE_DIR/hooks/$name"
            chmod +x "$CLAUDE_DIR/hooks/$name"
            print_success "  $name"
            HOOKS_INSTALLED=$((HOOKS_INSTALLED + 1))
        fi
    done

    if [ "$HOOKS_INSTALLED" -eq 0 ]; then
        print_info "No hook scripts found in source"
    else
        print_success "Installed $HOOKS_INSTALLED hooks"
    fi
}

#-------------------------------------------------------------------------------
# Step 7: Install CLAUDE.md
#-------------------------------------------------------------------------------

install_claude_md() {
    print_header "Step 7: Installing CLAUDE.md"

    if [ "$PRESERVE_CLAUDE_MD" = true ]; then
        print_info "Skipped — --preserve flag is set"
        print_info "Your existing CLAUDE.md was not modified"
        return
    fi

    /bin/cp "$SOURCE_CLAUDE_MD" "$CLAUDE_DIR/CLAUDE.md"
    CLAUDE_MD_INSTALLED=1
    print_success "Installed CLAUDE.md"
}

#-------------------------------------------------------------------------------
# Step 8: Configure Global Gitignore
#-------------------------------------------------------------------------------

configure_gitignore() {
    print_header "Step 8: Configuring Global Gitignore"

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
# Step 9: Offer to Remove Legacy Commands
#-------------------------------------------------------------------------------

remove_legacy_commands() {
    print_header "Step 9: Legacy Cleanup"

    local legacy_dir="$CLAUDE_DIR/commands/wosy"

    if [ -d "$legacy_dir" ]; then
        print_step "Found legacy commands directory: ~/.claude/commands/wosy/"
        print_info "v3.0 uses skills instead of commands. The old commands are no longer needed."
        echo ""
        if [ "$AUTO_YES" = false ]; then
            read -p "  Remove ~/.claude/commands/wosy/? (y/n) " -n 1 -r
            echo ""
        else
            REPLY=y
        fi

        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$legacy_dir"
            print_success "Removed legacy commands directory"

            # Clean up empty commands/ parent if nothing else is in it
            if [ -d "$CLAUDE_DIR/commands" ] && [ -z "$(ls -A "$CLAUDE_DIR/commands" 2>/dev/null)" ]; then
                rmdir "$CLAUDE_DIR/commands"
                print_success "Removed empty commands/ directory"
            fi
        else
            print_info "Kept legacy commands (you can remove them manually later)"
        fi
    else
        print_info "No legacy commands found — nothing to clean up"
    fi
}

#-------------------------------------------------------------------------------
# Step 10: Verify Installation
#-------------------------------------------------------------------------------

verify_installation() {
    print_header "Step 10: Verifying Installation"

    local errors=0

    # Check skills
    local all_skills=(
        "wosy-work" "wosy-intake" "wosy-research" "wosy-spec" "wosy-plan"
        "wosy-dispatch" "wosy-status" "wosy-context" "wosy-phase0"
        "wosy-pr-review" "wosy-models"
        "debugging" "tdd" "verify"
    )

    for skill in "${all_skills[@]}"; do
        if [ -f "$CLAUDE_DIR/skills/$skill/SKILL.md" ]; then
            print_success "skill: $skill"
        else
            print_error "skill: $skill — MISSING"
            errors=$((errors + 1))
        fi
    done

    # Check agents
    for agent in "code-reviewer.md" "security-auditor.md"; do
        if [ -f "$CLAUDE_DIR/agents/$agent" ]; then
            print_success "agent: $agent"
        else
            print_error "agent: $agent — MISSING"
            errors=$((errors + 1))
        fi
    done

    # Check rules
    if [ -f "$CLAUDE_DIR/rules/wosy-conductor.md" ]; then
        print_success "rule: wosy-conductor.md"
    else
        print_error "rule: wosy-conductor.md — MISSING"
        ((errors++))
    fi

    # Check hooks
    for hook_file in "$SOURCE_HOOKS"/*.sh; do
        if [ -f "$hook_file" ]; then
            local name=$(basename "$hook_file")
            if [ -f "$CLAUDE_DIR/hooks/$name" ]; then
                print_success "hook: $name"
            else
                print_error "hook: $name — MISSING"
                errors=$((errors + 1))
            fi
        fi
    done

    # Check CLAUDE.md (only if we installed it)
    if [ "$PRESERVE_CLAUDE_MD" = false ]; then
        if [ -f "$CLAUDE_DIR/CLAUDE.md" ]; then
            print_success "CLAUDE.md"
        else
            print_error "CLAUDE.md — MISSING"
            errors=$((errors + 1))
        fi
    fi

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
# Step 11: Print Summary
#-------------------------------------------------------------------------------

print_summary() {
    print_header "Installation Complete — Wosy v3.0.0"

    echo -e "Installed to: ${GREEN}$CLAUDE_DIR${NC}"
    echo ""
    echo -e "${BOLD}Installed:${NC}"
    echo "  $SKILLS_INSTALLED skills   (11 wosy + 3 tool)"
    echo "  $AGENTS_INSTALLED agents    (code-reviewer, security-auditor)"
    echo "  $RULES_INSTALLED rule      (wosy-conductor)"
    echo "  $HOOKS_INSTALLED hooks    (validate-bash)"
    if [ "$CLAUDE_MD_INSTALLED" -eq 1 ]; then
        echo "  1 CLAUDE.md (global config)"
    fi
    echo ""

    echo -e "${BOLD}Skills installed:${NC}"
    echo "  wosy-work        Smart router + setup + ship"
    echo "  wosy-intake      Task classification + workspace"
    echo "  wosy-research    Codebase exploration + memory"
    echo "  wosy-spec        Requirements interview"
    echo "  wosy-plan        Implementation planning + sizing"
    echo "  wosy-dispatch    Task orchestration (XS-XL)"
    echo "  wosy-status      Progress tracking (task records)"
    echo "  wosy-context     Resume after context switch"
    echo "  wosy-phase0      Greenfield discovery"
    echo "  wosy-pr-review   Code review from diff"
    echo "  wosy-models      Memory/task data models"
    echo "  debugging        Systematic debugging"
    echo "  tdd              Test-driven development"
    echo "  verify           Pre-completion verification"
    echo ""

    echo -e "${YELLOW}What's New in v3.0:${NC}"
    echo ""
    echo "  * Skills replace commands — richer context, auto-triggered"
    echo "  * Agents — code-reviewer and security-auditor for /review workflows"
    echo "  * Rules — wosy-conductor enforces conductor discipline automatically"
    echo "  * Tool skills — debugging, tdd, verify available in every project"
    echo "  * Hooks — validate-bash.sh blocks dangerous commands pre-execution"
    echo "  * Cleaner ~/.claude — no more commands/ directory"
    echo ""

    echo -e "${YELLOW}Quick Start:${NC}"
    echo ""
    echo "  1. Open a project in Claude Code"
    echo ""
    echo "  2. Run the setup command:"
    echo "     /work setup"
    echo ""
    echo "  3. Start a new task:"
    echo "     /intake AUTH-001 \"Add user authentication\""
    echo ""
    echo "  4. Let the smart router guide you:"
    echo "     /work"
    echo ""

    if [ "$PRESERVE_CLAUDE_MD" = true ]; then
        echo -e "${CYAN}Note:${NC} CLAUDE.md was not modified (--preserve flag)."
        echo "  The template is available at: $SOURCE_CLAUDE_MD"
        echo ""
    elif [ "$CLAUDE_MD_INSTALLED" -eq 1 ]; then
        echo -e "${CYAN}Action required:${NC} Update WORK_ROOT and PERSONAL_ROOT in ~/.claude/CLAUDE.md"
        echo "  to match your local directory structure."
        echo ""
    fi

    if [ -f "$CLAUDE_DIR/CLAUDE.md.bak" ]; then
        echo -e "${CYAN}Note:${NC} Your previous CLAUDE.md was backed up to ~/.claude/CLAUDE.md.bak"
        echo ""
    fi
}

#-------------------------------------------------------------------------------
# Main
#-------------------------------------------------------------------------------

main() {
    print_header "Claude Code Workflow System Installer v3.0.0"

    echo "This will install:"
    echo "  - 14 skills   (11 wosy workflow + 3 tool skills)"
    echo "  - 2 agents    (code-reviewer, security-auditor)"
    echo "  - 1 rule      (wosy-conductor)"
    echo "  - hooks     (validate-bash.sh)"
    if [ "$PRESERVE_CLAUDE_MD" = false ]; then
        echo "  - CLAUDE.md   (global config)"
    else
        echo "  - CLAUDE.md   (SKIPPED — --preserve flag)"
    fi
    echo "  - .devwork/   added to global gitignore"
    echo ""
    echo "Existing files will be backed up before overwriting."
    echo ""

    if [ "$AUTO_YES" = false ]; then
        read -p "Continue? (y/n) " -n 1 -r
        echo ""
    else
        REPLY=y
    fi

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi

    preflight
    backup_existing
    create_structure
    install_skills
    install_agents
    install_rules
    install_hooks
    install_claude_md
    configure_gitignore
    remove_legacy_commands

    if verify_installation; then
        print_summary
    else
        echo ""
        print_error "Installation completed with errors. Check the output above."
        exit 1
    fi
}

main "$@"
