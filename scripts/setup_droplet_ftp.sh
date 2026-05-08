#!/usr/bin/env bash
# Setup FTP server on DigitalOcean Droplet + rclone for Spaces sync
# Usage: ssh root@<droplet-ip> < setup_droplet_ftp.sh
# Or: cat setup_droplet_ftp.sh | ssh root@164.90.145.83

set -euo pipefail

echo "=========================================="
echo "FTP + Spaces Sync Setup for Ubuntu Droplet"
echo "=========================================="

# Update system
echo "[1/5] Updating system packages..."
apt update && apt upgrade -y

# Install vsftpd (FTP server) and curl
echo "[2/5] Installing vsftpd and tools..."
apt install -y vsftpd curl wget

# Create FTP upload directory
echo "[3/5] Creating FTP upload directory..."
mkdir -p /home/camera_upload
chmod 755 /home/camera_upload

# Create geovision FTP user (non-login shell)
echo "[4/5] Setting up geovision FTP user..."
if ! id -u geovision &>/dev/null; then
  useradd -d /home/camera_upload -s /usr/sbin/nologin -m geovision || true
fi
chmod 755 /home/camera_upload

# Set password for geovision (change this!)
echo "geovision:geovision" | chpasswd

# Configure vsftpd
echo "[5/5] Configuring vsftpd..."
cat > /etc/vsftpd.conf << 'EOF'
listen=YES
listen_ipv6=NO
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
use_localtime=YES
xferlog_enable=YES
xferlog_file=/var/log/vsftpd.log
xferlog_std_format=YES
idle_session_timeout=600
data_connection_timeout=120
nopriv_user=nobody
chroot_local_user=YES
allow_writeable_chroot=YES
user_config_dir=/etc/vsftpd/user_conf
local_root=/home/camera_upload
pasv_enable=YES
pasv_min_port=65000
pasv_max_port=65001
EOF

# Create per-user config directory
mkdir -p /etc/vsftpd/user_conf

# Create geovision user config (lock to /home/camera_upload)
cat > /etc/vsftpd/user_conf/geovision << 'EOF'
local_root=/home/camera_upload
write_enable=YES
EOF

# Restart vsftpd
systemctl restart vsftpd
systemctl enable vsftpd

echo ""
echo "✓ FTP server ready!"
echo "  - User: geovision"
echo "  - Password: geovision (CHANGE THIS!)"
echo "  - Upload dir: /home/camera_upload"
echo "  - Server: 164.90.145.83:21"
echo ""
echo "Next: Install rclone to sync to Spaces by running:"
echo "  curl https://rclone.org/install.sh | bash"
echo ""
