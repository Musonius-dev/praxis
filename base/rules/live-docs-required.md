# Live Documentation Requirement — Rules
# Scope: All code touching external libraries, frameworks, or APIs
# Enforces Context7-first + Perplexity Sonar fallback for documentation freshness

## Invariants — BLOCK on violation

### Context7 is ALWAYS required before generating dependency code
Before writing any code that uses an external library, framework, or API:
1. Call `resolve-library-id` with the package name to get the Context7 ID
2. Call `get-library-docs` with that ID and the specific topic
3. Use ONLY the returned documentation — not training-data memory
4. Cite the doc version in a comment: `// Docs: <library>@<version> via Context7`

**This is non-negotiable.** Training data has a cutoff. Official docs do not.

### Perplexity Sonar fallback sequence
If `resolve-library-id` returns no results for a library:
1. Query Sonar: `"<library> official documentation site:docs.<domain> OR site:github.com"`
2. Use the returned URL as the documentation source
3. State in output: "Context7 had no index for <library> — sourced from [URL] via Sonar"

Never silently fall back to training data. Always disclose the documentation source.

### Mandatory version verification before install suggestions
Before suggesting `npm install <package>`, `pip install <package>`, or any dependency addition:
1. Context7: resolve the library, confirm current major version
2. Sonar (`sonar` model): search `"<package> latest version site:npmjs.com"` to confirm with date
3. State in output: "Verified: <package>@<version> as of [date]"
4. Never suggest a version from memory alone

## Conventions — WARN on violation

### Auto-trigger conditions
The research pipeline fires AUTOMATICALLY (do not wait to be asked) when:
- Any `npm install <package>` or `pip install <package>` suggestion is generated
- Any new dependency is added to a manifest file
- Any framework or library recommendation appears in a plan
- Any code imports an external package not previously verified in this session

### Sonar model selection
Use the appropriate Perplexity model for each query type:

| Query type | Model | Why |
|------------|-------|-----|
| Version lookup, changelog | `sonar` | Fast, cheap, factual |
| CVE research, security analysis | `sonar-pro` | Better citations, less hallucination on security claims |
| "Should I use X vs Y?" decisions | `sonar-reasoning` | Extended thinking for tradeoff analysis |
| Breach/incident research | `sonar-pro` + `search_recency_filter: "month"` | Restricts to recent results only |

### Query templates (use verbatim)
- Latest version: `"[package] npm latest version site:npmjs.com OR site:github.com"`
- CVE check: `"[package] CVE vulnerability 2025 2026 site:nvd.nist.gov OR site:github.com/advisories"`
- Breaking changes: `"[package] breaking changes migration [version]"`
- Maintenance: `"[package] last commit release 2025 2026 archived"`

### When to use Perplexity Sonar alongside Context7
- **Always**: Version verification (Context7 confirms API surface, Sonar confirms release date)
- **On new deps**: CVE check before adding to any manifest
- **On major upgrades**: Breaking changes search before recommending migration
- **On unfamiliar packages**: Maintenance and activity check

### Session caching rules
- Context7 docs: valid for the entire session — do NOT re-fetch same library
- Sonar version checks: valid for the session (versions don't change mid-session)
- Sonar CVE checks: re-fetch if > 24 hours elapsed (use session timestamp)
- On new session: all caches reset, re-fetch everything fresh

### When Context7 is unavailable
If the MCP server is not running or returns errors:
1. State that docs could not be verified via Context7
2. Fall back to Perplexity Sonar for documentation lookup
3. If both are unavailable: flag the specific method/API as "unverified against current version"
4. Proceed with best-knowledge implementation but mark for review

For comprehensive research (CVEs + maintenance + version), use `/research <package>`.

---

## Removal Condition
Remove when training data freshness is guaranteed to match live documentation,
or when a built-in documentation verification mechanism replaces MCP-based lookups.
