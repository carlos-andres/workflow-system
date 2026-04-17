---
name: debugging
description: Systematic debugging — use when encountering any bug, test failure, or unexpected behavior. Root cause before fixes.
---

# Systematic Debugging

No fixes without root cause investigation first. Random fixes waste time and create new bugs.

## Phase 1: Investigate
BEFORE attempting ANY fix:
1. **Read errors completely** — stack traces, line numbers, error codes. They often contain the answer.
2. **Reproduce consistently** — exact steps, every time. Not reproducible → gather more data, don't guess.
3. **Check recent changes** — `git diff`, recent commits, new deps, config changes, env differences.
4. **Trace data flow backward** — where does the bad value originate? Keep tracing up the call chain. Fix at source, not symptom.

Multi-component systems (CI→build→signing, API→service→DB): add diagnostic logging at EACH boundary BEFORE fixing. Run once → analyze WHERE it breaks → investigate THAT component.

## Phase 2: Analyze
Find working examples of similar code. Compare working vs broken — list every difference. Understand dependencies, config, environment assumptions.

## Phase 3: Hypothesis
State clearly: "X is the root cause because Y". Test with the SMALLEST possible change — one variable at a time. Worked → Phase 4. Didn't → NEW hypothesis, don't stack fixes.

## Phase 4: Fix
1. Write a failing test reproducing the bug (`tdd` skill). 2. Implement ONE fix addressing root cause. 3. Verify: test passes, no regressions. **3-Fix Rule**: if 3+ fixes have failed, STOP — each fix revealing new problems = architectural issue. Question fundamentals and discuss with user before continuing.

## Red Flags — Return to Phase 1
"Quick fix for now" | "Just try changing X" | "It's probably X" | proposing solutions before tracing data flow | multiple changes at once | "one more fix attempt" after 2 failures
