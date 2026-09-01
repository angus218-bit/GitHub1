# Prompt: pr-review.prompt.md

**Trigger:** When a PR is opened or updated in this repo.

**Copilot Code Review Instructions:**

Run this checklist on every PR:

```markdown
## Automated PR Review

### 🔍 Code Quality
- [ ] **Linting:** Run `[lint command]` — any failures?
- [ ] **Testing:** Run `[test command]` — all pass? Coverage ok?
- [ ] **Types:** Any `@ts-ignore` or `any` types? Justified?

### 🔒 Security & Data
- [ ] **Secrets scan:** Grep for `password|api_key|token|secret` — found any?
- [ ] **Inputs validated:** User input sanitized? SQL injection risk?
- [ ] **Auth gates:** Endpoints protected correctly?
- [ ] **PII:** No family names, SSNs, addresses?

### 📝 Documentation
- [ ] **Docs updated:** Public API or config changed? Documented?
- [ ] **Comments clear:** Complex logic explained?
- [ ] **Examples:** New feature gets usage example?

### 📦 Dependencies
- [ ] **New deps:** Added? Pinned to version? License compatible?
- [ ] **Removed deps:** Safe to remove (no indirect deps)?
- [ ] **Version bumps:** Any major bumps? Documented breaking changes?

### 🚀 Deployment & Risk
- [ ] **Breaking changes:** Any? Documented migration path?
- [ ] **Backward compatible:** Old clients still work?
- [ ] **Zero-downtime:** Can this deploy without service interruption?
- [ ] **Rollback plan:** If needed, can we revert safely?

### ✅ Approval Decision

**Result:** [✅ Approved | ⏳ With suggestions | 🛑 Request changes]

**Summary:** [1–2 sentences: overall assessment]

**Blockers (if any):**
- [ ] Blocker 1: [describe, link to line]
- [ ] Blocker 2: [describe, link to line]

**Suggestions (non-blocking):**
- Suggestion 1: [describe, explain why]
- Suggestion 2: [describe, explain why]
```

## Review Depth Tiers

**Tier 1: Docs / Config (5 min)**
- Changes only `.md`, `.yaml` config, or comments.
- Verify: Spelling, structure, no broken links.

**Tier 2: Small logic change (15 min)**
- < 100 lines changed, single concern (bug fix or small feature).
- Verify: Logic is correct, tests pass, no side effects.

**Tier 3: New feature (30+ min)**
- New files, API changes, or risky changes.
- Verify: All items in checklist above. Deep dive into design.

**Tier 4: Security-critical (60+ min)**
- Auth, payments, secrets, or user data.
- Verify: Threat modeling, input validation, access control.

## Comment Template

```markdown
**🔴 Blocking: [Title]**

Location: `src/auth.ts:42`

Issue:
```typescript
// Before (vulnerable to injection)
const query = `SELECT * FROM users WHERE id = ${userId}`;
```

Fix:
```typescript
// After (parameterized query)
const query = 'SELECT * FROM users WHERE id = ?';
db.execute(query, [userId]);
```

Why: Raw string interpolation allows SQL injection. Always use parameterized queries.

See: [OWASP SQL Injection](https://owasp.org/www-community/attacks/SQL_Injection)
```

## Notes

- Be concise but thorough.
- Explain *why*, not just *what*.
- Link to relevant docs, examples, or prior PRs.
- Assume good intent; be constructive.
- Blockers stop the merge; suggestions are educational.
