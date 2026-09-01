# Skill: pr-review

**Purpose:** Automated and manual pull request review for logic, security, style, and risk.

**Trigger:** On PR open or user request for review.

**Automated Review (via `.github/prompts/pr-review.prompt.md`):**

Runs on every PR:
- [ ] Linting: Does code match project style?
- [ ] Tests: Do tests pass? Coverage ok?
- [ ] Secrets: No hardcoded keys, tokens, passwords?
- [ ] Docs: Updated if public API changed?
- [ ] Dependencies: Any new deps? Pinned versions?
- [ ] Breaking changes: Flagged in description?

**Manual Deep Dive (on request):**

1. **Read diff end-to-end** — understand overall intent.
2. **Check logic** — are conditions correct? Edge cases handled?
3. **Check security** — inputs validated? Injection risk? Auth gates intact?
4. **Check style** — consistent with codebase patterns? Readable?
5. **Check risk** — will this break existing users? Deploy without downtime?

**Review Comment Template:**

```
**[SEVERITY] Finding: [title]**

Line: [file:line_number]
Issue: [describe problem]
Fix: [suggest solution]
Why: [explain impact]

Example:
- Before: `const userId = req.query.id;`
- After: `const userId = parseInt(req.query.id, 10);`
```

**Severity Levels:**

- **🔴 Blocking:** Security hole, logic error, guaranteed breakage.
  - Hold merge until fixed.
- **🟡 Warning:** Style mismatch, missing test, performance issue.
  - Suggest fix; allow merge with discussion.
- **🟢 Info:** Nitpick, refactoring idea, documentation note.
  - Informational; no merge hold.

**Review Checklist:**

- [ ] Code is logically correct.
- [ ] No secrets or PII committed.
- [ ] Tests cover new logic (≥80% coverage if repo tracks it).
- [ ] Docs updated (if API/config changed).
- [ ] No breaking changes without migration path.
- [ ] Performance impact assessed (if relevant).
- [ ] Consistent with codebase style.

**Approval Decision:**

```
✅ Approved — Ready to merge
⏳ Approved with suggestions — Merge after discussion
🛑 Request changes — Block merge until issues addressed
```

**Notes:**
- Assume PR author is well-intentioned; explain *why* not just *what*.
- Link to relevant docs, prior PRs, or commits.
- Automate checks (linting, tests) where possible; review focuses on intent.
