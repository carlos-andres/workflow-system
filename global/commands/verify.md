# /verify - Phase & Checkpoint Validation

Validate completion of current phase before proceeding. Not a gate — user can force-proceed.

## Usage
```
/verify
/verify {phase}    # verify specific phase: research, spec, plan, deliver
```

## Instructions

1. **Find active workspace**: Locate most recently modified `status.md` in `.devwork/`

2. **Determine phase to verify** (from argument or status.md current state):

### After /research
- [ ] `research.md` exists and is non-empty
- [ ] Key patterns/conventions documented
- [ ] Relevant files/modules identified
- [ ] Dependencies and constraints noted

### After /spec
- [ ] `spec.md` exists and is non-empty
- [ ] Acceptance criteria defined
- [ ] Edge cases listed
- [ ] Out-of-scope items noted

### After /plan
- [ ] `plan.md` exists with phases/approach
- [ ] `tasks.md` exists with checkboxes
- [ ] Tasks are ordered and scoped

### Before /deliver
- [ ] All tasks in tasks.md marked done (or explicitly deferred)
- [ ] Tests pass (detect and run from constitution.md or project manifest)
- [ ] Linting/formatting passes (detect tools from constitution.md or project manifest)
- [ ] No debug code left (search for common debug patterns)
- [ ] Acceptance criteria met (check against spec.md if exists)
- [ ] ADR updated if architectural decisions were made

3. **Report results**:
   ```
   ✓ Verify: {phase}

   Passed:  {count}
   Failed:  {count}
   Skipped: {count} (not applicable)

   {Details of any failures}
   ```

4. **Update status.md**: Add verification entry with timestamp to session log

5. **If failures exist**: Show what's missing and suggest fix. User decides whether to proceed or fix.

## Key Rules
- Read-only checks — never modify source code
- Detect test/lint tools from constitution.md first, then project manifests
- Missing files for skipped phases are OK (e.g., no spec.md in Straight mode)
- Always show the checklist so user sees what was checked
