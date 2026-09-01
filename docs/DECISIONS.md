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
