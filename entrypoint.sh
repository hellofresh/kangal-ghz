#!/bin/env sh
set -e

/bin/ghz "$@"

# Upload Results
if [ -n "${REPORT_PRESIGNED_URL}" ]; then
  echo "=== Saving report to Object storage ==="
  curl -X PUT -H "Content-Type: application/x-tar" -T ../results.html -L "${REPORT_PRESIGNED_URL}"
fi
