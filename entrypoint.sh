#!/bin/env sh
set -e

/bin/ghz "$@"

# Upload Results
if [ -n "${REPORT_PRESIGNED_URL}" ]; then
  echo "=== Saving report to Object storage ==="
  tar -zcf results.tar ../results
  curl -X PUT -H "Content-Type: application/x-tar" -T results.tar -L "${REPORT_PRESIGNED_URL}"
fi
