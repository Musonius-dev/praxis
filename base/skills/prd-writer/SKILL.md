---
name: prd-writer
disable-model-invocation: true
description: Structured PRD authoring for Ralph. Gathers context, builds stories,
  validates against Ralph constraints, writes PRD to vault. Invoke manually with
  /prd-writer only. Side-effect skill — never auto-triggers.
allowed-tools: Bash, Read, Write, Edit
---

# prd-writer Skill

## Vault Path Resolution
Read vault_path from `~/.claude/praxis.config.json`. If missing: tell user to run `install.sh`.

## DONE-WHEN
- [ ] PRD written to vault with all stories populated
- [ ] Every story has: role, capability, outcome, done-when, file group, dependencies, estimate
- [ ] No story marked L (must be split before writing)
- [ ] Total stories ≤15
- [ ] ralph_state.prd_path set in claude-progress.json
- [ ] status.md updated with PRD reference
- [ ] qmd index updated

## NON-GOALS
- Does not execute stories — that is Ralph's job
- Does not create plans — use `/plan` for that
- Does not write specs or ADRs — use `/spec` for that

---

## Phase 1 — Gather Context

1. Read `{vault_path}/status.md` — current state and active work
2. Read `{vault_path}/_index.md` — project goals and metadata
3. Ask the user:
   - What is the PRD objective? (one sentence)
   - What area of the codebase does this cover?
   - Any known constraints or dependencies?

## Phase 2 — Build Stories

For each story, collect:
- **Title**: short identifier (e.g., `add-auth-middleware`)
- **As a**: role
- **I want**: capability
- **So that**: outcome
- **Done when**: list of verifiable checks
- **File group**: list of files (max 3 groups per story)
- **Dependencies**: story-ids that must complete first, or "none"
- **Estimate**: S / M / L

Present stories in a table for user review before proceeding.

## Phase 3 — Validate Against Ralph Constraints

For each story, check:
- Completable in ~10k output tokens
- Touches ≤3 file groups
- Requires ≤1 architectural decision
- No cross-story reasoning required
- Estimate is S or M (never L)

Violations:
- L estimate → STOP. Story must be split before PRD is written.
- >3 file groups → STOP. Reduce scope or split.
- Cross-story dependency chains → WARN. Ralph executes stories independently.
- >15 stories total → suggest splitting into multiple PRDs.

## Phase 4 — Write PRD

Use `references/prd-template.md` as the canonical format.

1. Fill all fields. No placeholders may remain.
2. Scan the output for unreplaced `{placeholder}` patterns. Zero must survive.
3. Write to: `{vault_path}/plans/{YYYY-MM-DD}_{kebab-title}-prd.md`

## Phase 5 — Wire State

1. Update `{vault_path}/status.md`:
   - Set `current_plan:` to the PRD path
   - Update `## Now What` with "PRD ready for Ralph execution"
2. Update `{vault_path}/claude-progress.json`:
   - Set `ralph_state.prd_path` to the PRD file path
   - Set `ralph_state.mode` to "idle"
   - Set `ralph_state.completed_stories` to `[]`
   - Set `ralph_state.blocked_stories` to `[]`
3. Run `unset BUN_INSTALL && qmd update`
4. Report:
   ```
   ✓ PRD written:      {path}
   ✓ Stories:           {n} (S: {n}, M: {n})
   ✓ ralph_state:       prd_path set, mode idle
   ✓ status.md:         updated
   ✓ QMD index:         updated

   Next: run /ralph to begin autonomous execution.
   ```

## Error Handling

| Condition | Action |
|-----------|--------|
| All stories marked L | Warn: "No stories are Ralph-suitable. Split or use GSD." |
| >15 stories | Suggest splitting into 2+ PRDs |
| Missing file groups | STOP. Every story needs a file group for Ralph |
| User declines story edits | Write PRD as-is with warnings noted |
| vault_path missing | Tell user to run install.sh |

## Removal Condition
Remove when PRD authoring is fully automated from issue trackers or when Ralph accepts unstructured input.
