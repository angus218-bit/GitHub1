# Prompt: open-pr.prompt.md

**Trigger:** When Copilot opens a new PR in this repo.

**Template for PR Description:**

```markdown
## Summary
[One-liner: what problem does this PR solve?]

## Changes
- [Bullet 1: what was changed]
- [Bullet 2: what was changed]
- [Bullet 3: impact or side effects]

## Testing
- [ ] All tests pass: `[command]`
- [ ] New tests added for this change
- [ ] Manual testing: [describe steps]

## Checklist
- [ ] Commit message is clear (see AGENTS.md: safe-git skill)
- [ ] No `.env`, secrets, or PII committed
- [ ] Docs updated (if API/behavior changed)
- [ ] No unrelated formatting changes
- [ ] Ready for review

## Risk Assessment
- **Risk level:** [ ] Low | [ ] Medium | [ ] High
- **Breaking changes:** [ ] None | [ ] Yes (migration path documented)
- **Performance impact:** [ ] None | [ ] Measured and acceptable

## Reviewer Hints
- Start review at: [file and line if applicable]
- Key insight: [what makes this non-obvious]
- QA: [edge cases to test manually]

## Linked Issue
Fixes #[ISSUE_NUMBER] (if applicable)

---

**Copilot reference:** See `.github/skills/` for execution details.
**Project rules:** See `AGENTS.md` for guardrails.
```

**Pre-PR Checklist (run before opening):**

1. Branch name is descriptive: `feature/auth-jwt` or `fix/login-typo`
2. All tests pass locally.
3. Commit messages are clear (problem → solution).
4. No secrets in code.
5. Risk assessment is honest (don't downplay).
6. If high-risk, PR description is extra detailed.

**After PR Opens:**

- Copilot's pr-review skill will run automated checks.
- User review happens via GitHub.
- Merge only after `approved`.
