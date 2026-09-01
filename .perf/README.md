# Performance Metrics

Tracks Copilot session performance across quality, efficiency, and safety dimensions.

## Files

- **schema.json** — JSON Schema defining the metrics structure
- **metrics.jsonl** — Newline-delimited JSON log of all sessions (one session per line)

## Metrics Categories

### Session
- `id` — Unique session identifier
- `duration_minutes` — Time from start to merge/close
- `status` — in_progress, merged, failed, or abandoned
- `created_at` — ISO 8601 timestamp

### Quality
- `test_pass_rate` — Ratio of passing tests (0–1)
- `lint_pass` — Linter exited cleanly
- `secrets_detected` — Any credentials found in diff
- `pr_review_feedback` — Array of review comments (empty = approved cleanly)

### Efficiency
- `diff_lines` — Total lines added/removed
- `commit_count` — Number of commits in session
- `rework_loops` — Test failures requiring fixes
- `files_changed` — Number of files modified

### Safety
- `risk_flags` — Count of flagged risks (money, legal, privacy, etc.)
- `approval_waited` — User typed `approved` before merge
- `merge_by_user` — GitHub username of merger

## Goals

**Quality**: test_pass_rate = 1.0, lint_pass = true, secrets_detected = false, pr_review_feedback = []  
**Efficiency**: Minimize diff_lines, commit_count, rework_loops  
**Safety**: risk_flags = 0, approval_waited = true  
**Latency**: Keep duration_minutes small

## How to Log

After each session:
```bash
# Collect metrics and append to metrics.jsonl
echo '{"session":{...},"quality":{...},"efficiency":{...},"safety":{...}}' >> .perf/metrics.jsonl
```

Or create a GitHub workflow to capture metrics from CI.

## Analysis

Query metrics with jq:
```bash
# Average session duration
jq '.session.duration_minutes' .perf/metrics.jsonl | jq -s 'add/length'

# Test pass rate trend
jq '.quality.test_pass_rate' .perf/metrics.jsonl

# Sessions with rework
jq 'select(.efficiency.rework_loops > 0)' .perf/metrics.jsonl
```
