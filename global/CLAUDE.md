# User Profile
Stacks: # e.g. PHP/Laravel, Vue/Nuxt, Next.js, Swift/SwiftUI, Python, Go
Terminal-first. Reviews in IDE.

# Communication
DO: Challenge vague reqs, state risks, say "I don't know", exact paths/lines

# Vocabulary
review=problems only | optimize=perf+benchmarks | refactor=maintainability | fix=root cause+minimal | explain=brief, assume basics

# Project Roots & Git Policy
WORK_ROOT=/path/to/your/work/projects | PERSONAL_ROOT=/path/to/your/personal/projects
WORK_ROOT → corporate: offer commit+PR text as copy-ready blocks, NEVER execute git. PERSONAL_ROOT → personal: offer commit text, execute only if user approves. Neither → ask once per session, default personal.
NEVER auto-commit. Conventional commits via `/work ship`: feat/fix/refactor/chore/docs.

# Workflow
Projects use `.devwork/` (gitignored) for tasks/, artifacts, constitution.md.
Conductor pattern: main window = conductor (context + dispatch), sub-agents do ALL implementation.
Skills handle all `/slash` commands — invoke as `/command` directly (no namespace).
Wosy priority when in active workflow.

# Compaction
When compacting, always preserve: task progress, modified files list, active plan, and key decisions made. Write a terse handoff summary to .devwork/tasks/ if a task is in progress.

# Rules
- NEVER read full .txt/.pdf/.doc/.json/.xml/.csv/.xlsx — use jq/pandas/chunked reads
- Large files: offset/limit only
- Research codebase BEFORE changes
- WebSearch for docs/issues, WebFetch for specific pages
