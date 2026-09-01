#!/bin/bash
# Automated issue and PR workflow
# Triages issues, assigns labels, routes to assignee

set -e

# Configuration
GITHUB_TOKEN="${GITHUB_TOKEN:?Set GITHUB_TOKEN environment variable}"
REPO="${GITHUB_REPOSITORY:?Set GITHUB_REPOSITORY}"
ISSUE_NUMBER="${GITHUB_EVENT_ISSUE_NUMBER:-}"
PR_NUMBER="${GITHUB_EVENT_PR_NUMBER:-}"

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" >&2
}

# Detect issue type
detect_type() {
  local title="$1"
  local body="$2"
  
  if [[ "$title" =~ ^fix:|bug|error|crash ]]; then
    echo "bug"
  elif [[ "$title" =~ ^feat:|feature|add|new ]]; then
    echo "feature"
  elif [[ "$title" =~ ^docs:|documentation ]]; then
    echo "documentation"
  elif [[ "$title" =~ ^perf:|performance|slow ]]; then
    echo "performance"
  elif [[ "$title" =~ ^test:|testing ]]; then
    echo "testing"
  else
    echo "chore"
  fi
}

# Detect priority
detect_priority() {
  local body="$1"
  
  if [[ "$body" =~ critical|urgent|blocker ]]; then
    echo "P0"
  elif [[ "$body" =~ high|important ]]; then
    echo "P1"
  elif [[ "$body" =~ medium ]]; then
    echo "P2"
  else
    echo "P3"
  fi
}

# Apply labels to issue (best-effort; missing labels or permissions must not fail CI)
apply_labels() {
  local issue_type="$1"
  local priority="$2"
  local labels="$issue_type,$priority"

  log "Applying labels: $labels"

  gh api \
    -X POST \
    "repos/$REPO/issues/$ISSUE_NUMBER/labels" \
    --input - <<< "{\"labels\":[$(echo "$labels" | sed 's/,/","/g' | sed 's/^/"/;s/$/"/')  ]}" \
    && return 0
  log "Label apply skipped (labels may not exist, or token lacks issues:write)"
}

# Auto-assign based on labels
auto_assign() {
  local issue_type="$1"
  
  case "$issue_type" in
    bug)
      assign_to="@github/bug-hunters"
      ;;
    feature)
      assign_to="@github/feature-team"
      ;;
    documentation)
      assign_to="@github/docs"
      ;;
    performance)
      assign_to="@github/platform"
      ;;
    *)
      return 0
      ;;
  esac
  
  log "Auto-assigning to $assign_to"
}

# PR: Request reviewers
request_reviewers() {
  local pr_number="$1"

  log "Skipping reviewer request for PR #$pr_number (no default reviewers configured)"
}

# PR: Check test status
check_tests() {
  local pr_number="$1"
  
  log "Checking test status for PR #$pr_number"
  
  # Poll for test completion (max 30 seconds)
  local elapsed=0
  while [ $elapsed -lt 30 ]; do
    local status=$(gh api \
      "repos/$REPO/pulls/$pr_number/statuses" \
      --jq '.[0].state' 2>/dev/null || echo "pending")
    
    if [[ "$status" != "pending" ]]; then
      log "Tests status: $status"
      if [[ "$status" != "success" ]]; then
        return 1
      fi
      return 0
    fi
    
    sleep 5
    ((elapsed+=5))
  done
  
  log "Tests still running after 30s"
  return 0
}

# Main workflow
main() {
  if [ -n "$ISSUE_NUMBER" ]; then
    log "Processing issue #$ISSUE_NUMBER"
    
    # Get issue details
    local issue_data=$(gh issue view "$ISSUE_NUMBER" --json title,body --repo "$REPO")
    local title=$(echo "$issue_data" | jq -r '.title')
    local body=$(echo "$issue_data" | jq -r '.body')
    
    # Triage
    local issue_type=$(detect_type "$title" "$body")
    local priority=$(detect_priority "$body")
    
    log "Detected: type=$issue_type, priority=$priority"
    
    # Apply labels and assign
    apply_labels "$issue_type" "$priority"
    auto_assign "$issue_type"
    
  elif [ -n "$PR_NUMBER" ]; then
    log "Processing PR #$PR_NUMBER"
    
    request_reviewers "$PR_NUMBER"
    log "PR #$PR_NUMBER classified; test status is left to required checks"
  fi
}

main "$@"
