# Memory Boundary — Rules
# Scope: All projects, all sessions
# Defines what goes where across CLAUDE.md, MEMORY.md, and Obsidian vault

## Invariants — BLOCK on violation

### CLAUDE.md rules always win
- If a MEMORY.md entry conflicts with a CLAUDE.md rule or base/ rule, the rule wins.
- Never override architectural decisions, coding standards, or workflow sequences via auto-memory.
- Auto-memory supplements rules — it does not replace them.

### No architectural decisions in MEMORY.md
- Architecture decisions, design patterns, and system constraints belong in CLAUDE.md or Obsidian vault specs/.
- If Claude discovers a decision-worthy pattern during a session, surface it to the user for CLAUDE.md or vault — do not write it to MEMORY.md.

### MEMORY.md cap
- Keep MEMORY.md under 80 lines. Use topic files for overflow.
- Prefer linking to Obsidian vault notes over expanding MEMORY.md.
- If MEMORY.md exceeds 80 lines: run `/sync-memory` before continuing.
- The 200-line hard limit means lines beyond 200 are silently dropped — the 80-line cap leaves headroom for topic file index entries.

## Conventions — WARN on violation

### What belongs where

| Content | Destination | Managed by |
|---------|-------------|------------|
| Coding standards, workflows, architecture | `CLAUDE.md` / `base/rules/` | User (Praxis) |
| Build quirks, CLI flags, error patterns | `MEMORY.md` | Claude (auto-memory + auto-dream) |
| Architecture decisions, project status, session summaries | Obsidian vault | User (via Praxis skills) |
| Kit configs, path-scoped rules | `kits/` and `base/rules/` | User (Praxis) |
| Stale or conflicting memory entries | Deleted | Auto-dream consolidation or `/sync-memory` |

### Auto-memory territory (appropriate for MEMORY.md)
- Build commands and environment quirks Claude discovers
- Debugging insights specific to this working tree
- API gotchas, error patterns, CLI flags that worked
- User preferences Claude infers from corrections
- Tool configuration that varies per machine

### Not auto-memory territory (redirect elsewhere)
- Decisions that affect system design → CLAUDE.md or vault specs/
- Cross-project learnings → vault notes/learnings.md
- Session summaries → vault notes/ (auto-documented by Stop hook)
- Task tracking → vault tasks.md
- Plans and milestones → vault plans/

### Dream and consolidation
- Run `/dream` (if available) between sessions to consolidate stale memory
- Run `/sync-memory` to bridge durable insights from MEMORY.md to Obsidian vault
- Auto-dream fires automatically after 24h + 5 sessions — the memory-boundary rules guide what it keeps vs prunes
- After `/dream` or auto-dream runs: verify MEMORY.md is under 80 lines

## Removal Condition
Remove when Claude Code provides native memory scoping that respects rule hierarchies
and vault integration without manual boundary enforcement.
