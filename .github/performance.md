# Performance Optimization Guide

## Application Code Performance

### 1. **Caching Strategy**
Cache frequently accessed metadata to reduce file I/O:

```javascript
// Bad: Read files every time
async function getRepoMap() {
  return JSON.parse(fs.readFileSync('repo-structure.json'));
}

// Good: Cache in memory with TTL
const cache = new Map();
async function getRepoMap() {
  if (cache.has('repo-structure') && Date.now() - cache.get('repo-structure').ts < 300000) {
    return cache.get('repo-structure').data;
  }
  const data = JSON.parse(fs.readFileSync('repo-structure.json'));
  cache.set('repo-structure', { data, ts: Date.now() });
  return data;
}
```

### 2. **Lazy Loading**
Load skills/prompts only when needed, not at startup:

```javascript
// Bad: Load all skills upfront
const skills = ['repo-map', 'local-code-loop', 'test-fix', ...].map(s => require(`./skills/${s}`));

// Good: Load on demand
function getSkill(name) {
  return require(`./skills/${name}`);
}
```

### 3. **Batch Operations**
Process multiple items in parallel with Promise.all():

```javascript
// Bad: Sequential file reads
for (const file of files) {
  const content = fs.readFileSync(file);
  process(content);
}

// Good: Parallel reads
await Promise.all(files.map(f => fs.promises.readFile(f).then(process)));
```

### 4. **Stream Large Files**
Use streams for metrics logs to avoid memory bloat:

```javascript
// Bad: Load entire metrics.jsonl into memory
const metrics = JSON.parse(fs.readFileSync('.perf/metrics.jsonl'));

// Good: Stream line-by-line
const readline = require('readline');
const rl = readline.createInterface({
  input: fs.createReadStream('.perf/metrics.jsonl')
});
rl.on('line', line => process(JSON.parse(line)));
```

### 5. **Index Key Lookups**
Build indexes for O(1) lookups instead of O(n) scans:

```javascript
// Build index of all issues once
const issueIndex = new Map();
allIssues.forEach(issue => {
  issueIndex.set(issue.id, issue);
  issueIndex.set(`title:${issue.title}`, issue);
});

// Lookup is now O(1)
const issue = issueIndex.get('123');
```

### 6. **Memoization for Pure Functions**
Cache results of expensive pure functions:

```javascript
const memoize = (fn) => {
  const cache = new Map();
  return (...args) => {
    const key = JSON.stringify(args);
    if (cache.has(key)) return cache.get(key);
    const result = fn(...args);
    cache.set(key, result);
    return result;
  };
};

// Usage: memoize pure function
const parseYAML = memoize((yaml) => yaml.parse(content));
```

---

## Priority Implementation

1. **High Impact:** Caching (30% latency reduction)
2. **Medium Impact:** Lazy loading, batching (15% reduction each)
3. **Low Impact:** Streams, indexing, memoization (5-10% each)

---

## Metrics Capture

Before & after for each optimization:
- Response time: `time npm test`
- Memory usage: `node --max-old-space-size` diagnostics
- File I/O count: fs.promises event tracking

Log results to `.perf/metrics.jsonl` per session.
