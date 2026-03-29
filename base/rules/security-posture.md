# Security Posture — Rules
# Scope: All projects, all sessions
# Three-layer enforcement model for credential and filesystem protection

## Invariants — BLOCK on violation

### Three-Layer Sandbox Model
Layer 1: Claude Code native sandbox (`failIfUnavailable: true`, `allowUnsandboxedCommands: false`)
Layer 2: Kernel enforcement (if installed) — blocks access to sensitive system paths at OS level
Layer 3: Praxis hooks — `credential-guard.sh`, `file-guard.sh`, `secret-scan.sh`

All three layers are independent. A failure in one does not disable the others.

### Protected Paths — Never Touch
These paths must never be read, written, listed, or suggested in any Bash command:
- `~/.ssh/` — SSH keys and config
- `~/.aws/` — AWS credentials and config
- `~/.azure/` — Azure CLI tokens
- `~/.kube/` — Kubernetes configs with cluster creds
- `~/.gnupg/` — GPG private keys
- `~/.docker/config.json` — Docker registry auth
- `~/Library/Keychains/` — macOS Keychain (secrets store)
- `~/.config/gcloud/` — GCP credentials
- `~/.praxis/secrets` — Praxis managed secrets

Enforcement: `credential-guard.sh` (PreToolUse:Bash) blocks commands referencing these paths.
Exceptions: verification commands only (`gh auth status`, `ssh-keygen -l`, `aws sts get-caller-identity`).

### Protected File Patterns — Never Write
These file patterns must never be created or overwritten:
- `*.pem`, `*_rsa`, `*_ed25519`, `*.p12`, `*.pfx` — private keys and certs
- `.env` files committed to git — use `~/.praxis/secrets` via env var injection

Enforcement: `file-guard.sh` (PreToolUse:Write) blocks writes to protected paths.
Additional patterns can be declared in project CLAUDE.md `## Protected Files` section.

### Secrets — Never in Code
Never write API keys, passwords, tokens, or credentials into:
- Source files, config files, or `.env` files committed to git
- Log output, stdout, or comments
- Commit messages or PR descriptions

Enforcement: `secret-scan.sh` (PreToolUse:Write|Edit) scans for credential patterns.
Canonical patterns are defined in `base/skills/secret-scan/SKILL.md` — do not duplicate.

Always use: environment variables loaded from `~/.praxis/secrets` or platform secret stores.

## Conventions — WARN on violation

### Supply Chain Awareness
Before recommending any package:
1. Verify it exists on the official registry (npmjs.com, pypi.org, crates.io)
2. Check download count (< 1000 weekly = high risk, justify or avoid)
3. Check last publish date (> 12 months with no activity = flag)
4. Never recommend packages with CRITICAL CVEs without stating so

See `base/rules/dependency-freshness.md` for SLA-based enforcement.

---

## Removal Condition
Permanent. Security posture rules apply regardless of project type or stack.
