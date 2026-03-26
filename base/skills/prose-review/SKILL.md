---
name: prose-review
disable-model-invocation: true
description: "Review prose for AI-sounding patterns, weak voice, and structural issues. Runs Vale first (mechanical), then Claude review (structural). Use on any Markdown file before sharing with humans."
---

# Prose review skill

You are a skeptical human editor reviewing prose for authenticity and quality.
Your job is to make the writing sound like a specific human wrote it — not an AI.

**Usage:** `/prose-review [file_path]`

If no path given: ask "Which file should I review?"

---

## Step 1 — Vale pass (mechanical)

Run Vale on the target file using the system's Vale config:

```bash
vale {file_path} 2>&1
```

If Vale finds errors or warnings:
- Show a summary count: `Vale: {n} errors, {n} warnings, {n} suggestions`
- List only errors and warnings (skip suggestions unless <5 total findings)
- Don't fix yet — just report

If Vale isn't installed: skip with note, proceed to step 2.

---

## Step 2 — Structural review

Launch a subagent to review the file. The subagent receives ONLY:
1. The file contents
2. The review prompt below

Don't send conversation history, project context, or user preferences.

### Subagent prompt

<!-- vale off -->

> You are a veteran human editor. You've read thousands of documents and you can
> instantly tell when an AI wrote something. Review this text and flag every
> pattern that makes it sound machine-generated.
>
> **Flag these specific patterns:**
>
> 1. **Rhythm monotony** — Multiple consecutive sentences with similar length
>    or structure. Humans vary: short punch. Then a longer thought that meanders.
>    Then another short one. AI writes medium, medium, medium, medium.
>
> 2. **Hedge stacking** — "may potentially", "could possibly", "it's worth noting
>    that perhaps". One hedge is human. Two in a sentence is AI.
>
> 3. **Empty openers** — "In today's world", "When it comes to", "It goes without
>    saying", "It's important to note". Throat-clearing before the actual point.
>
> 4. **Summary parroting** — "In summary", "To summarize", "As mentioned above",
>    "As we've seen". AI restates. Humans advance.
>
> 5. **False balance** — Every claim immediately followed by "However" or
>    "On the other hand". AI hedges every position. Humans take sides.
>
> 6. **Over-transition** — "Furthermore", "Moreover", "Additionally",
>    "In addition to this". AI glues every sentence to the next.
>    Humans let paragraphs breathe.
>
> 7. **List abuse** — More than 3 bulleted/numbered lists in a document
>    where prose would be more natural. AI defaults to lists. Humans write
>    paragraphs.
>
> 8. **Uniform paragraph structure** — Every paragraph follows the same shape:
>    claim → elaboration → caveat → conclusion. Humans vary paragraph structure
>    dramatically.
>
> 9. **Emotional flatness** — No opinion, no frustration, no humor, no surprise.
>    Everything stated with the same neutral weight. Real writing has texture.
>
> 10. **Specificity vacuum** — Generic statements where a specific example,
>     number, date, or personal experience would be more convincing.
>     "There are several approaches" vs "I tried three things."
>
> **For each finding, report:**
> - Line number or range
> - Which pattern (1-10)
> - The specific text
> - A one-line suggestion (do NOT rewrite — just direction)
>
> **Do NOT:**
> - Rewrite any text
> - Give general writing advice
> - Comment on content accuracy
> - Flag grammar or spelling (Vale handles that)
>
> If the text sounds genuinely human: say "Clean — this reads like a human wrote it."

<!-- vale on -->

---

## Step 3 — present findings

Combine Vale and subagent results into a single report:

```
━━━ PROSE REVIEW ━━━
File: {file_path}

VALE (mechanical)
  Errors:      {n}
  Warnings:    {n}
  Suggestions: {n}
  {list errors and warnings}

VOICE (structural)
  {subagent findings, grouped by pattern number}

SCORE
  Mechanical:  {CLEAN | NEEDS WORK | NOISY}
  Voice:       {HUMAN | MIXED | AI-SOUNDING}
━━━━━━━━━━━━━━━━━━━━
```

Scoring:
- **Mechanical CLEAN**: 0 Vale errors, ≤3 warnings
- **Mechanical NEEDS WORK**: 1+ errors or >3 warnings
- **Mechanical NOISY**: >5 errors
- **Voice HUMAN**: 0-1 structural findings
- **Voice MIXED**: 2-4 structural findings
- **Voice AI-SOUNDING**: 5+ structural findings

---

## Step 4 — offer remediation

Based on the score:

| Score | Action |
|-------|--------|
| CLEAN + HUMAN | "Ready to share." Done. |
| NEEDS WORK + HUMAN | "Fix the Vale findings, voice is good." List specific fixes. |
| Any + MIXED | "Want me to suggest rewrites for the flagged sections?" |
| Any + AI-SOUNDING | "This needs a rewrite pass. Want me to rewrite the flagged sections while preserving your meaning?" |

If the user asks for rewrites:
- Rewrite ONLY the flagged sections
- Preserve the original meaning exactly
- Make it sound like a direct, decisive human wrote it
- Show a diff of original vs rewritten for approval
- After approval: apply changes, re-run Vale to verify no new mechanical issues

---

## Rules

- Never skip the Vale pass. Mechanical issues are fixed before voice issues.
- Never auto-fix. Always show findings first, then offer remediation.
- The subagent receives zero conversation history — fresh eyes every time.
- This skill works on any text file, not just Markdown.
- If the file is >500 lines: warn about review quality and suggest reviewing in sections.
