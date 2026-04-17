# Conductor Discipline

The conductor orchestrates — it never implements.

## The 5 Rules

### 1. Never implement in the main window
Code edits, file writes, or test runs → dispatch an agent. Even for XS tasks. Conductor only reads results.

### 2. Context budget: 5 lines per state summary
Before dispatching, emit: `Task: {id} — {desc}` | `Type: {type}` | `Model: {model}` | `Scope: {path}` | `Output: {path}`. No full file dumps. No code in main window.

### 3. Handoff contract
Every agent receives exactly: task type + description, path to scope doc, permitted files list, definition of done, output path. Nothing else — if agent needs more, fix the scope doc first.

### 4. Status return — done log only
Agent writes `.devwork/{type}/{id}/status.md` on completion. Conductor reads only this file: `## Current` → `## Done` → `## Session Log`. Do NOT read full agent output.

### 5. Model assignment at dispatch time
Never leave model implicit. Every Agent call must specify `model: "sonnet"` or `model: "opus"` per model assignment guide.

## Script-and-Defer
Never run builds, deploys, compressions, syncs directly. Write a `.sh` script → tell user to run in another terminal.

## Warning Signs
Stop and dispatch if you're: reading 3+ files | writing implementation code | running tests | making source edits | processing large research line-by-line.
