# Grok ↔ Cursor bridge

Grok already runs inside Cursor as a selectable model. Persistent Grok teammates, plugins, and SuperGrok usage grants live in **Grok Bot**, which authenticates with the **same Cursor account**.

This repo cannot complete OAuth for you. Account linking, plugin authorize, and dashboard automations require a browser signed in as you.

---

## What is already true

- Cursor Cloud Agents can use Grok 4.6 (`cursor.com/agents`).
- Grok Bot signs in with the Cursor account, not a separate Grok Bot login.
- On Cursor Teams, Grok Bot follows the team's plugin and MCP policy. MCP sign-in is shared with Cursor.
- Grok Bot can hand coding work to Cursor Cloud Agents when that team toggle is on (default on for teams).

## What only you can click

These cannot be finished from a Cloud Agent VM:

1. SuperGrok / X Premium+ usage grant (permanent once created).
2. Grok Bot plugin OAuth (Gmail, Slack, GitHub, Notion, custom MCP).
3. grok.com connector OAuth and custom MCP URLs.
4. Cursor Automations create/save at `cursor.com/automations/new`.
5. Cursor desktop MCP authorize (X, Slack, Notion, and other `needsAuth` servers).

---

## Path A — Grok Bot (recommended)

Use this when you want Grok to keep working across apps and to send repo work into Cursor.

### 1. Install and sign in

- Desktop: [Grok Bot get started](https://docs.x.ai/grok-bot/get-started) (macOS / Windows). Linux desktop is not supported.
- iOS: [Grok Bot on the App Store](https://apps.apple.com/us/app/grok-bot/id6794501026)
- Web sign-in fallback: [x.ai/bot](https://x.ai/bot)
- Sign in with the **same Cursor account** that should own usage.

Privacy: Grok Bot needs cloud data storage. Legacy Privacy Mode blocks it. Review [Cursor privacy settings](https://cursor.com/dashboard?tab=settings).

### 2. Link SuperGrok or X Premium+ (optional usage grant)

Do this only on the Cursor account that should keep the grant forever. Official docs: [Link SuperGrok for Grok Bot](https://cursor.com/help/grok-bot/supergrok-heavy).

1. Open Grok Bot on the Get Started / plan screen.
2. Click **Link Grok Account** (individual SuperGrok / Plus / Heavy) or **Link X Account** (X Premium+).
3. Finish the provider sign-in in the browser.
4. Return to Grok Bot and confirm access.

Qualifies: individual SuperGrok, SuperGrok Plus, SuperGrok Heavy, X Premium+.  
Does not qualify: SuperGrok Lite, SuperGrok Team, SuperGrok Enterprise.

**Permanent:** a SuperGrok or X Premium+ link cannot be unlinked or moved to another Cursor account. If the Link buttons are missing, fully quit Grok Bot and reopen so the paywall screen returns.

Paid Cursor Pro / Pro+ / Ultra / Teams already include Grok Bot. Linking SuperGrok is a usage grant on top; it does not replace the Cursor plan.

### 3. Create a Cursor Coder Bot

Paste `.github/prompts/grok-bot-cursor-coder.md` as the Bot description, then send `.github/prompts/grok-bot-first-task.md` as the first message.

### 4. Connect plugins

In Grok Bot: **Plugins** (sidebar) or **Settings → Plugins**. Mobile: avatar → Plugins.

Install and authorize at least:

- GitHub (repos, issues, PRs)
- Slack (if you want `@Cursor` and Bot updates in a channel)
- Gmail / Google Calendar / Drive (already live in this Cursor Cloud Agent environment; still authorize in Grok Bot if you want the Bot to use them)
- Custom MCP for any tool not in the catalog

Finish the provider login in the browser. If it sits on Waiting for authorization, click Reopen. Docs: [Connect plugins](https://cursor.com/help/grok-bot/connect-plugins).

Connectors are account-wide. Every Bot on the account can use an installed plugin.

### 5. Save a skill, then a routine

After one successful Cursor handoff, tell the Bot:

> Save the process we just used as a skill called "Handoff to Cursor Cloud Agent." Include the GitHub repo URL, the rule that code changes go to Cursor (not the Bot computer), and that merge still requires the user to type `approved`.

Then schedule it, for example:

> Every weekday at 8:00 AM America/Los_Angeles, scan open GitHub issues labeled `agent` on angus218-bit/GitHub1. For each new issue, launch a Cursor Cloud Agent and post the agent URL in this conversation. Do not merge. Do not comment `approved`.

Event triggers (Slack message, GitHub notification) are Cursor-account integrations, separate from Slack/GitHub plugins. Keep matchers narrow. Docs: [Skills and routines](https://docs.x.ai/grok-bot/skills-routines-and-automations).

---

## Path B — grok.com connectors

Use this when you chat on grok.com and want Grok to call tools there.

1. Open [grok.com/connectors](https://grok.com/connectors).
2. Add built-in connectors (Google, Microsoft, Salesforce, and the catalog).
3. For Cursor coding, add a **Custom** MCP only if you have a public MCP URL. grok.com cannot reach localhost.

There is no first-party "Cursor" connector in the Grok catalog. The supported coding path is Grok Bot → Cursor Cloud Agent, or grok.com Custom MCP wrapping the [Cloud Agents API](https://cursor.com/docs/cloud-agent/api/endpoints).

---

## Path C — Cursor Automations

Create at [cursor.com/automations/new](https://cursor.com/automations/new). Paste prompts from `.github/automations/`.

Suggested first automations for this repo:

| File | Trigger | What it does |
| --- | --- | --- |
| `.github/automations/github-issue-grok.md` | GitHub issue opened | Start a Grok Cloud Agent on the issue |
| `.github/automations/github-pr-review.md` | PR opened / ready | Review against `AGENTS.md` |
| `.github/automations/grok-webhook-handoff.md` | Webhook POST | Let Grok Bot launch Cursor by HTTP |

Model: prefer Grok 4.6 when the picker offers it. Billing: each run is a Cloud Agent at API pricing.

Also start agents without an automation:

- Web: [cursor.com/agents](https://cursor.com/agents)
- GitHub: comment `@cursor` on an issue or PR
- Slack: `@Cursor` in a connected channel
- API: `POST https://api.cursor.com/v1/agents`

---

## Path D — Cloud Agents API (Grok launches Cursor)

Create a user key at Cursor Dashboard → API Keys. Store it in Grok Bot's secure credential store, never in chat or this repo.

From Grok Bot's computer or any trusted shell:

```bash
curl --request POST \
  --url https://api.cursor.com/v1/agents \
  -u "${CURSOR_API_KEY}:" \
  --header 'Content-Type: application/json' \
  --data "{
    \"prompt\": {
      \"text\": \"Follow AGENTS.md. ${TASK}\"
    },
    \"repos\": [
      {
        \"url\": \"https://github.com/angus218-bit/GitHub1\",
        \"startingRef\": \"main\"
      }
    ],
    \"autoCreatePR\": true
  }"
```

Omit `model` to use the account default. List IDs with `GET https://api.cursor.com/v1/models` before pinning Grok.

---

## Cursor desktop MCP (this Cloud Agent)

Interactive MCP login is **desktop-only**. Authenticate these in Cursor desktop → Customize → MCPs, then retry cloud runs.

Priority for Grok communication:

- X (Grok/X account tools)
- Slack
- Notion
- Context
- Composio (extra SaaS connectors)

Already usable in this environment without extra login: Gmail, Google Calendar, Google Drive.

---

## Dual-agent split

| Surface | Use for |
| --- | --- |
| Cursor Agent / Cloud Agent (Grok 4.6) | Repo edits, tests, PRs in GitHub1 |
| Grok Bot | Cross-app work, inbox, calendar, standing routines |
| grok.com | Chat + Grok connectors, not repo PRs |
| Copilot skills in this repo | Same guardrails either model follows |

Merge, release, force-push, and branch delete still wait for the user to type `approved`.
