---
description: Post-implementation code cleanup. Launches a subagent to find and
  simplify over-abstraction, dead paths, verbosity, and missed idioms in the
  recent diff. Run after implementation, before /verify-app or /ship.
---

Invoke the code-simplifier skill on the current project's recent changes.

Accept an optional scope argument:
- No argument → `git diff HEAD~1` (default)
- `staged` → staged changes only
- `HEAD~N` or SHA → specific range

The code-simplifier skill handles all phases: scope detection, subagent launch,
finding presentation, user-approved edits, and optional [LEARN:simplify] capture.
