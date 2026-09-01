import express from 'express';
import { fileURLToPath } from 'node:url';
import path from 'node:path';
import fs from 'node:fs';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const PORT = process.env.PORT || 3001;

/**
 * Simple in-memory task store. This keeps the demo dependency-free while still
 * exercising a real create/read/update/delete flow end to end.
 */
let nextId = 1;
const tasks = [];

function createTask({ title, done = false }) {
  const task = { id: nextId++, title, done: Boolean(done), createdAt: new Date().toISOString() };
  tasks.push(task);
  return task;
}

// Seed a couple of tasks so a fresh boot shows meaningful content.
createTask({ title: 'Set up the Cloud Agent environment', done: true });
createTask({ title: 'Run the app end to end' });

export function createApp() {
  const app = express();
  app.use(express.json());

  app.get('/api/health', (_req, res) => {
    res.json({ status: 'ok', uptime: process.uptime() });
  });

  app.get('/api/tasks', (_req, res) => {
    res.json(tasks);
  });

  app.post('/api/tasks', (req, res) => {
    const title = (req.body?.title || '').trim();
    if (!title) {
      return res.status(400).json({ error: 'title is required' });
    }
    const task = createTask({ title });
    res.status(201).json(task);
  });

  app.patch('/api/tasks/:id', (req, res) => {
    const id = Number(req.params.id);
    const task = tasks.find((t) => t.id === id);
    if (!task) return res.status(404).json({ error: 'not found' });
    if (typeof req.body?.done === 'boolean') task.done = req.body.done;
    if (typeof req.body?.title === 'string' && req.body.title.trim()) {
      task.title = req.body.title.trim();
    }
    res.json(task);
  });

  app.delete('/api/tasks/:id', (req, res) => {
    const id = Number(req.params.id);
    const index = tasks.findIndex((t) => t.id === id);
    if (index === -1) return res.status(404).json({ error: 'not found' });
    const [removed] = tasks.splice(index, 1);
    res.json(removed);
  });

  // Serve the built frontend in production.
  const distDir = path.join(__dirname, '..', 'dist');
  if (process.env.NODE_ENV === 'production' && fs.existsSync(distDir)) {
    app.use(express.static(distDir));
    app.get('*', (_req, res) => {
      res.sendFile(path.join(distDir, 'index.html'));
    });
  }

  return app;
}

const isMain = process.argv[1] === fileURLToPath(import.meta.url);
if (isMain) {
  const app = createApp();
  app.listen(PORT, () => {
    console.log(`[server] API listening on http://localhost:${PORT}`);
  });
}
