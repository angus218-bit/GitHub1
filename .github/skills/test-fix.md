# Skill: test-fix

**Purpose:** Root-cause failing tests or broken builds; suggest and validate fixes.

**Trigger:** When CI fails, test breaks, or build errors occur.

**Execution:**

1. **Capture error** — full error output, stack trace, context.
2. **Identify root cause** — is it the code change, test setup, dependency, or env?
3. **Suggest fix** — link to the problematic line(s).
4. **Validate** — apply fix, re-run test, confirm pass.

**Diagnosis Tree:**

```
Test fails?
├─ Stack trace points to code change?
│  └─ Logic error, type mismatch, async issue
│     → Fix code (use local-code-loop)
├─ Stack trace points to missing import / undefined var?
│  └─ Missing dependency, typo
│     → Install package or fix name
├─ Error: "Cannot find module X"?
│  └─ Package not installed, wrong path
│     → `npm install` or `pip install`
├─ Error: "Timeout" or "Port in use"?
│  └─ Test env issue, prior test not cleaned up
│     → Kill process or fix teardown
└─ Error: unclear, not code-related?
   └─ Ask user for more context
```

**Fix Validation:**

- [ ] Error output matched root cause.
- [ ] Fix applied and change is minimal.
- [ ] Test re-run: Pass.
- [ ] No side effects (other tests still pass).

**Example:**

```
Error: TypeError: Cannot read property 'login' of undefined

Stack:
  at src/auth/login.test.ts:10
  at ...

Root cause: `login.ts` exports default, test imports named export.

Fix:
  - File: src/auth/login.test.ts
  - Change: import { login } to import login

Validation:
  - Re-run: npm test -- login.test.ts
  - Result: PASS ✓
```

**Notes:**
- One fix per test failure (don't guess).
- Document why the fix works in commit message.
- If fix is unclear, ask user before applying.
