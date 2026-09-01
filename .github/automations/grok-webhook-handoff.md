# Cursor Automation: webhook from Grok Bot

Create at https://cursor.com/automations/new

- **Trigger:** Webhook
- **Repos:** Single repository `angus218-bit/GitHub1`
- **Model:** Grok 4.6 when listed
- **Tools:** none required beyond repo access
- **Permission:** Private

After save, copy the webhook URL into Grok Bot (secure note or skill). Do not commit the URL.

## Prompt

A Grok Bot (or grok.com) client posted this webhook. Treat the JSON body `task` (or raw body text) as the user request.

Follow AGENTS.md. Implement the smallest diff, run the smallest relevant checks, open a draft PR, and stop. Do not merge.

If the body is empty or not a software task, reply in the run summary and make no code changes.

## Grok Bot call shape

```bash
curl -X POST "$CURSOR_AUTOMATION_WEBHOOK_URL" \
  --header 'Content-Type: application/json' \
  --data "{\"task\": \"${TASK}\"}"
```
