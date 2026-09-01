# Skill: safe-git

**Purpose:** Manage commits and branches with clear audit trail and zero risk of secret leaks.

**Trigger:** After local-code-loop confirms tests pass; before merging to main.

**Commit Guidelines:**

1. **Clear message** — problem + solution in 50 chars, detail in body.
2. **No secrets** — never commit `.env`, API keys, tokens, passwords.
3. **No private data** — no family names, SSNs, addresses in public repos.
4. **Co-author trailer** — add if collaborative: `Co-authored-by: Name <email>`

**Commit Message Template:**

```
Fix: [50 chars max — describe problem + solution]

Longer explanation:
- Why this change was needed.
- What problem it solves.
- Any side effects or caveats.

Fixes #ISSUE_NUMBER (if applicable)
Co-authored-by: Copilot App <223556219+Copilot@users.noreply.github.com>
```

**Example:**

```
Fix: correct password validation regex in login.ts

The original regex required a digit, but login form tests were failing
with valid passwords. Updated regex to be less restrictive (min 8 chars,
at least 1 letter). Verified with 42-test suite.

Fixes #203
```

**Branch Management:**

- [ ] Never commit to `main` directly.
- [ ] Create feature branch: `git checkout -b feature/short-name`
- [ ] Push to branch, not main: `git push origin feature/...`
- [ ] Open PR for review.
- [ ] Merge only after user types `approved`.

**Secret Detection Checklist:**

- [ ] No `.env` files committed.
- [ ] No AWS/Azure/GitHub tokens in code.
- [ ] No private keys, certificates.
- [ ] No hardcoded passwords.
- [ ] No family PII (names, SSNs, addresses).

**Pre-commit Hook (optional):**

```bash
# .git/hooks/pre-commit (pseudo-code)
grep -r "api_key\|password\|secret" . || true
grep -r "AWS_\|AZURE_\|GITHUB_" . || true
# Alert if found; let user decide
```

**Notes:**
- Assume main is protected (no direct push).
- PRs are the review gate.
- Revert a bad commit with: `git revert <SHA>`
