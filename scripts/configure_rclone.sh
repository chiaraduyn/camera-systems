#!/usr/bin/env bash
# After running setup_droplet_ftp.sh, run this to configure rclone for Spaces
# Usage: bash configure_rclone.sh

set -euo pipefail

echo "=========================================="
echo "Configuring rclone for DigitalOcean Spaces"
echo "=========================================="

# Install rclone if needed
if ! command -v rclone &>/dev/null; then
  echo "[*] Installing rclone..."
  curl https://rclone.org/install.sh | bash
fi

# Create rclone config directory
mkdir -p /root/.config/rclone

# Create rclone config for Spaces
cat > /root/.config/rclone/rclone.conf << 'RCLONE_EOF'
[do_spaces]
type = s3
provider = DigitalOcean
access_key_id = DO8016PL8P9XJZMHVQ9P
secret_access_key = YOUR_SECRET_KEY_HERE
region = sfo3
endpoint = https://sfo3.digitaloceanspaces.com
RCLONE_EOF

echo ""
echo "⚠️  IMPORTANT: Update the secret key in /root/.config/rclone/rclone.conf"
echo "   Paste your actual secret key (replace YOUR_SECRET_KEY_HERE)"
echo ""
echo "Test the connection:"
echo "  rclone --config /root/.config/rclone/rclone.conf lsd do_spaces:"
echo ""
