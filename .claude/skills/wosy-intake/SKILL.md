---
name: wosy-intake
description: Classify task, create workspace + task record in .devwork/
---

# /intake

Usage: `/intake {task-id} "description"` — task-id optional (auto-increments NNN.md).

**1. Ensure Structure**: `mkdir -p .devwork/{decisions,specs,feature,hotfix,_archive,_scratch,tasks}`

**2. Phase 0 Check**: If `.devwork/_scratch/phase0/` exists, read docs for context.

**3. Classify** — ask: **Task type?** 1) Hotfix (light docs) 2) Bugfix (medium) 3) Feature (full) 4) Refactor (full)

**4. Scope + Intent** (Feature/Refactor only): Ask if scope is clear (yes=skip /spec, no=full workflow with /spec). Define: Goal (specific outcome), Touches (system area), Stack (verify against constitution.md). Anti-assumption: challenge vague descriptions, never infer architecture from description alone, if touching unread code mark scope **unclear**.

**5. Work Mode**:
- Phase 0 + greenfield → **Deep Dive**: /phase0 → /work setup → /intake → /research → /spec → /plan → /dispatch → /work ship
- Existing codebase + feature/refactor → **Hybrid**: /intake → /research → /plan → /dispatch → /work ship (skip /spec if clear)
- Hotfix / clear scope → **Straight**: /intake → implement → /work ship

**6. Create Workspace**: Hotfix → `.devwork/hotfix/{task-id}/status.md` | Others → `.devwork/feature/{task-id}/status.md`. Only create `status.md`; other files created by their respective commands.

**7. Task Record**: ONE master file `.devwork/tasks/{task-id}.md` (max 30 lines). Format: title line, metadata line (`type|size|created|updated`), `## Progress` checklist (research, requirements if unclear, plan, implement, test, deliver), `## Active` (current state), `## Dependencies`, `## Workspace` (path). Rules: max 30 lines, no tooling info (goes in project memory), human-editable, updated by every wosy command.

**8. Initialize status.md**: Include type, created date, scope clear (y/n), work mode, goal, touches, unknowns, task checklist, next action, session log.

**9. Confirm**:
```
Project structure verified: .devwork/
Workspace created: .devwork/{type}/{task-id}/
Task record created: .devwork/tasks/{task-id}.md
Work mode: {mode}
Next: {suggested command}
```
