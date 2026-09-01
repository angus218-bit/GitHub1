import { useEffect, useState } from 'react';
import './App.css';

const API = '/api/tasks';

export default function App() {
  const [tasks, setTasks] = useState([]);
  const [title, setTitle] = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  async function load() {
    try {
      const res = await fetch(API);
      if (!res.ok) throw new Error(`GET ${API} -> ${res.status}`);
      setTasks(await res.json());
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    load();
  }, []);

  async function addTask(e) {
    e.preventDefault();
    const value = title.trim();
    if (!value) return;
    setError(null);
    try {
      const res = await fetch(API, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ title: value }),
      });
      if (!res.ok) throw new Error(`POST ${API} -> ${res.status}`);
      const created = await res.json();
      setTasks((prev) => [...prev, created]);
      setTitle('');
    } catch (err) {
      setError(err.message);
    }
  }

  async function toggleTask(task) {
    try {
      const res = await fetch(`${API}/${task.id}`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ done: !task.done }),
      });
      if (!res.ok) throw new Error(`PATCH ${API}/${task.id} -> ${res.status}`);
      const updated = await res.json();
      setTasks((prev) => prev.map((t) => (t.id === updated.id ? updated : t)));
    } catch (err) {
      setError(err.message);
    }
  }

  async function deleteTask(id) {
    try {
      const res = await fetch(`${API}/${id}`, { method: 'DELETE' });
      if (!res.ok) throw new Error(`DELETE ${API}/${id} -> ${res.status}`);
      setTasks((prev) => prev.filter((t) => t.id !== id));
    } catch (err) {
      setError(err.message);
    }
  }

  const remaining = tasks.filter((t) => !t.done).length;

  return (
    <main className="app">
      <header className="app__header">
        <h1>✅ TaskBoard</h1>
        <p className="app__subtitle">
          A tiny full-stack demo — React + Vite talking to an Express API.
        </p>
      </header>

      <form className="composer" onSubmit={addTask}>
        <input
          className="composer__input"
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          placeholder="Add a new task…"
          aria-label="New task title"
        />
        <button className="composer__button" type="submit">
          Add
        </button>
      </form>

      {error && <p className="banner banner--error">Error: {error}</p>}

      {loading ? (
        <p className="banner">Loading…</p>
      ) : (
        <>
          <ul className="tasks">
            {tasks.map((task) => (
              <li key={task.id} className={`task ${task.done ? 'task--done' : ''}`}>
                <label className="task__label">
                  <input
                    type="checkbox"
                    checked={task.done}
                    onChange={() => toggleTask(task)}
                  />
                  <span className="task__title">{task.title}</span>
                </label>
                <button
                  className="task__delete"
                  onClick={() => deleteTask(task.id)}
                  aria-label={`Delete ${task.title}`}
                >
                  ✕
                </button>
              </li>
            ))}
            {tasks.length === 0 && <li className="tasks__empty">No tasks yet — add one above.</li>}
          </ul>
          <footer className="app__footer">
            {remaining} of {tasks.length} remaining
          </footer>
        </>
      )}
    </main>
  );
}
