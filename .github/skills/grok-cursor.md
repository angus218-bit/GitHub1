# Skill: grok-cursor

**Purpose:** Route work between Grok (model + Grok Bot) and Cursor Cloud Agents without duplicating coding in the wrong place.

**Trigger:** User asks to talk to Grok from Cursor, link a Grok/X account, add Grok connectors, or have Grok launch Cursor work.

**Do**

1. Treat Grok 4.6 inside Cursor as already connected for coding.
2. Send standing, cross-app, or inbox work to Grok Bot (same Cursor account).
3. Send repository edits to a Cursor Cloud Agent or local Agent, not to the Grok Bot computer.
4. Point the user at `docs/GROK_CURSOR.md` for OAuth, plugins, and dashboard automations.
5. Use paste-ready prompts in `.github/prompts/` and `.github/automations/`.

**Do not**

- Complete SuperGrok / X Premium+ linking from this VM (permanent, browser OAuth).
- Put Cursor API keys, `.env` values, or provider tokens in the repo or chat.
- Merge, release, force-push, or delete branches unless the user typed `approved`.
- Authenticate desktop-only MCP servers from a Cloud Agent (tell the user to finish them in Cursor desktop).

**Handoff checklist**

- Outcome, repo, branch policy, and "open a draft PR" vs "stop after a plan".
- Approval boundary (no send / pay / production / merge).
- Where to post the Cloud Agent URL.

**API launch (only when a Cursor API key is already stored outside git)**

`POST https://api.cursor.com/v1/agents` with Basic auth `-u "${CURSOR_API_KEY}:"`, repo `https://github.com/angus218-bit/GitHub1`, `autoCreatePR: true`, prompt that says to follow `AGENTS.md`.

**Official docs**

- https://cursor.com/help/grok-bot/getting-started
- https://cursor.com/help/grok-bot/supergrok-heavy
- https://cursor.com/help/grok-bot/connect-plugins
- https://docs.x.ai/grok-bot/skills-routines-and-automations
- https://cursor.com/help/ai-features/automations
- https://cursor.com/docs/cloud-agent/api/endpoints
