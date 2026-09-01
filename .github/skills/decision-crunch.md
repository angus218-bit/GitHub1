# Skill: decision-crunch

**Purpose:** Resolve ambiguity with a single clarifying question; document decision in commit or PR.

**Trigger:** When spec is unclear, repo structure is ambiguous, or multiple valid approaches exist.

**Execution:**

1. **Identify ambiguity** — what is unclear?
2. **Propose options** — list 2–3 reasonable approaches (with pros/cons if time).
3. **Ask 1 question** — force a binary or multi-choice decision.
4. **Wait for user answer** — do not guess.
5. **Document decision** — commit message or PR description notes why this path was chosen.

**Examples:**

**Ambiguity:** "Should this component be a class or function?"
- Option A: Class (reusable, testable OOP pattern).
- Option B: Function (simpler, lighter, functional style).
**Question:** "Looking at the codebase style (I see mostly functional React components), which fits better for this new auth component?"

**Ambiguity:** "Update Node from 16 to 18. Are there breaking changes?"
- Option A: Update directly (latest LTS, smaller diff).
- Option B: Intermediate step to 17 first (more testing, more commits).
**Question:** "Do you want a single major bump to Node 18, or staged upgrades for safety?"

**Ambiguity:** "Bug in auth service—is this a blocker or can it wait?"
- Option A: Fix now, delay feature PR.
- Option B: File issue, complete feature, merge auth fix separately.
**Question:** "Is the auth bug breaking production, or just affecting new users in dev?"

**Decision Documentation:**

In commit message:

```
Feature: [title]

Decision: [option chosen]
Rationale: [why this option over alternatives]
Impact: [what users/devs see]

References: [related issue/PR]
```

In PR description:

```
## Decision Log

**Question:** Should components be class or functional?
**Decision:** Functional (hooks-based).
**Why:** Codebase is 90% functional React; consistency matters.
```

**Notes:**
- One question only. If still blocked after answer, ask a follow-up.
- Do not invent personas or preferences. Let user decide.
- Document even trivial decisions (helps future debugging).
