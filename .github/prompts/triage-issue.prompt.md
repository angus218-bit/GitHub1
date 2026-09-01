# Prompt: triage-issue.prompt.md

**Trigger:** When a new issue is created in this repo.

**Triage Template:**

```markdown
## Triage Summary

### Classification
- [ ] **Bug:** Something is broken or behaving unexpectedly.
- [ ] **Feature:** New capability or enhancement.
- [ ] **Chore:** Maintenance, docs, refactor (no user impact).

### Priority
- [ ] **🔴 Critical:** Production outage, security issue, data loss.
- [ ] **🟡 High:** Feature request or blocking bug affecting users.
- [ ] **🟢 Medium:** Enhancement, nice-to-have, or future improvement.
- [ ] **⚪ Low:** Documentation, cleanup, "nice to have someday".

### Context

**Is this a bug?**
- [ ] Yes → Provide reproduction steps below.
- [ ] No → Skip to "Expected behavior".

**Reproduction steps (if bug):**
1. [Step 1]
2. [Step 2]
3. [Step 3]

**Expected behavior:**
[What should happen?]

**Actual behavior:**
[What actually happened?]

**Environment:**
- OS: [Windows / macOS / Linux]
- Node/Python version: [version]
- Relevant deps: [package versions]

### Assignment

- **Skill(s) needed:** [ ] repo-map | [ ] local-code-loop | [ ] test-fix | [ ] pr-review | [ ] decision-crunch
- **Estimated effort:** [ ] 15 min | [ ] 1 hour | [ ] 3 hours | [ ] 1 day | [ ] ?
- **Assigned to:** [User or Copilot]

### Next Steps
- [ ] Awaiting reproduction steps (if bug).
- [ ] Ready to start (assign to Copilot).
- [ ] Discussion needed (comment below).
- [ ] Blocked by issue #[NUMBER].
```

## Issue Response Tiers

**Tier 1: Clear & actionable** → Assign directly to Copilot.
- Steps to reproduce (if bug).
- Expected behavior.
- Clear acceptance criteria.

**Tier 2: Needs clarification** → Ask follow-up Q in comments.
- Is this a bug or feature request?
- What OS / version?
- Can you provide a minimal example?

**Tier 3: Duplicate or out-of-scope** → Link and close.
- "Duplicate of issue #123. Closed."
- "Out of scope for this repo; consider [alternative]."

## Copilot Response

Once issue is triaged:

```markdown
## Copilot: Ready to start

I've mapped the repo and identified this as a [BUG | FEATURE].

**Approach:**
1. [Step 1: what I'll do first]
2. [Step 2: expected outcome]
3. [Step 3: testing / validation]

**Blockers:**
- [ ] None identified.
- [ ] Awaiting: [what]

Ready to begin → [Create PR / Start coding]
```

---

Assign issue → Copilot runs repo-map → Opens PR with fix/feature.
