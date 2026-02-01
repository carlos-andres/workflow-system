# /spec - Requirements Interview

Conduct a structured interview to clarify requirements, edge cases, and acceptance criteria.

## Usage
```
/spec
```

## Prerequisites
- Must run `/intake` first
- Should run `/research` first (to inform questions)
- Read research.md for context

## Instructions

### Step 1: Load Context

1. Read `.devwork/{type}/{jira-id}/status.md`
2. Read `.devwork/{type}/{jira-id}/research.md`
3. Read `.devwork/{type}/{jira-id}/README.md`

### Step 2: Interview Process

Ask questions in categories. Ask 2-3 questions at a time, not all at once.

#### Category 1: Core Functionality
- What exactly should this do?
- Who is the user/actor?
- What triggers this action?
- What is the expected output/result?

#### Category 2: Edge Cases
- What happens if {input is empty/null}?
- What happens if {user doesn't have permission}?
- What happens if {related data doesn't exist}?
- What happens if {process fails midway}?

#### Category 3: Data & Validation
- What data is required vs optional?
- What validation rules apply?
- Are there size/length limits?
- What formats are acceptable?

#### Category 4: Error Handling
- How should errors be communicated?
- Should operations be atomic (all or nothing)?
- Is retry logic needed?
- What should be logged?

#### Category 5: Performance & Scale
- How many records/requests expected?
- Is caching needed?
- Are there timeout concerns?
- Is pagination needed?

#### Category 6: Integration
- Does this affect other features?
- Are there API contracts to maintain?
- Does the frontend need changes?
- Are there notification/email requirements?

#### Category 7: Acceptance Criteria
- How will we know this is done?
- What tests prove it works?
- Who needs to approve this?

### Step 3: Document Specification

Create `.devwork/{type}/{jira-id}/spec.md`:

```markdown
# Specification: {JIRA-ID}

> {Brief description}

---

## Overview

{2-3 sentences describing what this feature does and why}

## User Stories

### Primary Story
As a {actor}, I want to {action} so that {benefit}.

### Additional Stories (if any)
- As a {actor}, I want to {action} so that {benefit}.

---

## Functional Requirements

### Core Behavior
1. {Requirement 1}
2. {Requirement 2}
3. {Requirement 3}

### Input
| Field | Type | Required | Validation |
|-------|------|----------|------------|
| {field} | {type} | {yes/no} | {rules} |

### Output
| Scenario | Response |
|----------|----------|
| Success | {what happens} |
| Failure | {what happens} |

---

## Edge Cases

| Scenario | Expected Behavior |
|----------|-------------------|
| {edge case 1} | {behavior} |
| {edge case 2} | {behavior} |
| {edge case 3} | {behavior} |

---

## Error Handling

| Error Condition | Response | User Message |
|-----------------|----------|--------------|
| {condition} | {code/action} | {message} |

---

## Non-Functional Requirements

### Performance
- {requirement or "No special requirements"}

### Security
- {requirement or "Standard authentication/authorization"}

### Logging
- {what should be logged}

---

## Acceptance Criteria

- [ ] {Criterion 1 - specific, testable}
- [ ] {Criterion 2 - specific, testable}
- [ ] {Criterion 3 - specific, testable}

---

## Out of Scope

- {Explicitly excluded item 1}
- {Explicitly excluded item 2}

---

## Open Questions

- {Any unresolved questions}

---

## Related Documents

- Research: `.devwork/{type}/{jira-id}/research.md`
- Plan: `.devwork/{type}/{jira-id}/plan.md` (after /plan)
```

### Step 4: Update Status

Update `.devwork/{type}/{jira-id}/status.md`:

```markdown
## Tasks
[DONE] Research codebase
[DONE] Define requirements
[TODO] Create implementation plan
...

## Next Action
Run `/plan` to design the implementation approach.

## Session Log
### {YYYY-MM-DD}
- Completed requirements interview
- Documented {n} edge cases
- Defined {n} acceptance criteria
```

### Step 5: Update README

Update `.devwork/{type}/{jira-id}/README.md` with objective and scope from spec.

### Step 6: Confirm

Output:

```
✓ Specification complete: .devwork/{type}/{jira-id}/spec.md

Summary:
- Core requirements: {count}
- Edge cases covered: {count}
- Acceptance criteria: {count}
- Out of scope: {count}

Ready for /plan
```

## Tips

- Be specific. "Handle errors gracefully" is not a requirement.
- Every requirement should be testable.
- If user says "I don't know" - suggest options and decide together.
- Push back on scope creep - add to "Out of Scope" instead.
