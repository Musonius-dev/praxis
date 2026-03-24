# Praxis

> *"Philosophy must be practiced, not just studied."* — Musonius Rufus

A layered harness for [Claude Code](https://docs.anthropic.com/en/docs/claude-code). Universal workflow discipline + domain-specific AI-Kits + persistent vault integration.

## What it does

Praxis gives Claude Code a three-layer operating system:

**Universal base** — always loaded. Praxis structures work (discuss → plan → execute → verify → simplify → ship). Built-in quality enforcement (debugging, code review, simplification).

**AI-Kits** — activated on demand via `/kit:<name>`. Each kit bundles domain-specific rules, skills, MCP servers, and slash commands. Activate the web-designer kit and your components get design system enforcement, accessibility auditing, and production lint. Deactivate with `/kit:off`.

**Project config** — per-repo rules that fire automatically based on file paths. Terraform rules load when you touch `.tf` files. GitHub Actions rules load when you touch workflow YAML. No manual switching.

## Quick start

```bash
npx @esoteric-logic/praxis-harness@latest
```

One command. Copies rules, commands, skills, and kits directly into `~/.claude/`. Node.js 18+ must be installed first.

> **Always use `@latest`** — `npx` caches packages locally. Without `@latest`, you may get a stale version on machines that installed previously.

**Subsequent commands:**
```bash
npx @esoteric-logic/praxis-harness@latest update      # re-copy from latest npm version
npx @esoteric-logic/praxis-harness@latest health      # verify install integrity
npx @esoteric-logic/praxis-harness@latest uninstall   # remove Praxis-owned files from ~/.claude/
```

## After install

Verify with `/help` — you should see Praxis commands (`/discuss`, `/execute`, `/verify`, `/plan`, `/ship`, `/kit:*`).

## Workflow

The standard Praxis workflow for feature development:

```
/standup           → orient (reads status.md, surfaces stale state)
/discuss       → frame the problem (conversational, scope guard)
/discover          → research options with confidence levels (before /spec)
/plan    → plan milestones (with dependency ordering + boundaries)
/execute       → implement one milestone at a time (file-group isolation)
/verify        → validate (test/lint/typecheck/build, self-review, UNIFY)
/session-retro     → capture learnings, update vault
```

For pure bugfixes: `/debug` (test-first debugging, skips the full loop).
For code review: `/review` (launches subagent review at any time).
For technical research: `/discover` (structured options evaluation before decisions).

## Commands

| Command | Purpose |
|---------|---------|
| `discuss` | Conversational problem framing, SPEC synthesis, scope guard |
| `execute` | Implement one milestone with file-group isolation + boundary enforcement |
| `verify` | Validate milestone (test/lint/build), self-review, UNIFY phase summary |

| `plan` | Create a dated work plan with milestone dependencies + checkpoints |
| `spec` | Create a structured spec or ADR with conflict detection |
| `discover` | Structured technical discovery with confidence-rated options |
| `standup` | Session-start orientation from vault state |
| `risk` | Add a risk register entry to the vault |
| `kit` | Activate/deactivate an AI-Kit |
| `review` | Manual code review via subagent |
| `simplify` | Post-implementation code simplification via subagent |
| `debug` | Structured test-first debugging |
| `ship` | Commit, push, and PR in one command with pre-flight checks |
| `verify-app` | End-to-end verification with regression analysis |
| `session-retro` | End-of-session retrospective with learnings extraction |
| `status-update` | Manual vault status.md update |
| `context-reset` | Reload context from vault without clearing session |

## Rules

15 rules across universal and scoped categories. Universal rules load every session. Scoped rules load only when matching file patterns are detected.

Key additions in this version:
- **context-management** — context brackets (FRESH/MODERATE/DEPLETED/CRITICAL) adapt behavior to session stage
- **vault** — Obsidian vault integration

## Architecture

```
┌────────────────────────────────────────┐
│  Project config                        │
│  .claude/rules/*.md (path-scoped)      │
├────────────────────────────────────────┤
│  AI-Kit (/kit:web-designer)            │
│  Skills chain + domain rules + MCPs    │
├────────────────────────────────────────┤
│  Universal base (always loaded)        │
│  Praxis workflow engine                 │
├────────────────────────────────────────┤
│  Vault layer                           │
│  Obsidian                              │
├────────────────────────────────────────┤
│  Claude Code                           │
│  ~/.claude/ + plugins + subagents      │
└────────────────────────────────────────┘
```

**Workflow hierarchy:** Praxis owns the outer loop (discuss → plan → execute → verify → simplify → ship). Kits inject domain context into this workflow — they don't replace it.

## Available kits

| Kit | Activate | What it does |
|-----|----------|-------------|
| web-designer | `/kit:web-designer` | Design system init → component build → accessibility audit → production lint |
| infrastructure | `/kit:infrastructure` | Terraform plan → apply → drift detection → compliance check |

More kits coming. See `docs/creating-a-kit.md` to build your own.

## Vault integration

Praxis integrates with an Obsidian vault for project state, session learnings, and architecture decisions.

The vault path is configured per machine during install:

```json
{
  "vault_path": "/Users/you/Documents/Obsidian",
  "vault_backend": "obsidian",
  "vault_name": "My Vault",
  "repo_path": "/Users/you/repos/praxis"
}
```

Requires [Obsidian CLI](https://obsidian.md) (enable in Obsidian Settings > General > Command line interface). Obsidian must be running for vault search.

### What gets documented automatically

Praxis auto-documents your work in the vault with zero manual effort. Two independent layers ensure nothing is lost:

1. **Shell hooks** capture facts (git state, timestamps) even if Claude runs out of context
2. **Stop prompt** captures meaning (summaries, decisions, learnings) from conversation context

**At session end** (zero action needed):
- `status.md` — updated with What/So What/Now What
- `claude-progress.json` — session entry with summary, accomplishments, milestones, features
- `notes/{date}_session-note.md` — session summary, decisions, learnings, next steps
- `notes/decision-log.md` — checkpoint decisions, scope changes (appended)
- `notes/learnings.md` — [LEARN:tag] pattern entries (appended)
- `specs/` — ADRs for architectural decisions made during the session

**During workflow skills** (automatic within each skill):

| Skill | Auto-writes to vault |
|-------|---------------------|
| `/execute` | `status.md` loop position, `decision-log.md` scope events |
| `/verify` | `claude-progress.json` milestones[] |
| `/review` | `specs/review-{date}-{slug}.md` (full findings breakdown) |
| `/simplify` | `notes/{date}_simplify-findings.md` |
| `/debug` | `notes/{date}_debug-trace.md` |
| `/verify-app` | `specs/verify-app-{date}-{slug}.md` |
| `/ship` | `claude-progress.json` features[] |

**On context compaction** (automatic fallback):
- `plans/{date}-compact-checkpoint.md` — git state, active plan, loop position
- `claude-progress.json` — session entry preserved

## Updating

### Updating the harness

```bash
npx @esoteric-logic/praxis-harness@latest update
```

Re-copies all hooks, skills, rules, and kits from the latest npm package version. Config file is preserved.

> **Always use `@latest`** to avoid `npx` serving a cached older version.

### Updating existing projects

After a harness update that adds new vault files (like `decision-log.md`), run `/scaffold-exist` in a Claude Code session to audit your vault and add any missing files. This is non-destructive — it never overwrites existing content.

```
Step 1: npx @esoteric-logic/praxis-harness@latest update   → deploys new hooks, skills, rules
Step 2: /scaffold-exist                                      → audits vault, adds missing files
```

New projects get everything automatically via `/scaffold-new`.

## Uninstalling

```bash
npx @esoteric-logic/praxis-harness@latest uninstall
```

Removes all Praxis-owned files from `~/.claude/`. Does not delete config, vault templates, or installed plugins.

## Development

```bash
git clone https://github.com/arcanesme/praxis.git
cd praxis
bash install.sh
```

The git-clone + `install.sh` path uses symlinks instead of copies, so edits in the repo are immediately reflected.

## Requirements

- macOS or Linux
- Claude Code CLI
- Node.js 18+
- Obsidian with CLI enabled (for vault integration)

## License

MIT
