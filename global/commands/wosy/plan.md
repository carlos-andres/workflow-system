# /plan - Implementation Planning

Design the implementation approach and create a task breakdown.

> **Model**: This command benefits from `opus` (latest) — planning requires architectural thinking.
> Reference: [Model Assignment](models.md) | [Conductor Discipline](conductor.md)

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

1. Read `.devwork/{type}/{task-id}/status.md`
2. Read `.devwork/{type}/{task-id}/research.md`
3. Read `.devwork/{type}/{task-id}/spec.md` (if exists)
4. Read `.devwork/constitution.md`

### Step 2: Design Approach

Consider:
- What patterns to use (from research.md)
- File structure (from constitution.md)
- Dependencies and order of operations
- Testing strategy
- Risks and mitigations

### Step 2b: Codebase Verification Checkpoint

Before writing the plan, confirm:

1. [ ] Every file in research.md `Will Modify` still exists and hasn't changed since research
2. [ ] The pattern from `Verified References` is still the right fit
3. [ ] No new unknowns since research

If any check fails, re-run `/wosy:research` on the affected area. This is a hard gate.

### Step 3: Create Implementation Plan

Create `.devwork/{type}/{task-id}/plan.md`:

```markdown
# Implementation Plan: {task-id}

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
| Task | Pass Criteria | Verified By |
|------|--------------|-------------|
| {Task 1} | {measurable outcome} | {test / command / manual} |
| {Task 2} | {measurable outcome} | {test / command / manual} |

**Gate**: {What must be true before Phase 2}

### Phase 2: {Name} (e.g., "Business Logic")
| Task | Pass Criteria | Verified By |
|------|--------------|-------------|
| {Task 1} | {measurable outcome} | {test / command / manual} |
| {Task 2} | {measurable outcome} | {test / command / manual} |

**Gate**: {What must be true before Phase 3}

### Phase 3: {Name} (e.g., "API/Controller")
| Task | Pass Criteria | Verified By |
|------|--------------|-------------|
| {Task 1} | {measurable outcome} | {test / command / manual} |
| {Task 2} | {measurable outcome} | {test / command / manual} |

**Gate**: {What must be true before Phase 4}

### Phase 4: {Name} (e.g., "Testing")
| Task | Pass Criteria | Verified By |
|------|--------------|-------------|
| {Task 1} | {measurable outcome} | {test / command / manual} |
| {Task 2} | {measurable outcome} | {test / command / manual} |

**Gate**: {What must be true before delivery}

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

- Spec: `.devwork/{type}/{task-id}/spec.md`
- Research: `.devwork/{type}/{task-id}/research.md`
- Tasks: `.devwork/{type}/{task-id}/tasks.md`
```

### Step 3b: T-Shirt Sizing

**Prerequisite**: research.md must exist. Sizing without codebase knowledge is guessing.

Score each factor using signals from research.md:

| Factor | Signal Source (from research.md) | XS | S | M | L | XL |
|--------|--------------------------------|----|----|----|----|-----|
| **Effort** | "Will Modify" table → file count | 1 file | 1-3 files | 4-10 files | 10-25 files | 25+ files |
| **Complexity** | "Dependencies" section → coupling | Zero deps | Single domain, existing patterns | Some cross-file deps, parallelizable | Cross-domain (BE+FE+infra), tight coupling | Architecture-level, new patterns everywhere |
| **Risk** | "Risks" + "Questions for /spec" | None — trivial change | Low — existing reference found | Mixed — some new patterns needed | High — unknowns, third-party deps | Very high — no reference, open questions remain |

**Sizing rule**: The HIGHEST factor score wins. A task with S effort but L risk = L.

| Size | What it means | Execution |
|------|--------------|-----------|
| **XS** | Trivial — typo, config tweak, single-line fix | Skip dispatch. Just do it. No tasks.md needed. |
| **S** | Small — clear scope, existing patterns, 1-3 files | Manual — work through tasks.md checkboxes |
| **M** | Medium — multi-file, some parallelizable work | `/wosy:dispatch` — wosy orchestrates sub-agents |
| **L** | Large — cross-domain, tight deps, needs review loops | `/wosy:dispatch` + thorough review via `/work ship` |
| **XL** | Too big — must split into smaller tickets | Split into sub-tickets. Run `/plan` on each sub-ticket, then `/dispatch` per ticket. |

Output sizing to user:

> **T-Shirt Size: {XS/S/M/L/XL}**
> Effort: {score} — {N files in Will Modify}
> Complexity: {score} — {signal from Dependencies}
> Risk: {score} — {signal from Risks/Questions}
>
> Recommended execution: {strategy}
> {If XL}: ⚠ This task should be split. Suggest ticket breakdown:
> - Ticket A: {scope}
> - Ticket B: {scope}
> {If XL}: Break into sub-tickets. Each sub-ticket gets its own `/plan` + `/dispatch` cycle.

Write sizing result to `tasks.md` header.

### Step 4: Generate Task Checklist

Create `.devwork/{type}/{task-id}/tasks.md`:

```markdown
# Tasks: {task-id}

> Generated from plan.md on {YYYY-MM-DD}

---

## Phase 1: {Name}

- [ ] {Task 1} → **pass**: {criteria}
- [ ] {Task 2} → **pass**: {criteria}
- [ ] {Task 3} → **pass**: {criteria}
- [ ] **Checkpoint**: {verification step}

## Phase 2: {Name}

- [ ] {Task 1} → **pass**: {criteria}
- [ ] {Task 2} → **pass**: {criteria}
- [ ] **Checkpoint**: {verification step}

## Phase 3: {Name}

- [ ] {Task 1} → **pass**: {criteria}
- [ ] {Task 2} → **pass**: {criteria}
- [ ] **Checkpoint**: {verification step}

## Phase 4: Testing

- [ ] Write unit tests for {component} → **pass**: {criteria}
- [ ] Write feature tests for {flow} → **pass**: {criteria}
- [ ] Run full test suite → **pass**: all tests green
- [ ] **Checkpoint**: All tests pass

## Final

- [ ] Run linting (use detected tools from constitution.md)
- [ ] Manual verification
- [ ] Update status.md
- [ ] /work ship

---

## Progress

**Started**: {YYYY-MM-DD}
**Current Phase**: 1
**Blocked**: No

---

## T-Shirt Size: {XS/S/M/L/XL}
Effort: {score} | Complexity: {score} | Risk: {score}
Execution: {Manual / wosy:dispatch / dispatch+review / split+dispatch}

## Dependency Graph

Phase 1: {name}
  task-1 → (no deps)
  task-2 → (no deps)
  task-3 → depends-on: [task-1]
  -- gate: {criteria} --

Parallelizable sets:
- Set A: [task-1, task-2] — no mutual deps
- Set B: [task-4, task-5] — after Phase 1 gate

## Task Details

### Task 1: {Name}
- scope: {file paths}
- blockedBy: []
- status: pending

**Context:** {where this fits, what depends on it}

**Steps:**
1. {specific action}
2. {specific action}
3. {verification with expected output}

**Pass criteria:** {measurable outcome}
**Commit:** `{conventional commit message}`
```

> **Note:** Only generate the extended template sections (Dependency Graph, Task Details) when T-Shirt Size = M or higher. For XS and S, the phase checklists and Progress section above are sufficient.

### Step 5: Update Task Record

Update `.devwork/tasks/{task-id}.md`:
- Check off `create implementation plan` in Progress
- Set `size:` in header to the T-shirt size result
- Replace generic progress steps with actual plan phases/tasks (keep ≤30 lines total)
- Update `## Active` with plan summary
- Update `updated:` date

Example updated task record:
```markdown
# AUTH-001: Add user authentication
type: feature | size: M | created: 2026-03-10 | updated: 2026-03-15

## Progress
- [x] research codebase
- [x] create implementation plan
- [ ] Phase 1: database + models (3 tasks)
- [ ] Phase 2: auth service + middleware (4 tasks)
- [ ] Phase 3: API endpoints (3 tasks)
- [ ] Phase 4: testing (2 tasks)
- [ ] deliver

## Active
plan complete — ready for dispatch

## Dependencies
- Phase 2 depends on Phase 1 (models must exist)

## Workspace
.devwork/feature/AUTH-001/
```

### Step 6: Update Status

Update `.devwork/{type}/{task-id}/status.md`:

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
{If M/L/XL: "Run `/dispatch` to orchestrate implementation."}

## Session Log
### {YYYY-MM-DD}
- Created implementation plan
- T-shirt size: {size}
- {n} phases, {n} total tasks
- Estimated effort: {time}
```

### Step 7: Confirm

Output:

```
✓ Plan complete: .devwork/{type}/{task-id}/plan.md
✓ Tasks generated: .devwork/{type}/{task-id}/tasks.md
✓ Task record updated: .devwork/tasks/{task-id}.md (size: {size})

Summary:
- T-shirt size: {size}
- Phases: {count}
- Tasks: {count}
- New files: {count}
- Modified files: {count}
- Estimated: {time}

{If XS: "Just do it — no dispatch needed."}
{If S: "Work through tasks.md checkboxes, or run /dispatch."}
{If M/L: "Run /dispatch to orchestrate with sub-agents."}
{If XL: "Split into sub-tasks first. See suggested breakdown above."}
```

## Light Plan (for Bugfix)

For bugfixes, create a lighter plan:
- Skip detailed architecture
- Skip phases (usually single phase)
- Focus on: what to change, how to test, risks
