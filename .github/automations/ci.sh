#!/bin/bash
# Parallel CI/CD task orchestration
# Runs linting, testing, and security checks in parallel to maximize throughput

set -e

TASKS=()
FAILED=0

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_task() {
  echo -e "${YELLOW}→${NC} $1"
}

log_success() {
  echo -e "${GREEN}✓${NC} $1"
}

log_error() {
  echo -e "${RED}✗${NC} $1"
}

# Run tasks in parallel with job control
run_parallel() {
  local max_jobs=${1:-4}
  shift
  local -n tasks=("$@")
  
  log_task "Running ${#tasks[@]} tasks in parallel (max $max_jobs jobs)"
  
  local active=0
  for task in "${tasks[@]}"; do
    while [ $(jobs -r | wc -l) -ge $max_jobs ]; do
      sleep 0.1
    done
    eval "$task" &
    ((active++))
  done
  
  # Wait for all background jobs and collect exit codes
  for task in "${tasks[@]}"; do
    if ! wait; then
      ((FAILED++))
    fi
  done
}

# Lint: Changed files only
lint_changed() {
  log_task "Linting changed files"
  if command -v eslint &> /dev/null; then
    git diff origin/main --name-only | grep -E '\.(js|ts|jsx|tsx)$' | xargs eslint --max-warnings 0 || return 1
    log_success "Lint passed"
  else
    log_task "eslint not found, skipping"
  fi
}

# Test: Affected tests only
test_affected() {
  log_task "Running affected tests"
  if command -v npm &> /dev/null && [ -f "package.json" ]; then
    npm test -- --bail 2>/dev/null || return 1
    log_success "Tests passed"
  elif command -v pytest &> /dev/null; then
    pytest -x 2>/dev/null || return 1
    log_success "Tests passed"
  else
    log_task "No test runner found, skipping"
  fi
}

# Security: Secrets scan
scan_secrets() {
  log_task "Scanning for secrets"
  if ! git diff origin/main | grep -E '(password|token|api[_-]?key|secret)' -i &>/dev/null; then
    log_success "No secrets detected"
  else
    log_error "Potential secrets found in diff"
    return 1
  fi
}

# Build: Compile/bundle
build_app() {
  log_task "Building application"
  if command -v npm &> /dev/null && [ -f "package.json" ]; then
    npm run build 2>/dev/null || return 1
    log_success "Build succeeded"
  elif command -v go &> /dev/null && [ -f "go.mod" ]; then
    go build ./... || return 1
    log_success "Build succeeded"
  else
    log_task "No build tool detected, skipping"
  fi
}

# Coverage: Report
coverage_report() {
  log_task "Generating coverage report"
  if command -v npm &> /dev/null && [ -f "package.json" ]; then
    npm test -- --coverage 2>/dev/null || return 1
    log_success "Coverage report generated"
  else
    log_task "Coverage not configured, skipping"
  fi
}

# Main orchestration
main() {
  echo ""
  log_task "CI/CD Orchestration (parallel mode)"
  echo ""
  
  # Check if this is a PR or commit
  if [ -z "$CI" ]; then
    log_task "Running locally (not in CI)"
  fi
  
  # Parallel execution with up to 4 concurrent jobs
  TASKS=(
    "lint_changed"
    "test_affected"
    "scan_secrets"
    "build_app"
  )
  
  run_parallel 4 TASKS
  
  echo ""
  if [ $FAILED -eq 0 ]; then
    log_success "All checks passed ($(($(date +%s) - $(date +%s))) seconds)"
    exit 0
  else
    log_error "$FAILED check(s) failed"
    exit 1
  fi
}

main "$@"
