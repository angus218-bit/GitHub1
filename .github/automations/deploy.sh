#!/bin/bash
# Deployment automation with rollback support
# Deploys to staging/production with health checks and canary deployment

set -e

ENVIRONMENT="${1:-staging}"
TIMEOUT=300  # 5 minutes
HEALTH_CHECK_INTERVAL=5

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*"
}

deploy() {
  local env=$1
  local version=$2
  
  log "Starting deployment to $env (version: $version)"
  
  case "$env" in
    staging)
      log "Deploying to staging environment"
      # docker build -t app:$version .
      # docker run -d --name app-staging -p 3000:3000 app:$version
      log "✓ Staging deployment started"
      ;;
    production)
      log "Deploying to production with canary (10% traffic)"
      # kubectl set image deployment/app app=app:$version --record
      # kubectl rollout status deployment/app --timeout=5m
      log "✓ Production canary deployment started"
      ;;
  esac
}

health_check() {
  local env=$1
  local endpoint=$2
  local max_attempts=$((TIMEOUT / HEALTH_CHECK_INTERVAL))
  local attempt=0
  
  log "Performing health checks on $env ($endpoint)"
  
  while [ $attempt -lt $max_attempts ]; do
    if curl -f -s "$endpoint/health" > /dev/null 2>&1; then
      log "✓ Health check passed"
      return 0
    fi
    
    ((attempt++))
    if [ $attempt -lt $max_attempts ]; then
      log "Health check attempt $attempt/$max_attempts failed, retrying..."
      sleep $HEALTH_CHECK_INTERVAL
    fi
  done
  
  log "✗ Health check failed after $max_attempts attempts"
  return 1
}

smoke_tests() {
  local env=$1
  local endpoint=$2
  
  log "Running smoke tests on $env"
  
  # Example tests
  if curl -f -s "$endpoint/api/status" | grep -q '"status":"ok"'; then
    log "✓ API status test passed"
  else
    log "✗ API status test failed"
    return 1
  fi
  
  # Add more smoke tests as needed
}

rollback() {
  local env=$1
  local previous_version=$2
  
  log "Rolling back $env to version $previous_version"
  
  case "$env" in
    staging)
      log "Rolling back staging deployment"
      # docker rm -f app-staging
      # docker run -d --name app-staging -p 3000:3000 app:$previous_version
      ;;
    production)
      log "Rolling back production deployment"
      # kubectl rollout undo deployment/app
      # kubectl rollout status deployment/app
      ;;
  esac
  
  log "✓ Rollback completed"
}

main() {
  if [ -z "$CI" ]; then
    log "Error: This script should run in CI environment"
    exit 1
  fi
  
  # Get deployment version from git tag or commit hash
  local version="${CI_COMMIT_TAG:-${CI_COMMIT_SHA:0:7}}"
  local current_endpoint="http://localhost:3000"
  
  log "Deployment pipeline started"
  log "Environment: $ENVIRONMENT"
  log "Version: $version"
  
  # Deploy
  if ! deploy "$ENVIRONMENT" "$version"; then
    log "✗ Deployment failed"
    exit 1
  fi
  
  sleep 5  # Wait for deployment to stabilize
  
  # Health checks
  if ! health_check "$ENVIRONMENT" "$current_endpoint"; then
    log "✗ Health check failed, initiating rollback"
    rollback "$ENVIRONMENT" "${PREVIOUS_VERSION:-latest}"
    exit 1
  fi
  
  # Smoke tests
  if ! smoke_tests "$ENVIRONMENT" "$current_endpoint"; then
    log "✗ Smoke tests failed, initiating rollback"
    rollback "$ENVIRONMENT" "${PREVIOUS_VERSION:-latest}"
    exit 1
  fi
  
  log "✓ Deployment successful"
}

main "$@"
