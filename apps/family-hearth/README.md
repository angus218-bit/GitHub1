# The Calder Hearth

Family website for recipes, gatherings, and stories. Built with Vite and React, ready for Netlify.

## Local

From `apps/family-hearth`:

```bash
npm ci
npm run dev
```

Vite serves http://127.0.0.1:5174 (5173 is reserved for the TaskBoard demo).

## Build and test

```bash
npm test
npm run build
```

## Netlify

`netlify.toml` sets `npm run build` and publish directory `dist`. After the first production deploy, enable notifications for the `family-rsvp` form in the Netlify UI.

## Cursor pack

This repo includes a Cursor plugin manifest at `.cursor-plugin/plugin.json` and project rules in `.cursor/rules/`.
