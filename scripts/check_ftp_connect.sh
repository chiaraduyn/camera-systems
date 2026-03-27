#!/usr/bin/env bash
# Simple FTP connect test using curl. Usage:
#   ./check_ftp_connect.sh <ftp_server> <username> <password>

set -euo pipefail

if [ "$#" -lt 1 ]; then
  echo "Usage: $0 <ftp_server> [username] [password]"
  exit 2
fi

FTP_SERVER="$1"
USER="${2:-anonymous}"
PASS="${3:-}" 

echo "Testing FTP connection to ${FTP_SERVER} as ${USER}..."

# Try a simple directory listing
if command -v curl >/dev/null 2>&1; then
  STATUS=$(curl -s --ftp-method nocwd "ftp://${USER}:${PASS}@${FTP_SERVER}/" || true)
  if [ -z "$STATUS" ]; then
    echo "No response from FTP server or anonymous directory listing returned empty (check credentials)."
  else
    echo "FTP server responded. Sample output:" 
    echo "$STATUS" | head -n 20
  fi
else
  echo "curl not installed. Please install curl to run this test."
  exit 3
fi
