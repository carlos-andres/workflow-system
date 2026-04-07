#!/bin/bash

#===============================================================================
# Claude Code Workflow System - Installer v2.0.0
#===============================================================================
#
# This script installs the complete workflow system for Claude Code:
# - Cleans ALL existing custom commands (fresh start)
# - Installs new CLAUDE.md with workflow awareness
# - Installs all slash commands (12 commands, wosy/ namespace)
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
SOURCE_DIR="$SCRIPT_DIR/global"
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

    print_step "Installing CLAUDE.md from source..."
    cp "$SOURCE_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
    print_success "Installed CLAUDE.md"
}

#-------------------------------------------------------------------------------
# Step 4: Install Commands
#-------------------------------------------------------------------------------

install_commands() {
    print_header "Step 4: Installing Workflow Commands"

    # v2.0 command list (12 commands — merged from 16 + conductor/models docs)
    local commands=(
        "work"
        "phase0"
        "intake"
        "research"
        "spec"
        "plan"
        "dispatch"
        "status"
        "context"
        "pr-review"
        "conductor"
        "models"
    )

    # Install wosy/ namespace (single source of truth)
    print_step "Installing wosy/ namespace..."
    mkdir -p "$COMMANDS_DIR/wosy"
    for cmd in "${commands[@]}"; do
        if [ -f "$SOURCE_DIR/commands/wosy/$cmd.md" ]; then
            cp "$SOURCE_DIR/commands/wosy/$cmd.md" "$COMMANDS_DIR/wosy/$cmd.md"
            print_success "Installed /wosy:$cmd"
        else
            print_error "Source file not found: $SOURCE_DIR/commands/wosy/$cmd.md"
        fi
    done
    print_success "Installed ${#commands[@]} commands in wosy/ namespace"
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
    local commands=("work" "phase0" "intake" "research" "spec" "plan" "dispatch" "status" "context" "pr-review" "conductor" "models")
    for cmd in "${commands[@]}"; do
        if [ -f "$COMMANDS_DIR/wosy/$cmd.md" ]; then
            print_success "/wosy:$cmd command installed"
        else
            print_error "/wosy:$cmd command missing"
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
    echo "  ~/.claude/CLAUDE.md                       # Global config (v2.0)"
    echo "  ~/.claude/commands/wosy/work.md            # Smart router + setup + ship"
    echo "  ~/.claude/commands/wosy/phase0.md           # Greenfield discovery"
    echo "  ~/.claude/commands/wosy/intake.md           # Task classification + task records"
    echo "  ~/.claude/commands/wosy/research.md         # Codebase exploration + memory detection"
    echo "  ~/.claude/commands/wosy/spec.md             # Requirements interview"
    echo "  ~/.claude/commands/wosy/plan.md             # Implementation planning + sizing"
    echo "  ~/.claude/commands/wosy/dispatch.md         # Always-on orchestration (XS→XL)"
    echo "  ~/.claude/commands/wosy/status.md           # Progress tracking (task records)"
    echo "  ~/.claude/commands/wosy/context.md          # Context switch resume (memory + records)"
    echo "  ~/.claude/commands/wosy/pr-review.md        # Code review from diff"
    echo "  ~/.claude/commands/wosy/conductor.md        # Conductor pattern documentation"
    echo "  ~/.claude/commands/wosy/models.md           # Memory/task data models"
    echo ""
    echo -e "${YELLOW}What's New in v2.0:${NC}"
    echo ""
    echo "  • /work — Smart router + conductor (replaces 5 merged commands)"
    echo "  • Task Records — Persistent .devwork/tasks/*.md (survive sessions)"
    echo "  • Memory Wiring — Tooling patterns saved to Claude project memory"
    echo "  • Conductor Pattern — Main window orchestrates, agents implement"
    echo "  • Always-On Dispatch — Scales from XS to XL (no more size refusals)"
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
    echo -e "${BLUE}Commands (12 files, sub-commands via /work):${NC}"
    echo "  /work                 - Smart router (auto-detects phase)"
    echo "  /work setup           - Project setup (constitution + project-init)"
    echo "  /work setup update    - Re-scan, preserve manual notes"
    echo "  /work setup reset     - Fresh start (backs up existing)"
    echo "  /work setup repair    - Fix structure issues only"
    echo "  /work ship            - Delivery pipeline (verify → deliver → graduate → archive)"
    echo ""
    echo "  /intake               - Classify task, create workspace + task record"
    echo "  /research             - Explore codebase, detect tooling"
    echo "  /spec                 - Requirements interview"
    echo "  /plan                 - Implementation planning + sizing"
    echo "  /dispatch             - Orchestrate tasks (XS→XL)"
    echo "  /status               - Update progress (task records)"
    echo "  /context              - Resume after context switch"
    echo "  /phase0               - Greenfield discovery"
    echo "  /pr-review            - Code review from diff"
    echo ""

    if [ -f "$CLAUDE_DIR/CLAUDE.md.old" ]; then
        echo -e "${YELLOW}Note:${NC} Your old CLAUDE.md was backed up to CLAUDE.md.old"
    fi
}

#-------------------------------------------------------------------------------
# Main
#-------------------------------------------------------------------------------

main() {
    print_header "Claude Code Workflow System Installer v2.0.0"

    echo "This will:"
    echo "  1. Clean ALL existing commands (fresh start)"
    echo "  2. Install enhanced CLAUDE.md (v2.0)"
    echo "  3. Install 12 workflow commands (wosy/ namespace)"
    echo "  4. Add .devwork/ to global gitignore"
    echo ""
    echo "Merged commands (no longer standalone):"
    echo "  constitution, project-init, rebuild → /work setup"
    echo "  verify, deliver, graduate, archive  → /work ship"
    echo ""

    # Check source files exist
    if [ ! -d "$SOURCE_DIR/commands" ]; then
        print_error "Source directory not found: $SOURCE_DIR/commands"
        print_error "Please run this script from the workflow-system repository root."
        exit 1
    fi

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
