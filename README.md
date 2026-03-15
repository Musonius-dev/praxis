# Praxis

> Disciplined action. Theory without action is idle; action without theory is reckless.

A layered harness for Claude Code that turns AI-assisted development into compounding value.

## Install

### Quick (recommended)

```bash
npx praxis-harness install --vault ~/Documents/Obsidian
```

### With Perplexity deep research

```bash
PERPLEXITY_API_KEY=pplx-xxx npx praxis-harness install --vault ~/Documents/Obsidian
```

### Bash alternative (no Node.js required)

```bash
git clone https://github.com/arcanesme/praxis.git ~/praxis
bash ~/praxis/install.sh --vault ~/Documents/Obsidian
```

This copies the harness into `~/.praxis/` and symlinks the base layer into `~/.claude/`.

## Architecture

```
┌────────────────────────────────────────┐
│  Project config                        │
│  .claude/rules/*.md (path-scoped)      │
├────────────────────────────────────────┤
│  AI-Kit (/kit:<name>)                  │
│  Domain rules + commands + MCPs        │
├────────────────────────────────────────┤
│  Universal base (always loaded)        │
│  GSD → Superpowers → Ralph             │
└────────────────────────────────────────┘
```

**Universal base** — Always active. Rules, commands, and skills loaded via symlinks.

**AI-Kits** — Domain-specific extensions activated with `/kit:<name>`. Idempotent.

**Project config** — Per-repo `.claude/rules/` with path-scoped frontmatter.

## Commands

| Command | Purpose |
|---------|---------|
| `/spec` | Generate WHAT / DONE-WHEN / CONSTRAINTS / NON-GOALS spec |
| `/plan` | Generate checkable milestone plan (requires approved spec) |
| `/standup` | Yesterday / Today / Blockers from claude-progress.json |
| `/risk` | Risk register for current task |
| `/kit:<name>` | Activate an AI-Kit (`/kit:off` to deactivate) |

## Skills

| Skill | Purpose |
|-------|---------|
| `/scaffold-new` | Bootstrap a new project into the harness |
| `/scaffold-exist` | Retrofit harness onto an existing project |
| `/pre-commit-lint` | Run lint/format/type-check before commit |
| `/session-retro` | End-of-session learnings + progress update |
| `/vault-gc` | Vault entropy check |

## Available Kits

| Kit | Activation | Purpose |
|-----|-----------|---------|
| Web Designer | `/kit:web-designer` | Design systems, components, a11y, responsive |

## Structure

```
base/
  CLAUDE.md              Global identity + rules + kit registry
  rules/                 Universal + path-scoped rules
  commands/              Slash commands
  skills/                Invocable skills

kits/
  web-designer/          First domain kit

templates/               Reusable templates for projects + vault
docs/                    Architecture + kit creation guide
```

## Update

```bash
npx praxis-harness@latest update
```

## Uninstall

```bash
npx praxis-harness uninstall
```

## Status

```bash
npx praxis-harness status
```

## Security

This repo is safe for public use. All secrets stay local:

- **API keys** — Stored in `~/.claude.json` by `claude mcp add`, never in repo files
- **Vault path** — Written to `~/.claude/praxis.config.json`, which is gitignored
- **`.env` files** — Gitignored by default

**Never commit** API keys, vault paths, or credentials to this repo.

## License

MIT
