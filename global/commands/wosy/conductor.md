> **DEPRECATED (v3.0)** — Legacy v2.0 command file kept for reference only.  
> Active version: `~/.claude/rules/wosy-conductor.md` (always-on rule)  
> See [CHANGELOG.md](../../../CHANGELOG.md) for migration details.

---

# Conductor Discipline

Rules for keeping the main window clean and architectural.
The conductor orchestrates — it never implements.

## The 5 Rules

### 1. Never implement in the main window
If a task requires code edits, file writes, or test runs → dispatch an agent.
This applies even for XS tasks. The conductor only reads results.

### 2. Context budget: ≤5 lines per state summary
Before dispatching, emit a compact state block:
```
Task: {id} — {description}
Type: {report|feature|hotfix|audit|...}
Model: {sonnet|opus} (for the agent)
Scope: {path to spec/plan doc}
Output: {path where agent writes result}
```
No full file dumps. No code in the main window.

### 3. Handoff contract
Every dispatched agent receives exactly:
- Task type and description
- Path to scope document (spec.md or plan.md)
- List of permitted files (what it may read/write)
- Definition of done (measurable criteria)
- Output path for status/result

Nothing else. If the agent needs more context, the scope doc is incomplete — fix the scope doc first.

### 4. Status return — done log only
Agent writes `.devwork/{type}/{id}/status.md` on completion.
Conductor reads only this file. Format:
```
## Current
{what is being worked on right now — or "complete"}

## Done
- [x] {step} (YYYY-MM-DD)
- [x] {step} (YYYY-MM-DD)

## Session Log
### YYYY-MM-DD
- {brief entry}
```
The conductor does NOT read full agent output — only the done log.

### 5. Model assignment at dispatch time
Never leave model implicit. Every Agent tool call must specify `model: "sonnet"` or `model: "opus"` according to the [model assignment guide](models.md).

## Commit Policy

**Global rule: never commit.**

Project type is detected by matching the active directory against the roots defined in `~/.claude/CLAUDE.md`:

| Type | Detection | Behavior |
|------|-----------|----------|
| **corporate** | path starts with `WORK_ROOT` | Offer commit message text + PR description as copy-ready blocks. Never run `git commit` or `git push`. User executes manually. |
| **personal** | path starts with `PERSONAL_ROOT` | Offer commit text. Execute only if user explicitly approves for this project. |
| **unknown** | neither root matches | Ask once per session. Default to personal behavior. |

To update the root paths, edit `## Project Roots` in `~/.claude/CLAUDE.md`. No skill files need changing.

This rule overrides any skill or system behavior that would auto-execute git operations.

## Warning Signs

If you find yourself doing any of these in the conductor window — stop and dispatch instead:
- Reading more than 3 files
- Writing any implementation code
- Running tests
- Making direct file edits to source code
- Processing large research results line-by-line
