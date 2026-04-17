#!/bin/bash
# Pre-Bash hook — blocks dangerous commands before execution
# Exit 0 = allow | Exit 2 = block (stderr = message shown to user)

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

[ -z "$COMMAND" ] && exit 0

# Block patterns
case "$COMMAND" in
  *"rm -rf /"*|*"rm -rf ~"*|*"rm -rf \$HOME"*)
    echo "BLOCKED: destructive rm -rf on root/home" >&2; exit 2 ;;
  *"git push --force"*|*"git push -f "*|*"git push origin --force"*)
    echo "BLOCKED: force push — use --force-with-lease instead" >&2; exit 2 ;;
  *"git reset --hard"*)
    echo "BLOCKED: git reset --hard — verify intent, may lose work" >&2; exit 2 ;;
  *"chmod 777"*)
    echo "BLOCKED: chmod 777 — too permissive, use specific permissions" >&2; exit 2 ;;
  *"> /dev/sda"*|*"dd if="*"of=/dev/"*)
    echo "BLOCKED: raw disk write" >&2; exit 2 ;;
  *"curl"*"| bash"*|*"curl"*"| sh"*|*"wget"*"| bash"*|*"wget"*"| sh"*)
    echo "BLOCKED: piping remote script to shell" >&2; exit 2 ;;
esac

exit 0
