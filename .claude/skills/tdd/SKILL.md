---
name: tdd
description: Test-driven development — use before implementing any feature or bugfix. Red-green-refactor cycle with framework auto-detection.
---

# Test-Driven Development

No production code without a failing test first. If you didn't watch it fail, you don't know it tests the right thing.

## Cycle
RED (write ONE minimal test, run, confirm it FAILS for the right reason) → GREEN (SMALLEST code to pass, no extras) → REFACTOR (clean up, keep tests green, no new behavior) → REPEAT

## Framework Detection
`composer.json` → PHPUnit: `vendor/bin/phpunit --filter=TestName` | `package.json` → Jest/Vitest: `npx jest path/to/test` or `npx vitest run path/to/test` | `Package.swift` → XCTest: `swift test --filter TestName` | `.devwork/bin/phpunit-*` → use project wrapper scripts. Always run SINGLE test file during TDD.

## Rules
- Test fails → write code. Test passes immediately → test is wrong, fix it.
- Code written before test → delete it, start over.
- One behavior per test. "and" in test name → split it.
- Test name describes behavior: `test_rejects_empty_email` not `test1`.
- Real code over mocks. Mock only external services, DBs, network. Never mock the thing under test.

## Mock Discipline
Before mocking: 1) What side effects does the real method have? 2) Does this test depend on them? 3) If yes → mock at a lower level. Anti-patterns: asserting on mock elements instead of real behavior | test-only methods in production classes | mock setup longer than test logic → consider integration test | incomplete mocks → mirror real structure completely.

## Bug Fix Flow
1. Write failing test reproducing bug → 2. Confirm it fails → 3. Fix (minimal change) → 4. Confirm pass → 5. Run related tests for regressions

## Verification Before Done
Every function has a test | watched each fail before implementing | each failure for expected reason | minimal code to pass | all tests pass | no errors/warnings | edge cases covered
