#!/bin/bash
# Dry-run test for install.sh — runs in isolated temp HOME
# Safe: never touches real ~/.claude/ or git config
# Usage: bash test-install.sh

set +e  # Don't exit on error — we track pass/fail manually

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMP_HOME=""

TOTAL=0
PASSED=0
FAILED=0

#-------------------------------------------------------------------------------
# Dependency check (fail fast before touching anything)
#-------------------------------------------------------------------------------

if ! command -v jq &>/dev/null; then
    echo -e "${RED}ERROR: jq is required but not installed.${NC}"
    echo "  Install with: brew install jq  (macOS) or  apt install jq  (Debian/Ubuntu)"
    exit 1
fi

#-------------------------------------------------------------------------------
# Cleanup
#-------------------------------------------------------------------------------

cleanup() {
    if [ -n "$TEMP_HOME" ] && [ -d "$TEMP_HOME" ]; then
        rm -rf "$TEMP_HOME"
    fi
}
trap cleanup EXIT

#-------------------------------------------------------------------------------
# Check helpers
#-------------------------------------------------------------------------------

pass() {
    echo -e "  ${GREEN}PASS${NC}  $1"
    PASSED=$((PASSED + 1))
    TOTAL=$((TOTAL + 1))
}

fail() {
    echo -e "  ${RED}FAIL${NC}  $1"
    FAILED=$((FAILED + 1))
    TOTAL=$((TOTAL + 1))
}

check_file() {
    local label="$1"
    local path="$2"
    if [ -f "$path" ]; then
        pass "$label"
    else
        fail "$label — not found: $path"
    fi
}

check_executable() {
    local label="$1"
    local path="$2"
    if [ -x "$path" ]; then
        pass "$label"
    else
        fail "$label — not executable: $path"
    fi
}

check_grep() {
    local label="$1"
    local pattern="$2"
    local file="$3"
    if grep -q "$pattern" "$file" 2>/dev/null; then
        pass "$label"
    else
        fail "$label — pattern '$pattern' not found in $file"
    fi
}

#-------------------------------------------------------------------------------
# Setup isolated environment
#-------------------------------------------------------------------------------

echo ""
echo -e "${BOLD}Setting up isolated test environment...${NC}"

TEMP_HOME="$REPO_DIR/.test-sandbox"
mkdir -p "$TEMP_HOME"
TEMP_GIT_CONFIG="$TEMP_HOME/.gitconfig-test"
touch "$TEMP_GIT_CONFIG"

# Minimal git config so git operations inside install.sh don't fail
cat > "$TEMP_GIT_CONFIG" << 'EOF'
[user]
    name = Test User
    email = test@example.com
EOF

export HOME="$TEMP_HOME"
export GIT_CONFIG_GLOBAL="$TEMP_GIT_CONFIG"

echo "  Temp HOME:       $TEMP_HOME"
echo "  Temp git config: $TEMP_GIT_CONFIG"
echo ""

#-------------------------------------------------------------------------------
# Run install.sh
#-------------------------------------------------------------------------------

echo -e "${BOLD}Running install.sh --yes...${NC}"
echo ""

bash "$REPO_DIR/install.sh" --yes > "$TEMP_HOME/install-output.txt" 2>&1
INSTALL_EXIT=$?
sed 's/^/  | /' "$TEMP_HOME/install-output.txt"

if [ "$INSTALL_EXIT" -eq 0 ]; then
    echo ""
    echo -e "  ${GREEN}install.sh exited 0${NC}"
else
    echo ""
    echo -e "  ${RED}install.sh exited $INSTALL_EXIT — aborting tests${NC}"
    exit 1
fi

CLAUDE_DIR="$TEMP_HOME/.claude"

#-------------------------------------------------------------------------------
# Verify: Skills (14)
#-------------------------------------------------------------------------------

echo ""
echo -e "${BOLD}Checking skills (14 expected)...${NC}"

WOSY_SKILLS=(
    wosy-work
    wosy-intake
    wosy-research
    wosy-spec
    wosy-plan
    wosy-dispatch
    wosy-status
    wosy-context
    wosy-phase0
    wosy-pr-review
    wosy-models
)
TOOL_SKILLS=(debugging tdd verify)

for skill in "${WOSY_SKILLS[@]}"; do
    check_file "skill: $skill/SKILL.md" "$CLAUDE_DIR/skills/$skill/SKILL.md"
done

for skill in "${TOOL_SKILLS[@]}"; do
    check_file "skill: $skill/SKILL.md" "$CLAUDE_DIR/skills/$skill/SKILL.md"
done

#-------------------------------------------------------------------------------
# Verify: Agents (2)
#-------------------------------------------------------------------------------

echo ""
echo -e "${BOLD}Checking agents (2 expected)...${NC}"

check_file "agent: code-reviewer.md"    "$CLAUDE_DIR/agents/code-reviewer.md"
check_file "agent: security-auditor.md" "$CLAUDE_DIR/agents/security-auditor.md"

#-------------------------------------------------------------------------------
# Verify: Rules (1)
#-------------------------------------------------------------------------------

echo ""
echo -e "${BOLD}Checking rules (1 expected)...${NC}"

check_file "rule: wosy-conductor.md" "$CLAUDE_DIR/rules/wosy-conductor.md"

#-------------------------------------------------------------------------------
# Verify: Hooks (1) + executable bit
#-------------------------------------------------------------------------------

echo ""
echo -e "${BOLD}Checking hooks (1 expected)...${NC}"

HOOK="$CLAUDE_DIR/hooks/validate-bash.sh"
check_file       "hook: validate-bash.sh exists"        "$HOOK"
check_executable "hook: validate-bash.sh is executable" "$HOOK"

#-------------------------------------------------------------------------------
# Verify: CLAUDE.md
#-------------------------------------------------------------------------------

echo ""
echo -e "${BOLD}Checking CLAUDE.md...${NC}"

check_file "CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"

#-------------------------------------------------------------------------------
# Verify: .devwork/ in global gitignore
#-------------------------------------------------------------------------------

echo ""
echo -e "${BOLD}Checking global gitignore...${NC}"

GITIGNORE="$TEMP_HOME/.gitignore_global"
check_file  "~/.gitignore_global exists"          "$GITIGNORE"
check_grep  ".devwork/ entry in gitignore_global" "^\.devwork/$" "$GITIGNORE"

#-------------------------------------------------------------------------------
# Functional test: validate-bash.sh hook
#-------------------------------------------------------------------------------

echo ""
echo -e "${BOLD}Testing validate-bash.sh hook behavior...${NC}"

# Safe command — expect exit 0
SAFE_JSON='{"tool_input":{"command":"ls -la /tmp"}}'
if echo "$SAFE_JSON" | bash "$HOOK" > /dev/null 2>&1; then
    pass "safe command (ls -la /tmp) → exit 0"
else
    fail "safe command (ls -la /tmp) → expected exit 0, got non-zero"
fi

# Dangerous: rm -rf / — expect exit 2
DANGEROUS_JSON='{"tool_input":{"command":"rm -rf /"}}'
HOOK_EXIT=0
echo "$DANGEROUS_JSON" | bash "$HOOK" > /dev/null 2>&1 || HOOK_EXIT=$?
if [ "$HOOK_EXIT" -eq 2 ]; then
    pass "dangerous command (rm -rf /) → exit 2"
else
    fail "dangerous command (rm -rf /) → expected exit 2, got $HOOK_EXIT"
fi

# Force push — expect exit 2
FORCE_PUSH_JSON='{"tool_input":{"command":"git push --force origin main"}}'
HOOK_EXIT=0
echo "$FORCE_PUSH_JSON" | bash "$HOOK" > /dev/null 2>&1 || HOOK_EXIT=$?
if [ "$HOOK_EXIT" -eq 2 ]; then
    pass "force push (git push --force origin main) → exit 2"
else
    fail "force push (git push --force origin main) → expected exit 2, got $HOOK_EXIT"
fi

#-------------------------------------------------------------------------------
# Summary
#-------------------------------------------------------------------------------

echo ""
echo -e "${BOLD}════════════════════════════════════════${NC}"
echo -e "${BOLD}Summary${NC}"
echo -e "${BOLD}════════════════════════════════════════${NC}"
echo -e "  Total:  $TOTAL"
echo -e "  ${GREEN}Passed: $PASSED${NC}"
if [ "$FAILED" -gt 0 ]; then
    echo -e "  ${RED}Failed: $FAILED${NC}"
else
    echo -e "  Failed: $FAILED"
fi
echo ""

if [ "$FAILED" -eq 0 ]; then
    echo -e "${GREEN}All checks passed.${NC}"
    exit 0
else
    echo -e "${RED}$FAILED check(s) failed.${NC}"
    exit 1
fi
