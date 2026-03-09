# /wosy:rebuild - Rebuild Project Configuration

Re-detect project stack, update constitution.md, and refresh project CLAUDE.md.
Equivalent to running `/constitution update` + `/project-init` in a single pass.

## Usage
```
/wosy:rebuild                # Full re-detect + update both files
/wosy:rebuild constitution   # Re-detect stack only (constitution.md)
/wosy:rebuild claude         # Regenerate project CLAUDE.md only
```

## Arguments
$ARGUMENTS

## Instructions

### Step 1: Determine Scope

Parse `$ARGUMENTS`:
- Empty or `full` → rebuild both constitution.md and CLAUDE.md
- `constitution` → only re-detect stack and update constitution.md
- `claude` → only regenerate project CLAUDE.md from existing constitution

### Step 2: Rebuild Constitution (if in scope)

1. Read existing `.devwork/constitution.md`
2. **Preserve** these sections verbatim:
   - `## Do NOT Touch` (everything between this heading and the next `##`)
   - `## Manual Notes` (everything between this heading and the next `##` or EOF)
3. Re-run stack detection from manifests and code (same as `/constitution update`):
   - Detect project type from manifest files
   - Run stack-specific detection tasks
   - Extract patterns from code samples
4. **Diff detected vs existing** — show what changed:
   ```
   Constitution changes:
   ~ Stack: PHP 8.2 → PHP 8.3
   + New dependency: laravel/pennant
   - Removed: spatie/laravel-backup
   ~ Architecture: added Actions/ (5 files)
   ```
5. Update `.devwork/constitution.md` with new detection results
6. Preserved sections remain untouched

### Step 3: Rebuild CLAUDE.md (if in scope)

1. Read updated `.devwork/constitution.md` (or existing if constitution not in scope)
2. Read existing project `CLAUDE.md`
3. **Preserve** these sections from existing CLAUDE.md:
   - `## Current Focus`
   - Any custom sections not in the standard template
4. Regenerate standard sections:
   - `## Project` — update if constitution reveals new info
   - `## Persona` — adapt to current stack detection
   - `## Commands` — refresh from constitution quality/test tools
5. Write updated `CLAUDE.md`

### Step 4: Summary

```
Rebuild complete.

Constitution: {updated | unchanged | skipped}
CLAUDE.md: {updated | unchanged | skipped}

Changes:
{list of material changes, if any}

Preserved:
- Do NOT Touch section ({N} lines)
- Manual Notes section ({N} lines)
- Current Focus section (CLAUDE.md)
```

## Important

- **NEVER delete Manual Notes or Do NOT Touch sections** — these are hand-curated
- **NEVER auto-commit** — show changes, let user decide
- If no `.devwork/constitution.md` exists, run full `/constitution` instead (inform user)
- If no project `CLAUDE.md` exists, run full `/project-init` instead (inform user)
- This command is for **updating existing configs**, not first-time setup
