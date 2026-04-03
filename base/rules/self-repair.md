# Self-Repair — Rules
# Scope: All projects, all sessions
# Structured recovery protocol for repeated failures

## Recovery Escalation — Invariants (BLOCK on violation)

### Attempt tracking
Track consecutive failures on the same task. A "failure" is:
- Test failure after implementation
- Lint error after fix attempt
- User correction of the same issue
- Build failure after code change

### Escalation ladder

| Attempt | Action |
| ------- | ------ |
| 1st failure | Fix the specific error. Re-validate. |
| 2nd failure (same issue) | Step back. Re-read the relevant code and spec. Try a different approach. |
| 3rd failure (same issue) | STOP. Report What / So What / Now What. Do not attempt a 4th fix. |

This is already in `execution-loop.md` as "Stop-and-Fix Rule." This rule adds
the structured escalation between attempts.

### Strategy rotation on 2nd failure
When the first fix doesn't work, rotate strategy before retrying:

| Failed strategy | Try instead |
| --------------- | ----------- |
| Modify existing code | Rewrite the function from scratch |
| Add logic | Remove logic (simplify) |
| Fix forward | Revert to last working state, approach differently |
| Local fix | Check if the problem is upstream (caller, input, config) |

### 3rd failure report format
```
STOP — REPAIR FAILED
━━━━━━━━━━━━━━━━━━━━━
What:    {exact error after 3 attempts}
So What: {root cause hypothesis — why all 3 attempts failed}
Now What: {recommended next step — different approach, user input, or scope change}
━━━━━━━━━━━━━━━━━━━━━
```

## Anti-Patterns — Conventions (WARN on violation)

- Do NOT retry the identical fix. If attempt 1 failed, attempt 2 must differ.
- Do NOT add complexity to fix a failure. If the fix is more complex than the original code, the approach is wrong.
- Do NOT blame the tooling. If tests fail, the code is likely wrong.
- Do NOT suppress errors to make validation pass. Fix the root cause.

## Removal Condition
Remove when Claude Code provides native failure tracking and strategy rotation.
