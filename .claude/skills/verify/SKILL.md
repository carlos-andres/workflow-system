---
name: verify
description: Verification before completion — use before claiming work is done, fixed, or passing. Evidence before assertions.
---

# Verification Before Completion

No completion claims without fresh verification evidence.

## Gate
Before ANY claim that work passes, is fixed, or is complete:
1. **IDENTIFY** what command proves this claim → 2. **RUN** it fresh → 3. **READ** full output, check exit code → 4. **CONFIRM** output supports claim? State with evidence. Doesn't? State actual status.

## What Requires What
- Tests pass → run test command, see 0 failures (not previous run, not "should pass")
- Build succeeds → build command, exit 0 (not linter passing)
- Bug fixed → reproduce original symptom: resolved (not "code changed")
- Lint clean → linter output, 0 errors (not partial check)
- Requirements met → line-by-line checklist against spec (not "tests pass")
- Agent work done → check VCS diff, verify changes (not trust agent report)

## Red Flags — STOP and verify first
Using "should/probably/seems to" about status | expressing satisfaction before verification | about to commit/push/PR without fresh test run | trusting sub-agent reports without checking diff | relying on stale test runs

## Rule
Evidence before assertions. Always. No exceptions.
