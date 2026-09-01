# Skill: repo-map

**Purpose:** Understand codebase structure, entry points, constraints, and risks before making large changes.

**Trigger:** On first run; when Copilot opens a new issue or PR in this repo.

**Execution:**

1. **List file structure** — glob `**/*` (exclude `.git`, `node_modules`, etc.).
2. **Identify entry points** — `main.ts`, `index.js`, `app.py`, `Dockerfile`, `azure.yaml`, etc.
3. **Find test/build commands** — grep `package.json`, `Makefile`, `tox.ini`, `.github/workflows/`, etc.
4. **Scan for dependencies** — `package.json`, `requirements.txt`, `Cargo.toml`, `go.mod`, etc.
5. **Check for config/secrets** — warn if `.env.example`, `.env.local`, or `*.key` files exist.

**Output Format:**

```
## Repo Map: [PROJECT_NAME]

### Structure
- **Entry:** src/main.py (3,200 LOC)
- **Tests:** tests/ (42 files, pytest)
- **Docs:** README.md, docs/ folder
- **Config:** pyproject.toml, .github/, docker-compose.yml

### Build & Test
- Build: `npm run build` (webpack)
- Test: `pytest tests/` (coverage: 87%)
- Lint: `eslint src/` (passing)

### Dependencies
- Node 18+, Python 3.10+
- Key libs: FastAPI, React, TypeScript

### Risks / Blockers
- [ ] Hardcoded secrets: None detected
- [ ] Private family data: None detected
- [ ] License conflicts: MIT (clear)
- [ ] Missing docs: Yes, `src/auth/` undocumented

### Next Steps
- Ready for `[TASK]`
- Blocker: `[ISSUE]` must resolve first
- Clarify: `[QUESTION]` for user
```

**Notes:**
- Run early; feed output to other skills.
- Update repo-map if structure changes.
- Cache for 1 session (re-run on next session).
