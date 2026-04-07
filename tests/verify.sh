#!/usr/bin/env bash
# Purpose: Verify the nginx role applied correctly on the target host
# Usage: bash tests/verify.sh [host_ip]
#
# Prerequisites: SSH access to target host, nginx deployed via playbook

set -euo pipefail

HOST="${1:-localhost}"
HTTP_PORT="${2:-80}"
HTTPS_PORT="${3:-443}"

pass=0
fail=0

check() {
  local desc="$1"
  local cmd="$2"
  if eval "$cmd" &>/dev/null; then
    echo "PASS: $desc"
    ((pass++))
  else
    echo "FAIL: $desc"
    ((fail++))
  fi
}

echo "=== Nginx Role Verification: $HOST ==="
echo ""

# Check nginx process is running
check "nginx process running" "ssh ${HOST} 'pgrep nginx'"

# Check nginx config syntax
check "nginx config valid" "ssh ${HOST} 'sudo nginx -t'"

# Check HTTP response on expected port
check "HTTP port $HTTP_PORT responds" "curl --silent --fail --max-time 5 http://${HOST}:${HTTP_PORT}/"

# Check server_tokens is off (nginx version hidden)
check "server_tokens hidden" "! curl --silent --head http://${HOST}:${HTTP_PORT}/ | grep -i 'nginx/'"

# Check security header is set  
check "X-Content-Type-Options header present" \
  "curl --silent --head http://${HOST}:${HTTP_PORT}/ | grep -i 'X-Content-Type-Options'"

echo ""
echo "Results: PASS=$pass FAIL=$fail"

if [ "$fail" -gt 0 ]; then
  exit 1
fi
