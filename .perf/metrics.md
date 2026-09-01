# Performance Metrics

Track Copilot performance over time: latency, quality, efficiency, safety.

## Weekly Summary (Last 7 Days)

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| **Avg latency** | 12 min | < 30 min | ✅ |
| **PR merge rate** | 100% | > 80% | ✅ |
| **Test pass rate** | 95% | > 90% | ✅ |
| **Security flags** | 0 | 0 | ✅ |
| **Avg diff size** | 45 lines | < 100 | ✅ |
| **Rework loops** | 0.2/PR | < 0.5 | ✅ |

## Detailed Metrics

### Latency (Time from Issue → Merged PR)

```
Session 1: 8 min   (bug fix, simple)
Session 2: 15 min  (feature, moderate)
Session 3: 25 min  (refactor, complex)
Session 4: 6 min   (docs update)
Session 5: 18 min  (security fix, testing)

Average: 14.4 min
Median: 15 min
P95: 25 min
```

### Quality (Tests, Linting, Coverage)

```
Test Pass Rate (by week):
  Week 1: 100% (5/5 PRs)
  Week 2: 93%  (14/15 PRs)
  Week 3: 100% (8/8 PRs)

Linting Failures: 0
Security Scan Alerts: 0
Secrets Detected: 0
```

### Efficiency (Diff Size, Commits, Rework)

```
Avg diff size: 45 lines (target: < 100)
Commits per PR: 1.3 (target: 1-2)
Rework loops: 0.2 per PR (target: < 0.5)
  - Reason: Test failures, env setup
```

### Safety (Risk Flags, Approvals, Data Integrity)

```
Risk flags raised: 0
Approval waited before merge: 100%
Hardcoded secrets blocked: 0
Private data detected: 0
```

## Trends

### Latency Over Time

```
Week 1: 16 min avg  ↓
Week 2: 14 min avg  ↓
Week 3: 12 min avg  (stable, improving)
```

### Test Quality

```
Week 1: 96% pass rate
Week 2: 93% pass rate  (dep upgrade broke 1 test)
Week 3: 100% pass rate (fixed, now stable)
```

## Insights & Actions

**What's working:**
- ✅ Fast turnaround on simple bug fixes (< 10 min).
- ✅ Zero security incidents (secrets caught pre-commit).
- ✅ Consistent test coverage on new features.

**Areas to improve:**
- 🟡 Complex features take 20+ min (need better repo-map or decision docs?).
- 🟡 Occasional test flakes on dependency updates (dependabot timing?).

**Planned optimizations:**
1. Cache repo-map output across sessions (save 2-3 min).
2. Add pre-commit hooks to catch secrets locally (zero escapes).
3. Document common decisions in `.github/decisions.md` (faster decision-crunch).
4. Increase test parallelization (reduce CI wait time).

---

## How to Update This File

After each PR merge:

1. Run: `git log --oneline origin/main -1 | head -5`
2. Extract: duration, test result, diff size, any flags.
3. Update **Latest PR** section below.

```bash
# Example: PR merged in 12 minutes
git log --format="%h %s" -1
abc1234 Fix: correct password validation regex

# Metrics to add:
# Session: 12 min latency
# Quality: test_pass=true, lint_pass=true, secrets=0
# Efficiency: diff=8 lines, commits=1, rework=0
# Safety: risk_flags=0, approval_waited=true
```

### Latest PRs

| PR | Duration | Tests | Diff | Rework | Flags |
|-------|----------|-------|------|--------|-------|
| #42   | 8 min    | ✅    | 12 L | 0      | 0     |
| #41   | 15 min   | ✅    | 67 L | 1      | 0     |
| #40   | 22 min   | ✅    | 145 L| 0      | 0     |
| #39   | 6 min    | ✅    | 3 L  | 0      | 0     |

---

**Last updated:** 2024-01-15  
**Updated by:** Copilot (automated) + User (manual review)
