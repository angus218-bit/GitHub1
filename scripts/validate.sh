#!/usr/bin/env bash
# Local validation runner for the Copilot Performance System.
#
# This repository ships no application code; its "product" is a set of
# Markdown docs, GitHub Actions workflows, and JSON/YAML configuration.
# This script is the local development gate that mirrors and extends
# .github/workflows/ci.yml so contributors can validate changes before
# pushing:
#
#   1. YAML lint       (.github workflows, dependabot, issue templates)
#   2. GitHub Actions  (actionlint on .github/workflows)
#   3. Markdown lint   (all docs)
#   4. JSON validity   (.perf metrics and any other JSON)
#   5. Secret scan     (same intent as the ci.yml security-scan job)
#
# Usage: scripts/validate.sh
# Exit code is non-zero if any gate fails.
set -uo pipefail

cd "$(dirname "$0")/.."

# Make user-local tool install locations available regardless of caller PATH.
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

status=0

# List working-tree files matching the given pathspecs: tracked files plus
# untracked files that are not gitignored. This lets the gate catch changes a
# contributor has staged or added but not yet committed.
list_files() { git ls-files --cached --others --exclude-standard -- "$@"; }

section() { printf '\n\033[1m==> %s\033[0m\n' "$1"; }
pass()    { printf '\033[32m  PASS\033[0m %s\n' "$1"; }
fail()    { printf '\033[31m  FAIL\033[0m %s\n' "$1"; status=1; }
skip()    { printf '\033[33m  SKIP\033[0m %s\n' "$1"; }

# 1. YAML lint -------------------------------------------------------------
section "YAML lint (yamllint)"
if command -v yamllint >/dev/null 2>&1; then
  mapfile -t yaml_files < <(list_files '*.yml' '*.yaml')
  if [ "${#yaml_files[@]}" -eq 0 ]; then
    skip "no YAML files tracked"
  elif yamllint -c .yamllint.yml "${yaml_files[@]}"; then
    pass "${#yaml_files[@]} YAML file(s) valid"
  else
    fail "yamllint reported problems"
  fi
else
  fail "yamllint not installed"
fi

# 2. GitHub Actions workflow lint -----------------------------------------
section "GitHub Actions lint (actionlint)"
if command -v actionlint >/dev/null 2>&1; then
  if ls .github/workflows/*.yml >/dev/null 2>&1; then
    if actionlint; then
      pass "workflows valid"
    else
      fail "actionlint reported problems"
    fi
  else
    skip "no workflows found"
  fi
else
  fail "actionlint not installed"
fi

# 3. Markdown lint ---------------------------------------------------------
section "Markdown lint (markdownlint)"
if command -v markdownlint >/dev/null 2>&1; then
  if markdownlint --config .markdownlint.jsonc "**/*.md" --ignore node_modules; then
    pass "Markdown docs valid"
  else
    fail "markdownlint reported problems"
  fi
else
  fail "markdownlint not installed"
fi

# 4. JSON validity ---------------------------------------------------------
section "JSON validity"
mapfile -t json_files < <(list_files '*.json')
if [ "${#json_files[@]}" -eq 0 ]; then
  skip "no JSON files tracked"
else
  json_ok=1
  for f in "${json_files[@]}"; do
    if python3 -m json.tool "$f" >/dev/null 2>&1; then
      printf '    ok  %s\n' "$f"
    else
      printf '    bad %s\n' "$f"; json_ok=0
    fi
  done
  if [ "$json_ok" -eq 1 ]; then
    pass "${#json_files[@]} JSON file(s) valid"
  else
    fail "invalid JSON detected"
  fi
fi

# 5. Secret scan (mirrors ci.yml security-scan intent) --------------------
section "Secret scan"
# Flag hardcoded credential-like assignments in source files. Matches the
# ci.yml security-scan job: only real code files are scanned, and a match
# must look like an assignment to avoid tripping on documentation prose.
mapfile -t src_files < <(list_files '*.js' '*.ts' '*.py' '*.go' '*.java')
if [ "${#src_files[@]}" -gt 0 ]; then
  if printf '%s\n' "${src_files[@]}" \
      | xargs grep -nEi '(api_key|password|secret|token)[[:space:]]*[:=][[:space:]]*["'"'"'][^"'"'"']+' \
      2>/dev/null; then
    fail "possible hardcoded secret(s) found"
  else
    pass "no hardcoded secrets in source files"
  fi
else
  skip "no source files to scan"
fi

# Summary ------------------------------------------------------------------
section "Summary"
if [ "$status" -eq 0 ]; then
  printf '\033[32mAll validation gates passed.\033[0m\n'
else
  printf '\033[31mOne or more validation gates failed.\033[0m\n'
fi
exit "$status"
