#!/usr/bin/env bash
# Watch FTP upload dir and sync to DigitalOcean Spaces using rclone
# Install: curl https://rclone.org/install.sh | bash
# Usage: sudo systemctl start spaces-sync && sudo systemctl status spaces-sync

set -euo pipefail

UPLOAD_DIR="/home/camera_upload"
SPACES_REMOTE="do_spaces:photo-ftp-store"
LOG_FILE="/var/log/spaces-sync.log"

# Ensure rclone is installed
if ! command -v rclone &>/dev/null; then
  echo "ERROR: rclone not installed. Run: curl https://rclone.org/install.sh | bash"
  exit 1
fi

# Function to sync files
sync_to_spaces() {
  local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo "[$timestamp] Syncing from $UPLOAD_DIR to $SPACES_REMOTE" >> "$LOG_FILE"

  # Copy new files to Spaces, keeping same directory structure
  if rclone --config /root/.config/rclone/rclone.conf \
           copy "$UPLOAD_DIR" "$SPACES_REMOTE/camera-uploads" \
           --progress --log-level INFO --log-file "$LOG_FILE" 2>&1; then
    echo "[$timestamp] Sync completed successfully" >> "$LOG_FILE"
    # Optional: delete local files after successful sync
    # find "$UPLOAD_DIR" -type f -mtime +1 -delete
  else
    echo "[$timestamp] Sync failed - check log" >> "$LOG_FILE"
  fi
}

# Watch directory for changes using inotify
if command -v inotifywait &>/dev/null; then
  echo "Watching $UPLOAD_DIR for changes (press Ctrl+C to stop)..."
  inotifywait -m -r -e close_write "$UPLOAD_DIR" |
  while read path action file; do
    if [[ "$file" =~ \.(jpg|jpeg|png|mp4|avi)$ ]]; then
      echo "Detected: $file - syncing to Spaces..."
      sleep 2  # Wait 2s to ensure file is fully written
      sync_to_spaces
    fi
  done
else
  # Fallback: use cron every minute
  sync_to_spaces
fi
