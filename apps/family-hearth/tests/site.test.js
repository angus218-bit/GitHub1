import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { describe, it } from "node:test";
import { gatherings, recipes, stories } from "../src/data.js";

describe("family hearth content", () => {
  it("ships recipes, gatherings, and stories", () => {
    assert.equal(recipes.length, 3);
    assert.equal(gatherings.length, 3);
    assert.equal(stories.length, 3);
    assert.match(recipes[0].title, /pot roast/i);
  });
});

describe("netlify form detection", () => {
  it("keeps a hidden static twin of family-rsvp in index.html", () => {
    const html = readFileSync(new URL("../index.html", import.meta.url), "utf8");
    assert.match(html, /name="family-rsvp"/);
    assert.match(html, /data-netlify="true"/);
    assert.match(html, /name="bot-field"/);
    assert.match(html, /name="guests"/);
  });

  it("declares a dist publish and spa fallback in netlify.toml", () => {
    const toml = readFileSync(new URL("../netlify.toml", import.meta.url), "utf8");
    assert.match(toml, /publish = "dist"/);
    assert.match(toml, /to = "\/index.html"/);
    assert.match(toml, /status = 200/);
  });

  it("does not block first paint on webfonts", () => {
    const html = readFileSync(new URL("../index.html", import.meta.url), "utf8");
    assert.doesNotMatch(html, /fonts\.googleapis/);
  });

  it("caches hashed assets on the CDN", () => {
    const toml = readFileSync(new URL("../netlify.toml", import.meta.url), "utf8");
    assert.match(toml, /for = "\/assets\/\*"/);
    assert.match(toml, /max-age=31536000/);
  });
});
