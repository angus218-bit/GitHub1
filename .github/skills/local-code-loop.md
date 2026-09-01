# Skill: local-code-loop

**Purpose:** Execute the edit → test → verify cycle with minimal latency and risk.

**Trigger:** When making code changes (bug fix, feature, refactor).

**Execution:**

1. **Scope the change** — understand what file(s) to edit.
2. **Make targeted edit** — smallest diff that solves the problem.
3. **Run relevant test** — single test file or module (not full suite unless needed).
4. **Verify pass** — if fail, re-check error, don't loop endlessly.
5. **Commit & PR** — use `safe-git` skill for message.

**Edit Checklist:**

- [ ] Read file end-to-end before editing (context).
- [ ] Make one logical change per commit.
- [ ] Test immediately after.
- [ ] No unrelated reformatting.
- [ ] Update docs/comments if needed.

**Test Checklist:**

- [ ] Run smallest targeted test that covers change.
- [ ] Pass? → Commit.
- [ ] Fail? → Inspect error. Root cause in change or env?
- [ ] Block on 2nd consecutive fail without fix.

**Failure Recovery:**

- First fail: Inspect error, try fix.
- Second fail without clear fix: Flag as blocker, ask user.
- Do not retry same approach 3+ times (diminishing returns).

**Example:**

```bash
# Scenario: Fix typo in login.ts

# 1. Read file
view src/auth/login.ts

# 2. Edit (1 line change)
edit src/auth/login.ts (old_str → new_str)

# 3. Test
npm test -- tests/auth/login.test.ts

# 4. Verify
# PASS → Commit
# FAIL → Inspect error, fix, re-test (1x only)

# 5. Commit
git commit -m "Fix: correct password validation typo in login.ts"
```

**Notes:**
- Latency > rework loops. Fix once, test once, commit.
- Avoid full test suite unless change is broad.
- Document why change was made in commit message.
