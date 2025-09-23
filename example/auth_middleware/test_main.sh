#!/usr/bin/env bash
set -euo pipefail

# Simplified test script for auth_veb demo
FAILURES=0
PORT=${PORT:-8081}

echo -n "Waiting for server on localhost:${PORT}... "
MAX_WAIT=20
i=0
while [ $i -lt ${MAX_WAIT} ]; do
  if nc -z localhost ${PORT} >/dev/null 2>&1; then
    echo "ok"
    break
  fi
  sleep 0.5
  i=$((i+1))
done
if [ $i -ge ${MAX_WAIT} ]; then
  echo "failed (port ${PORT} not open)"
  exit 2
fi

check() {
  local method=$1; shift
  local url=$1; shift
  local expect_code=$1; shift
  local headers=()
  if [ $# -gt 0 ]; then
    headers=("$@")
  fi

  code=$(curl -s -o /dev/null -w "%{http_code}" -X "${method}" "${url}" ${headers[@]:+"${headers[@]}"})
  if [ "$code" != "$expect_code" ]; then
    echo "FAILED: ${method} ${url} -> got ${code}, expected ${expect_code}"
    FAILURES=$((FAILURES+1))
  else
    echo "OK: ${method} ${url} -> ${code}"
  fi
}

# Quick, compact checks for main endpoints
# login once and capture token
resp=$(curl -s -w "\n%{http_code}" -X POST "http://localhost:${PORT}/login")
# remove last line (status code) to get the body in a portable way
body=$(echo "$resp" | sed '$d')
code=$(echo "$resp" | tail -n1)
if [ "$code" = "200" ]; then
  token=$(echo "$body" | sed -n 's/.*"token"[[:space:]]*:[[:space:]]*"\([^\"]*\)".*/\1/p')
  if [ -z "$token" ]; then
    echo "FAILED: POST /login -> 200 but token missing in body: ${body}"
    FAILURES=$((FAILURES+1))
  else
    echo "OK: POST /login -> 200 and token present"
  fi
else
  echo "FAILED: POST /login -> code=${code} body=${body}"
  FAILURES=$((FAILURES+1))
fi

# Basic auth checks using the existing helper
check GET "http://localhost:${PORT}/admin/users" 401
check GET "http://localhost:${PORT}/admin/users" 401 -H "Authorization: Bearer badtoken"
check GET "http://localhost:${PORT}/admin/users" 200 -H "Authorization: Bearer admin_token_123"
check GET "http://localhost:${PORT}/admin/users" 403 -H "Authorization: Bearer viewer_token_789"

check GET "http://localhost:${PORT}/admin/posts" 200 -H "Authorization: Bearer editor_token_456"
check GET "http://localhost:${PORT}/admin/posts" 403 -H "Authorization: Bearer viewer_token_789"

# api/data: unauthorized and then a single token check loop
check GET "http://localhost:${PORT}/api/data" 401
for token in admin_token_123 editor_token_456 viewer_token_789; do
  body=$(curl -s -H "Authorization: Bearer ${token}" "http://localhost:${PORT}/api/data")
  code=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer ${token}" "http://localhost:${PORT}/api/data")
  if [ "$code" = "200" ] && echo "$body" | grep -q '"data"'; then
    echo "OK: /api/data with ${token} -> 200 and data present"
  else
    echo "FAILED: /api/data with ${token} -> code=${code} body=${body}"
    FAILURES=$((FAILURES+1))
  fi
done

if [ ${FAILURES} -eq 0 ]; then
  echo "All tests passed."
else
  echo "${FAILURES} test(s) failed."
fi

exit ${FAILURES}
