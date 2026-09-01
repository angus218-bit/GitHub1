import { useMemo, useState } from "react";
import { family, gatherings, recipes, stories } from "./data.js";

const VIEWS = [
  { id: "home", label: "Hearth" },
  { id: "recipes", label: "Recipes" },
  { id: "gatherings", label: "Gatherings" },
  { id: "stories", label: "Stories" },
  { id: "rsvp", label: "RSVP" },
];

function EmberMark() {
  return (
    <svg className="mark" viewBox="0 0 64 64" aria-hidden="true">
      <path
        fill="currentColor"
        d="M32 6c2 8 14 14 14 28a14 14 0 1 1-28 0C18 20 30 14 32 6zm-9 46h18c1 4-4 8-9 8s-10-4-9-8z"
      />
    </svg>
  );
}

function Home() {
  return (
    <section className="hero">
      <p className="eyebrow">{family.place}</p>
      <h1>{family.name}</h1>
      <p className="lede">{family.motto}</p>
      <p className="body-copy">
        This is the family site for recipes that still have flour on the cards, the
        gatherings we actually keep, and the stories we tell after the dishes are done.
      </p>
      <div className="hearth-glow" aria-hidden="true" />
    </section>
  );
}

function Recipes() {
  return (
    <section>
      <h1>Recipes</h1>
      <p className="lede">Written in the tin, not the cloud — copied here so nobody loses the card.</p>
      <ul className="card-grid">
        {recipes.map((recipe) => (
          <li key={recipe.id} className="card">
            <p className="eyebrow">
              {recipe.season} · {recipe.time}
            </p>
            <h2>{recipe.title}</h2>
            <p>{recipe.blurb}</p>
            <p className="quiet">{recipe.notes}</p>
          </li>
        ))}
      </ul>
    </section>
  );
}

function Gatherings() {
  return (
    <section>
      <h1>Gatherings</h1>
      <p className="lede">Not a calendar product. Just the days we clear the table.</p>
      <ul className="stack">
        {gatherings.map((event) => (
          <li key={event.id} className="row-card">
            <h2>{event.title}</h2>
            <p className="eyebrow">{event.when}</p>
            <p>{event.detail}</p>
          </li>
        ))}
      </ul>
    </section>
  );
}

function Stories() {
  return (
    <section>
      <h1>Stories</h1>
      <p className="lede">Short enough to tell while the cocoa cools.</p>
      <ul className="stack">
        {stories.map((story) => (
          <li key={story.id} className="paper">
            <h2>{story.title}</h2>
            <p>{story.body}</p>
          </li>
        ))}
      </ul>
    </section>
  );
}

function Rsvp() {
  const [status, setStatus] = useState("idle");

  async function onSubmit(event) {
    event.preventDefault();
    const form = event.currentTarget;
    const data = new FormData(form);
    try {
      const response = await fetch("/", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: new URLSearchParams(data).toString(),
      });
      // Netlify Forms returns 200. Vite preview has no form endpoint (404).
      if (!response.ok && response.status !== 404) {
        setStatus("error");
        return;
      }
      setStatus("sent");
      form.reset();
    } catch {
      setStatus("error");
    }
  }

  return (
    <section className="rsvp">
      <h1>Pull up a chair</h1>
      <p className="lede">Tell us you are coming. We will set an extra bowl.</p>
      {status === "sent" ? (
        <p className="notice" role="status">
          Saved. See you by the fire.
        </p>
      ) : (
        <form
          className="rsvp-form"
          name="family-rsvp"
          method="POST"
          data-netlify="true"
          data-netlify-honeypot="bot-field"
          onSubmit={onSubmit}
        >
          <input type="hidden" name="form-name" value="family-rsvp" />
          <p className="honeypot">
            <label>
              Leave empty
              <input name="bot-field" />
            </label>
          </p>
          <label>
            Name
            <input name="name" required autoComplete="name" />
          </label>
          <label>
            Email
            <input name="email" type="email" required autoComplete="email" />
          </label>
          <label>
            How many chairs
            <input name="guests" type="number" min="1" max="20" defaultValue="2" required />
          </label>
          <label>
            Note for the cook
            <textarea name="note" rows="4" />
          </label>
          <button type="submit">Send RSVP</button>
          {status === "error" ? (
            <p className="notice error" role="alert">
              Could not send from this preview. On Netlify the form posts to the site.
            </p>
          ) : null}
        </form>
      )}
    </section>
  );
}

export default function App() {
  const [view, setView] = useState("home");
  const screen = useMemo(() => {
    switch (view) {
      case "recipes":
        return <Recipes />;
      case "gatherings":
        return <Gatherings />;
      case "stories":
        return <Stories />;
      case "rsvp":
        return <Rsvp />;
      default:
        return <Home />;
    }
  }, [view]);

  return (
    <div className="shell">
      <header className="top">
        <button className="brand" type="button" onClick={() => setView("home")}>
          <EmberMark />
          <span>{family.name}</span>
        </button>
        <nav aria-label="Primary">
          {VIEWS.map((item) => (
            <button
              key={item.id}
              type="button"
              className={view === item.id ? "nav-link current" : "nav-link"}
              aria-current={view === item.id ? "page" : undefined}
              onClick={() => setView(item.id)}
            >
              {item.label}
            </button>
          ))}
        </nav>
      </header>
      <main>{screen}</main>
      <footer>
        <p>Kept by the Calders · Built for a quiet Netlify deploy</p>
      </footer>
    </div>
  );
}
