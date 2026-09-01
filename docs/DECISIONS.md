# Architecture Decision Log

Document major decisions made by Copilot or user when executing tasks.

## Template

```
### Decision: [Title]
**Date:** YYYY-MM-DD  
**Issue:** #[NUMBER] or PR #[NUMBER]  
**Question:** [What was ambiguous?]  
**Options Considered:**
- Option A: [description + pros/cons]
- Option B: [description + pros/cons]

**Decision:** [Which option chosen]  
**Rationale:** [Why this over alternatives]  
**Impact:** [What changes for users/devs]  
**Status:** Active | Superseded  
```

---

## Decisions

### Decision: Grok talks to Cursor through Grok Bot + Cloud Agents, not a custom MCP in this repo

**Date:** 2026-09-01  
**Issue:** User asked to link a Grok account to Cursor and add connectors/automations  
**Question:** Should we host a custom MCP that wraps the Cursor Cloud Agents API, or use official Grok Bot / dashboard surfaces?

**Options Considered:**
- **Option A: Official Grok Bot + Cursor Automations + Cloud Agents API**
  - Pros: First-party auth, shared Cursor account, plugins, routines, dashboard automations
  - Cons: OAuth still requires the user in a browser; SuperGrok link is permanent
- **Option B: Custom public MCP in this repo wrapping `api.cursor.com`**
  - Pros: grok.com Custom connector could call Cursor directly
  - Cons: Needs a hosted public URL and a Cursor API key; extra secret surface; duplicates Grok Bot

**Decision:** Option A  
**Rationale:** Cursor and SpaceXAI already share Grok Bot on the Cursor account. MCP auth is shared on Teams. A home-grown MCP would store a Cursor API key and still could not finish OAuth. Templates in `.github/automations/` and `.github/prompts/` are the parts this repo can own.  
**Impact:** Agents follow `docs/GROK_CURSOR.md`. User completes Grok Bot sign-in, optional SuperGrok link, plugins, and `cursor.com/automations/new`.  
**Status:** Active

### Decision: Land remaining PRs as apps/ subprojects instead of overwriting root docs

**Date:** 2026-09-01  
**Issue:** PR #2, #4, #8 after user asked to resolve all  
**Question:** Root README/AGENTS conflicted with the demo app and Family Hearth site.

**Options Considered:**
- **Option A: Keep Copilot + Grok docs at repo root; place apps under `apps/`**
  - Pros: No loss of the performance system; both apps can exist; CI can test each package
  - Cons: Original PRs assumed they owned the repo root
- **Option B: Let Family Hearth or TaskBoard replace root README/AGENTS**
  - Pros: Matches those PRs as written
  - Cons: Deletes the performance system and Grok bridge that already merged

**Decision:** Option A  
**Rationale:** Conflicts were README/AGENTS only. Family Hearth copy is fictional Calder/Maplewick, so it can land without private-data exposure. PR #8 CI failed on multiline `GITHUB_OUTPUT` and a fake reviewer request; those are fixed in the integration.  
**Impact:** `apps/demo`, `apps/family-hearth`, root `netlify.toml` base, Cloud Agent `install` runs `npm ci` in both apps.  
**Status:** Active

### Decision: Use JWT for session auth instead of server-side sessions

**Date:** 2024-01-10  
**Issue:** #12  
**Question:** How to handle user authentication—stateless (JWT) or stateful (sessions)?  

**Options Considered:**
- **Option A: JWT (Stateless)**
  - Pros: Scalable, no server state, works across microservices
  - Cons: Token revocation harder, needs client refresh logic
- **Option B: Server Sessions (Stateful)**
  - Pros: Simpler revocation, user logout is immediate
  - Cons: Doesn't scale well, ties to single server

**Decision:** JWT (Option A)  
**Rationale:** App is deployed to multiple regions; session replication would be complex. JWT + refresh tokens aligns with modern app architecture.  
**Impact:** 
- Clients must handle token refresh.
- Logout requires invalidating on client side (clear storage).
- Auth service stateless, can scale horizontally.

**Status:** Active

---

### Decision: Use pytest for testing instead of unittest

**Date:** 2024-01-08  
**Issue:** #8  
**Question:** Which Python test framework fits our project better?  

**Options Considered:**
- **Option A: pytest**
  - Pros: Simpler syntax, fixtures, parametrization, active community
  - Cons: Requires plugin ecosystem understanding
- **Option B: unittest**
  - Pros: Standard library, no dependencies
  - Cons: Verbose, limited fixtures, boilerplate

**Decision:** pytest (Option A)  
**Rationale:** Team prefers readable test syntax. pytest's fixture system matches our data-driven testing needs.  
**Impact:**
- New tests use pytest syntax.
- CI updated to run `pytest` instead of `python -m unittest`.
- No breaking changes to existing tests (unittest still works).

**Status:** Active

---

### Decision: Deprecate Python 3.9 support; require 3.11+

**Date:** 2024-01-05  
**Issue:** #3  
**Question:** Should we upgrade Python version requirements?  

**Options Considered:**
- **Option A: Support 3.9+ (current)**
  - Pros: Broader compatibility, fewer breaking changes
  - Cons: Can't use new language features, misses stdlib improvements
- **Option B: Require 3.11+ (drop 3.9 & 3.10)**
  - Pros: Modern language features, better performance, smaller security surface
  - Cons: Forces users to upgrade, may break old deployments

**Decision:** Require 3.11+ (Option B)  
**Rationale:** 
- 3.9 / 3.10 reach end-of-life soon.
- Type hints syntax improvements in 3.10+ reduce boilerplate.
- Performance gains (3.11 has ~10% faster startup).

**Impact:**
- `pyproject.toml` updated to require `python >= 3.11`.
- CI tests only on 3.11 and 3.12.
- Users on 3.9/3.10 must upgrade before updating app.

**Status:** Active

---

## Superseded Decisions

### Decision: Use Webpack for bundling (Superseded by Vite, 2024-01-12)

**Date:** 2024-01-01  
**Original Rationale:** Webpack mature, widely adopted, extensive plugins.  
**Superseded Because:** Vite's zero-config setup and faster rebuilds better for dev velocity.  
**Migration:** See issue #15 for Webpack → Vite migration task.

---

## How to Add a Decision

When Copilot encounters ambiguity:

1. **Ask user** (via decision-crunch skill).
2. **User answers.**
3. **Copilot documents** decision in PR description or commit message.
4. **User reviews** and adds to this file if strategic.

**Criteria for "strategic" decisions:**
- Affects > 1 PR.
- Impacts onboarding or architecture.
- Revisit risk (tech debt, deprecation).

---

**Maintainer:** User (manual updates after decisions).  
**Last updated:** 2024-01-15
