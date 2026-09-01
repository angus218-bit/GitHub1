# GitHub1 — TaskBoard

A minimal but complete full-stack demo app used to prove the Cloud Agent development
environment works end to end.

- **Frontend:** React 18 + [Vite](https://vitejs.dev/) (`src/`, port `5173`)
- **Backend:** [Express](https://expressjs.com/) JSON API with an in-memory task store (`server/`, port `3001`)
- The Vite dev server proxies `/api/*` to the Express API.

## Prerequisites

- Node.js `>=20` (this repo is validated on Node 22)

## Getting started

```bash
npm ci          # install dependencies (uses package-lock.json)
npm run dev     # start the API and the Vite dev server together
```

Then open http://localhost:5173. Add a task, tick it off, or delete it — every
action is an HTTP request to the Express API.

### Individual commands

| Command             | Description                                        |
| ------------------- | -------------------------------------------------- |
| `npm run dev`       | Run API + client together (via `concurrently`)     |
| `npm run dev:server`| Run only the API with file watching                |
| `npm run dev:client`| Run only the Vite dev server                       |
| `npm run build`     | Build the production frontend into `dist/`          |
| `npm start`         | Serve the built frontend + API from Express        |
| `npm test`          | Run the API integration tests (`node --test`)      |
| `npm run lint`      | Lint the codebase with ESLint                      |

## API

| Method | Path              | Description            |
| ------ | ----------------- | ---------------------- |
| GET    | `/api/health`     | Health check           |
| GET    | `/api/tasks`      | List tasks             |
| POST   | `/api/tasks`      | Create a task          |
| PATCH  | `/api/tasks/:id`  | Toggle/rename a task   |
| DELETE | `/api/tasks/:id`  | Delete a task          |

## Cloud Agent environment

`.cursor/environment.json` configures the Cloud Agent environment:

- `install`: `npm ci`
- `terminals`: `server` (`npm run dev:server`) and `client` (`npm run dev:client`)
- `ports`: `3001`, `5173`
