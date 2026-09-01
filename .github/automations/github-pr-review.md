# Cursor Automation: PR opened → review

Create at https://cursor.com/automations/new

- **Trigger:** Source control: PR opened, and PR marked ready
- **Repos:** Single repository `angus218-bit/GitHub1`
- **Model:** Grok 4.6 when listed
- **Tools:** Comment on pull request
- **Permission:** Private

## Prompt

Review this pull request against AGENTS.md and `.github/prompts/pr-review.prompt.md`.

Check:

- Smallest diff that works
- No credentials, `.env`, or private family data
- Tests or an explicit reason they were skipped
- Money, legal, or data-loss risk

Post a single summary comment: findings first, then residual risk. Do not merge. Do not approve unless the change is docs-only and you state that limit.
