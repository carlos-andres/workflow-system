# /graduate - Promote Artifacts to Shareable Location

Move finalized working artifacts from ticket folders to project-wide shareable directories.

## Usage
```
/graduate                           # Interactive - choose what to graduate
/graduate spec                      # Graduate current ticket's spec
/graduate adr                       # Graduate current ticket's ADR(s)
/graduate all                       # Graduate all artifacts from current ticket
```

## Purpose

Working artifacts live in ticket folders during development:
```
.devwork/feature/nt-0001/
├── spec.md          # Working draft
└── adr/
    └── 001-auth-choice.md   # Working decision
```

Finalized artifacts graduate to project-wide directories:
```
.devwork/
├── specs/
│   └── nt-0001-user-authentication.md   # Final, shareable
└── decisions/
    └── 0001-auth-choice.md              # Final, shareable
```

---

## Instructions

### Step 1: Identify Current Ticket

Read `.devwork/feature/*/status.md` or `.devwork/hotfix/*/status.md` to find active ticket.

If multiple active tickets, ask which one.

### Step 2: Interactive Mode (`/graduate`)

Ask what to graduate:

```
Current ticket: NT-0001 "User Authentication"

What would you like to graduate?
1. Spec → .devwork/specs/nt-0001-user-authentication.md
2. ADR(s) → .devwork/decisions/NNNN-{slug}.md
3. All artifacts
4. Cancel
```

### Step 3: Graduate Spec

**From:** `.devwork/feature/{jira-id}/spec.md`
**To:** `.devwork/specs/{jira-id}-{slug}.md`

Process:
1. Read working spec
2. Generate slug from title (kebab-case)
3. Add graduation header:
   ```markdown
   # Spec: {Title}
   
   > Graduated from {JIRA-ID} on {DATE}
   > Original: `.devwork/feature/{jira-id}/spec.md`
   
   ---
   
   {original content}
   ```
4. Save to `.devwork/specs/`
5. Update working spec with reference:
   ```markdown
   <!-- GRADUATED: See .devwork/specs/{filename}.md -->
   ```

### Step 4: Graduate ADR(s)

**From:** `.devwork/feature/{jira-id}/adr/*.md` or `.devwork/feature/{jira-id}/adr-NNN.md`
**To:** `.devwork/decisions/NNNN-{slug}.md`

Process:
1. Read working ADR(s)
2. Determine next decision number:
   ```bash
   ls .devwork/decisions/*.md | wc -l
   # Next number = count + 1, padded to 4 digits
   ```
3. Generate slug from ADR title
4. Add graduation header:
   ```markdown
   # ADR-{NNNN}: {Title}
   
   > Graduated from {JIRA-ID} on {DATE}
   > Original: `.devwork/feature/{jira-id}/adr/{filename}.md`
   
   ---
   
   {original content with Status updated to "Accepted"}
   ```
5. Save to `.devwork/decisions/`
6. Update working ADR with reference

### Step 5: Update Decision Index

If ADR was graduated, update `.devwork/decisions/README.md` (or create it):

```markdown
# Architecture Decision Records

| ID | Date | Title | Status | Ticket |
|----|------|-------|--------|--------|
| [0001](0001-auth-choice.md) | 2025-01-31 | Auth Method Choice | Accepted | NT-0001 |
| [0002](0002-caching-strategy.md) | 2025-02-01 | Caching Strategy | Accepted | NT-0015 |
```

### Step 6: Confirm

Output:

```
✓ Graduated artifacts from NT-0001:

Specs:
  .devwork/feature/nt-0001/spec.md
  → .devwork/specs/nt-0001-user-authentication.md

Decisions:
  .devwork/feature/nt-0001/adr/001-auth-choice.md
  → .devwork/decisions/0001-auth-choice.md

Decision index updated: .devwork/decisions/README.md

These files are now in shareable format and can be:
- Copied outside .devwork/ if needed
- Referenced by other tickets
- Used for onboarding/documentation
```

---

## When to Graduate

### Always Graduate
- **ADRs** with significant architectural decisions
- **Specs** for major features that others might reference

### Maybe Graduate
- Specs for medium features (your judgment)
- ADRs for minor decisions (might clutter decisions/)

### Don't Graduate
- Hotfix status files
- Research notes (usually ticket-specific)
- Plans (usually not useful after completion)
- Small bugfix specs

---

## Shareable Format

Graduated files follow industry standards:

### Specs (`.devwork/specs/`)
```
{jira-id}-{slug}.md

Examples:
- nt-0001-user-authentication.md
- nt-0042-inventory-year-filter.md
- nt-0100-api-v2-migration.md
```

### Decisions (`.devwork/decisions/`)
```
{NNNN}-{slug}.md    # Numbered sequentially across project

Examples:
- 0001-use-nova-admin.md
- 0002-repository-pattern.md
- 0003-jwt-vs-sanctum.md
```

---

## Bulk Operations

### Graduate from archived ticket
```
/graduate from nt-0001
```

### List what could be graduated
```
/graduate list
```
Shows all tickets with specs/ADRs that haven't been graduated.

---

## Integration with /deliver

The `/deliver` command will prompt for graduation:

```
✓ Task complete!

This ticket has:
- 1 spec (not graduated)
- 2 ADRs (not graduated)

Graduate artifacts before archiving? (y/n)
```

If yes, runs `/graduate all` automatically.
