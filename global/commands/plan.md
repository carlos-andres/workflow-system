# /plan - Implementation Planning

Design the implementation approach and create a task breakdown.

## Usage
```
/plan
```

## Prerequisites
- Must run `/intake` first
- Must run `/research` first
- Should run `/spec` if requirements were unclear
- Read constitution.md for project conventions

## Instructions

### Step 1: Load Context

1. Read `.devwork/{type}/{jira-id}/status.md`
2. Read `.devwork/{type}/{jira-id}/research.md`
3. Read `.devwork/{type}/{jira-id}/spec.md` (if exists)
4. Read `.devwork/constitution.md`

### Step 2: Design Approach

Consider:
- What patterns to use (from research.md)
- File structure (from constitution.md)
- Dependencies and order of operations
- Testing strategy
- Risks and mitigations

### Step 3: Create Implementation Plan

Create `.devwork/{type}/{jira-id}/plan.md`:

```markdown
# Implementation Plan: {JIRA-ID}

> {Brief description}

---

## Approach Summary

{2-3 sentences describing the overall approach}

---

## Architecture

### Components
| Component | Purpose | Location |
|-----------|---------|----------|
| {name} | {what it does} | `{file path}` |

### Data Flow
```
{Input} → {Process 1} → {Process 2} → {Output}
```

### Diagram (if helpful)
```
┌─────────┐     ┌─────────┐     ┌─────────┐
│ Request │────▶│ Service │────▶│  Model  │
└─────────┘     └─────────┘     └─────────┘
```

---

## Files to Create/Modify

### New Files
| File | Purpose |
|------|---------|
| `{path}` | {purpose} |

### Modified Files
| File | Changes |
|------|---------|
| `{path}` | {what changes} |

---

## Implementation Phases

### Phase 1: {Name} (e.g., "Database & Models")
- {Task 1}
- {Task 2}
- **Checkpoint**: {How to verify phase is complete}

### Phase 2: {Name} (e.g., "Business Logic")
- {Task 1}
- {Task 2}
- **Checkpoint**: {How to verify phase is complete}

### Phase 3: {Name} (e.g., "API/Controller")
- {Task 1}
- {Task 2}
- **Checkpoint**: {How to verify phase is complete}

### Phase 4: {Name} (e.g., "Testing")
- {Task 1}
- {Task 2}
- **Checkpoint**: {How to verify phase is complete}

---

## Technical Decisions

### Decision 1: {Decision Title}
- **Options**: {A} vs {B}
- **Chosen**: {A}
- **Reason**: {Why}

(Document in adr.md if significant)

---

## Testing Strategy

### Unit Tests
| Test | Covers |
|------|--------|
| `{TestClass}` | {what it tests} |

### Feature/Integration Tests
| Test | Covers |
|------|--------|
| `{TestClass}` | {what it tests} |

### Manual Verification
- [ ] {Step 1}
- [ ] {Step 2}

---

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| {risk} | {H/M/L} | {how to handle} |

---

## Dependencies

### Must Complete First
- {dependency 1}

### Can Parallel
- {independent task}

---

## Estimated Effort

- Phase 1: ~{time}
- Phase 2: ~{time}
- Phase 3: ~{time}
- Phase 4: ~{time}
- **Total**: ~{time}

---

## Related Documents

- Spec: `.devwork/{type}/{jira-id}/spec.md`
- Research: `.devwork/{type}/{jira-id}/research.md`
- Tasks: `.devwork/{type}/{jira-id}/tasks.md`
```

### Step 4: Generate Task Checklist

Create `.devwork/{type}/{jira-id}/tasks.md`:

```markdown
# Tasks: {JIRA-ID}

> Generated from plan.md on {YYYY-MM-DD}

---

## Phase 1: {Name}

- [ ] {Task 1}
- [ ] {Task 2}
- [ ] {Task 3}
- [ ] **Checkpoint**: {verification step}

## Phase 2: {Name}

- [ ] {Task 1}
- [ ] {Task 2}
- [ ] **Checkpoint**: {verification step}

## Phase 3: {Name}

- [ ] {Task 1}
- [ ] {Task 2}
- [ ] **Checkpoint**: {verification step}

## Phase 4: Testing

- [ ] Write unit tests for {component}
- [ ] Write feature tests for {flow}
- [ ] Run full test suite
- [ ] **Checkpoint**: All tests pass

## Final

- [ ] Run linting (pint, phpstan, eslint)
- [ ] Manual verification
- [ ] Update status.md
- [ ] /deliver

---

## Progress

**Started**: {YYYY-MM-DD}
**Current Phase**: 1
**Blocked**: No
```

### Step 5: Update Status

Update `.devwork/{type}/{jira-id}/status.md`:

```markdown
## Tasks
[DONE] Research codebase
[DONE] Define requirements (if applicable)
[DONE] Create implementation plan
[TODO] Implement solution
[TODO] Test changes
[TODO] Deliver

## Next Action
Start Phase 1: {phase name}. See tasks.md for checklist.

## Session Log
### {YYYY-MM-DD}
- Created implementation plan
- {n} phases, {n} total tasks
- Estimated effort: {time}
```

### Step 6: Confirm

Output:

```
✓ Plan complete: .devwork/{type}/{jira-id}/plan.md
✓ Tasks generated: .devwork/{type}/{jira-id}/tasks.md

Summary:
- Phases: {count}
- Tasks: {count}
- New files: {count}
- Modified files: {count}
- Estimated: {time}

Ready to implement. Start with Phase 1.
```

## Light Plan (for Bugfix)

For bugfixes, create a lighter plan:
- Skip detailed architecture
- Skip phases (usually single phase)
- Focus on: what to change, how to test, risks
