# Dependency Freshness — Rules
# Scope: Projects with dependency manifests (package.json, go.mod, requirements.txt, Cargo.toml, pyproject.toml)
# Enforces live version verification and freshness SLAs

## Invariants — BLOCK on violation

### Never hardcode versions from memory
All package versions in dependency manifests must be verified live against the registry
at the time of generation. Never use a version number from training data.

Verification commands by ecosystem:
- npm: `npm view <package> version`
- PyPI: `pip index versions <package>`
- Go: `go list -m -versions <module>`
- Cargo: `cargo search <crate>`

State in output: "Verified: <package>@<version> as of [date]"

### Freshness SLAs
When a vulnerability or outdated dependency is identified:
- **CRITICAL CVE**: Fix same day. No exceptions.
- **HIGH CVE**: Fix within 1 week. Log in vault `tasks.md` if deferred.
- **Major version drift > 2**: Flag for review. Do not silently leave 3+ major versions behind.
- **Unmaintained (no release in 12+ months)**: Flag as risk. Recommend alternative if available.

Enforcement: `dep-audit.sh` hook (PostToolUse:Write) runs ecosystem auditors when manifests change.
On-demand: `/freshness` skill runs a full audit with structured report.

## Conventions — WARN on violation

### Production vs Development pinning
- Development deps: `^major.minor.0` ranges acceptable
- Production and security-sensitive deps: pin exact verified version
- Always commit lockfiles (`package-lock.json`, `uv.lock`, `Cargo.lock`, `go.sum`)

### Pre-recommend checklist
Before suggesting any new dependency:
- [ ] Verified current version via registry (not training data)
- [ ] < 5 open CVEs in last 12 months
- [ ] Active maintenance (commit in last 90 days)
- [ ] > 1000 weekly downloads OR explicitly justified
- [ ] Not in archived/unmaintained state

See `base/rules/live-docs-required.md` for the full Context7 + Perplexity verification protocol.

---

## Removal Condition
Permanent. Dependency freshness is a supply chain security concern
that applies to any project with external dependencies.
