# Family Hearth — agent notes

## What this is

A static family website for **The Calder Hearth**, built with Vite + React and prepared for Netlify.

## Commands

- Install: `npm ci` (or `npm install` on a fresh machine)
- Dev: `npm run dev` (Vite on port 5173)
- Build: `npm run build`
- Preview production build: `npm run preview`
- Tests: `npm test`

## Deploy

Connect this GitHub repo to Netlify (or `npx netlify deploy`). `netlify.toml` sets the build command and publish directory. Enable form notifications for `family-rsvp` in the Netlify UI after the first deploy.

## Cursor plugin pack

Project rules live in `.cursor/rules/`. The plugin manifest is `.cursor-plugin/plugin.json`.
