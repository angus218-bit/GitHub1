import { test } from 'node:test';
import assert from 'node:assert/strict';
import request from 'supertest';
import { createApp } from './index.js';

test('GET /api/health returns ok', async () => {
  const app = createApp();
  const res = await request(app).get('/api/health');
  assert.equal(res.status, 200);
  assert.equal(res.body.status, 'ok');
});

test('GET /api/tasks returns seeded tasks', async () => {
  const app = createApp();
  const res = await request(app).get('/api/tasks');
  assert.equal(res.status, 200);
  assert.ok(Array.isArray(res.body));
  assert.ok(res.body.length >= 1);
});

test('POST /api/tasks creates a task (end-to-end record creation)', async () => {
  const app = createApp();
  const res = await request(app)
    .post('/api/tasks')
    .send({ title: 'Write an integration test' })
    .set('Content-Type', 'application/json');
  assert.equal(res.status, 201);
  assert.equal(res.body.title, 'Write an integration test');
  assert.equal(res.body.done, false);
  assert.ok(res.body.id);
});

test('POST /api/tasks rejects empty title', async () => {
  const app = createApp();
  const res = await request(app)
    .post('/api/tasks')
    .send({ title: '   ' })
    .set('Content-Type', 'application/json');
  assert.equal(res.status, 400);
});

test('PATCH then DELETE a task', async () => {
  const app = createApp();
  const created = await request(app)
    .post('/api/tasks')
    .send({ title: 'Temporary task' })
    .set('Content-Type', 'application/json');
  const id = created.body.id;

  const patched = await request(app).patch(`/api/tasks/${id}`).send({ done: true });
  assert.equal(patched.status, 200);
  assert.equal(patched.body.done, true);

  const deleted = await request(app).delete(`/api/tasks/${id}`);
  assert.equal(deleted.status, 200);
  assert.equal(deleted.body.id, id);
});
