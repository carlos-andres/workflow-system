> **DEPRECATED (v3.0)** — Legacy v2.0 command file kept for reference only.  
> Active version: `~/.claude/skills/wosy-pr-review/SKILL.md`  
> See [CHANGELOG.md](../../../CHANGELOG.md) for migration details.

---

# /pr-review - Code Review from Diff

Analyze a commit or branch diff against codebase patterns and constitution.md. Outputs a structured findings report.

## Usage
```
/pr-review <commit-hash>       # review a single commit
/pr-review <branch-name>       # review branch diff against base
```

## Arguments
$ARGUMENTS

## Instructions

### 0. Load Integration Config
Read `.devwork/constitution.md` → `## Integrations` section.
Use the configured PR review CLI (bb-comments, gh, etc.) if available.
If no PR CLI configured, ask user for the command to fetch PR comments.

### 1. Parse Input

If `$ARGUMENTS` is empty, respond with usage hint and stop.

Detect input type:
- **Commit hash** (7-40 hex chars matching `^[0-9a-f]{7,40}$`): validate with `git rev-parse --verify <hash>`
- **Branch name** (anything else): validate with `git rev-parse --verify origin/<branch>` or `git rev-parse --verify <branch>`

If validation fails, show error: `"ref not found: <input>. Check the hash/branch name."` and stop.

### 2. Gather Diff

**STRICTLY READ-ONLY**: Do NOT run `git checkout`, `git stash`, `git fetch`, `git pull`, `git commit`, or any command that modifies the working tree, index, or remote state.

For **commit hash**:
```bash
git show --no-patch --format='%H%n%an%n%ae%n%ad%n%s%n%b' <hash>
git diff <hash>~1..<hash>
git diff --stat <hash>~1..<hash>
```
If `<hash>~1` fails (merge commit), use `<hash>^1..<hash>`.

For **branch name**:
```bash
# Find base branch (try release, then develop, then main)
git merge-base origin/release origin/<branch>
git log --oneline origin/release..origin/<branch>
git diff origin/release...origin/<branch>
git diff --stat origin/release...origin/<branch>
```

### 3. Large Diff Guard

Count files changed from `--stat` output. If **20+ files changed**, warn the user:
> "This diff touches {N} files. Review may be noisy. Continue with full review, or provide a path scope?"

Wait for user response before continuing.

### 4. Extract Ticket ID

Search in order (first match wins):
1. Branch name: regex `[A-Z]+-\d+` (e.g., `CDW-2035`)
2. Commit message subject/body: same regex
3. Fallback: short SHA (first 7 chars) or branch name slug

This becomes `{TICKET}` for the report filename and heading.

### 5. Load Constitution

Read `.devwork/constitution.md` if it exists. This informs Pass 3 (Pattern Compliance).
If no constitution exists, skip Pass 3 and note it in the report.

### 6. Load Changed File Context

For each file in the diff stat:
- Read the **full current source** using the Read tool (not git show, to avoid modifying state)
- If the file was deleted in the diff, skip it
- This gives the reviewer full context around changed lines

Limit: if a single file exceeds 1000 lines, read only the changed regions ± 50 lines of context.

### 7. Three Review Passes

Analyze the diff + full file context. Be thorough but precise.

**Pass 1 — Correctness**
- Bugs, logic errors, off-by-one, null/undefined access
- Security: SQL injection, XSS, auth bypass, mass assignment, secrets in code
- Edge cases: empty arrays, null values, type mismatches
- Error handling: uncaught exceptions, silent failures
- Race conditions, concurrency issues

**Pass 2 — Performance**
- N+1 queries (Eloquent eager loading)
- Unnecessary loops, repeated DB calls
- Memory: large collections loaded without chunking
- Missing indexes (if schema changes present)
- Cache invalidation issues

**Pass 3 — Constitution Pattern Compliance** (skip if no constitution.md)
- Naming conventions (controllers, services, repositories, transformers)
- Architecture: correct layer usage (controller → service → repository)
- Type hints, return types, PHPDoc
- Error handling patterns
- API response format (Fractal transformers, Dingo responses)
- Only check rules that are **relevant to the changed code**

### 8. Confidence Filter

Assign each finding a confidence level:
- **HIGH** → Include in "Findings" section. You are confident this is a real issue.
- **MEDIUM** → Include in "Worth Investigating" section. Plausible but needs human judgment.
- **LOW** → Discard silently. Do not include in report.

**Discard**: style preferences, nitpicks, "consider using X", praise, unrelated suggestions.

### 9. Write Report

Create directory if needed: `.devwork/reviews/`

If `.devwork/reviews/{TICKET}-code-review.md` already exists, append timestamp: `{TICKET}-code-review-{YYYYMMDD-HHmm}.md`

Write to `.devwork/reviews/{TICKET}-code-review.md`:

```markdown
# Code Review: {TICKET} — {one-line summary of changes}

| Field | Value |
|-------|-------|
| Commit | `{full-sha}` |
| Author | {name} |
| Branch | {branch-name} |
| Date | {commit-date} |
| Files Changed | {count} |

---

## Findings

{For each HIGH-confidence finding, numbered:}

### {N}. {SEVERITY} — {Title}

**File**: `{path}:{line}`
**Issue**: {Clear description of the problem}
**Recommendation**:
```php
// suggested fix — must be syntactically valid PHP
```

---

## Worth Investigating

{For each MEDIUM-confidence item, numbered:}

### {N}. {Title}

**File**: `{path}:{line}`
**Observation**: {What looks off and why it might matter}

---

## Pattern Compliance

{Only if constitution.md was loaded. Table of relevant rules only:}

| Rule | Status | Detail |
|------|--------|--------|
| {convention name} | PASS / FAIL | {brief explanation} |

---

## Impact Summary

| # | Finding | Severity | Category |
|---|---------|----------|----------|
| 1 | {title} | CRITICAL / HIGH / MEDIUM | Bug / Security / Performance / Pattern |

---

*Generated by /pr-review on {ISO-8601 timestamp}*
```

### 10. Output Summary

After writing the report, output a brief summary to the conversation:
```
Review: {TICKET} — {summary}
Report: .devwork/reviews/{filename}
Findings: {count} | Worth Investigating: {count}
{one-line per HIGH finding}
```

## Key Rules

- **STRICTLY READ-ONLY**: No checkout, stash, fetch, pull, commit, push, reset, clean, or any git write operation
- **Only file write**: the report in `.devwork/reviews/`
- **No low-confidence noise**: discard LOW findings silently
- **No praise**: do not compliment code quality
- **No unrelated suggestions**: only review what changed
- **Bitbucket repo**: do not use `gh` CLI commands — PR numbers are not available
- **Code snippets**: must be syntactically valid PHP (or the relevant language)
- **Line numbers**: always reference specific lines when possible
- **Severity levels**: CRITICAL (data loss, security breach), HIGH (bugs, logic errors), MEDIUM (performance, patterns)
