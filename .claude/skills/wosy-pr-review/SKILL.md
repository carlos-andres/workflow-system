---
name: wosy-pr-review
description: Code review from commit or branch diff — 3-pass analysis, structured report
---

# /pr-review - Code Review from Diff

Read-only. No git operations.

## Parse Input
Empty → show usage, stop. Commit hash (`^[0-9a-f]{7,40}$`) → `git rev-parse --verify <hash>`. Branch → `git rev-parse --verify origin/<branch>` or local. Validation fails → error and stop.

## Gather Diff
Commit: `git show --no-patch --format='%H%n%an%n%ae%n%ad%n%s%n%b' <hash>` + `git diff <hash>~1..<hash>` (merge: use `^1`). Branch: find base via `git merge-base`, then `git diff base...origin/<branch>` + `--stat`. **20+ files**: warn user, ask to continue or scope by path.

## Extract Ticket ID
Search: branch name → commit message → fallback short SHA. Regex: `[A-Z]+-\d+`

## Load Context
`.devwork/constitution.md` for Pass 3 (skip Pass 3 if missing). Read full source of each changed file (deleted=skip, >1000 lines=changed regions +/- 50 lines).

## Three Review Passes
**Pass 1 -- Correctness**: bugs, logic errors, null access, security (SQLi, XSS, auth bypass, secrets), edge cases, error handling, race conditions.
**Pass 2 -- Performance**: N+1 queries, unnecessary loops, repeated DB calls, large uncollected collections, missing indexes, cache invalidation.
**Pass 3 -- Pattern Compliance** (requires constitution.md): naming, layer architecture, type hints, error patterns, API response format. Only rules relevant to changed code.

## Confidence & Output
HIGH → Findings section | MEDIUM → Worth Investigating section | LOW → discard silently. Discard: style prefs, nitpicks, "consider using X", praise.

## Report
Write to `.devwork/reviews/{TICKET}-code-review.md` (append timestamp if exists).
Sections: metadata (commit/author/branch/date/files) → Findings (`{N}. {SEVERITY} -- {Title}` with file:line, issue, recommendation as valid code) → Worth Investigating (file:line + observation) → Pattern Compliance → Impact Summary.

## Console Output
`Review: {TICKET} -- {summary} | Findings: {N} | Worth Investigating: {N}` + one-line per HIGH finding.

## Rules
Only file write: the report. No praise, no LOW noise. Valid code snippets. Specific line numbers.
Severity: CRITICAL (data loss/security) | HIGH (bugs/logic) | MEDIUM (perf/patterns).
