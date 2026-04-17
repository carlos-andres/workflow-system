---
name: wosy-spec
description: Structured requirements interview. Produces spec.md with acceptance criteria.
---

# /spec

Prereq: `/intake` done, `/research` recommended. Read status.md + research.md first.

## Interview

Ask 2-3 questions at a time across these categories:
- **Core**: what it does, who uses it, trigger, expected output
- **Edge Cases**: empty input, no permission, missing data, midway failure
- **Data**: required vs optional, validation, limits, formats
- **Errors**: communication, atomicity, retry, logging
- **Performance**: volume, caching, timeouts, pagination
- **Integration**: impact on other features, API contracts, frontend
- **Acceptance**: how to verify, what tests prove it, who approves

## Write spec.md

`.devwork/{type}/{task-id}/spec.md` — Overview, User Stories, Functional Reqs (core behavior + inputs + outputs), Edge Cases, Error Handling, Non-Functional (perf/security/logging), Acceptance Criteria (checkboxes, testable), Out of Scope, Open Questions.

Be specific (not "handle errors gracefully"). Every requirement testable. Scope creep goes to Out of Scope.

## Update Records
- Task record: check off `define requirements`, update Active + date
- status.md: mark [DONE], add session log, set next action

## Output
```
Spec complete: .devwork/{type}/{task-id}/spec.md
Core: {n} | Edge cases: {n} | Acceptance: {n} | Out of scope: {n}
Next: /plan
```
