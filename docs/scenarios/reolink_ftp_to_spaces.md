# Scenario: Reolink → Droplet FTP → DigitalOcean Spaces

**Goal**: Stream camera images from Reolink app → FTP server on your Ubuntu Droplet → Automatically sync to DigitalOcean Spaces bucket.

---

## Prerequisites

- DigitalOcean Droplet running Ubuntu (164.90.145.83)
- DigitalOcean Spaces bucket: `photo-ftp-store` (sfo3)
- Access Key: `DO8016PL8P9XJZMHVQ9P`
- Secret Key: (stored securely, not in git)
- Reolink camera configured to upload via FTP

---

## Step 1: SSH into Droplet and Run FTP Setup

```bash
ssh root@164.90.145.83
```

Download and run the setup script:

```bash
curl -o setup_droplet_ftp.sh https://raw.githubusercontent.com/<YOUR_REPO>/camera-systems/main/scripts/setup_droplet_ftp.sh
bash setup_droplet_ftp.sh
```

**What it does:**
- Installs vsftpd (FTP server)
- Creates `/home/camera_upload` directory for FTP uploads
- Creates `geovision` FTP user
- Configures vsftpd to allow uploads

---

## Step 2: Configure rclone for Spaces

Still SSH'd into the Droplet, run:

```bash
curl -o configure_rclone.sh https://raw.githubusercontent.com/<YOUR_REPO>/camera-systems/main/scripts/configure_rclone.sh
bash configure_rclone.sh
```

**Edit the rclone config with your secret key:**

```bash
nano /root/.config/rclone/rclone.conf
```

Update this line with your actual DigitalOcean Spaces secret key:
```
secret_access_key = DO8016PL8P9XJZMHVQ9P  <-- Replace with actual secret
```

Save with `Ctrl+X`, then `Y`, then `Enter`.

**Test the connection:**

```bash
rclone --config /root/.config/rclone/rclone.conf lsd do_spaces:
```

Should list your Spaces bucket contents.

---

## Step 3: Enable the Sync Service

Install and enable the systemd service to automatically sync uploads:

```bash
# Copy sync script to system location
sudo cp scripts/spaces_sync_watch.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/spaces_sync_watch.sh

# Copy systemd service
sudo cp scripts/spaces-sync.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable spaces-sync
sudo systemctl start spaces-sync

# Check status
sudo systemctl status spaces-sync
```

---

## Step 4: Configure Reolink App FTP Upload

In your Reolink app or camera web UI:

1. Go to **Settings** → **Network** → **FTP**
2. **Server IP**: `164.90.145.83`
3. **Server Port**: `21`
4. **Username**: `geovision`
5. **Password**: `geovision` (change this in `/etc/vsftpd.conf` on the Droplet for security)
6. **Enable "Upload Images"** or **"Upload on Motion"**
7. **Test connection** - should succeed

---

## Step 5: Monitor Sync Progress

SSH into Droplet and watch the sync logs:

```bash
tail -f /var/log/spaces-sync.log
```

Or check systemd journal:

```bash
journalctl -u spaces-sync -f
```

---

## Testing the Pipeline

1. **Trigger an upload from Reolink**
   - Take a snapshot or motion capture in the Reolink app

2. **Verify FTP upload**
   ```bash
   ssh root@164.90.145.83 "ls -la /home/camera_upload/"
   ```

3. **Verify Spaces sync**
   ```bash
   rclone --config /root/.config/rclone/rclone.conf ls do_spaces:photo-ftp-store/camera-uploads
   ```

---

## Troubleshooting

### FTP Connection Fails
```bash
# Test FTP from local machine
./scripts/check_ftp_connect.sh 164.90.145.83 geovision geovision

# Or check if vsftpd is running
ssh root@164.90.145.83 "systemctl status vsftpd"
```

### Spaces Upload Fails
```bash
# Check rclone config
ssh root@164.90.145.83 "rclone --config /root/.config/rclone/rclone.conf fsinfo do_spaces:"

# Verify credentials
ssh root@164.90.145.83 "cat /root/.config/rclone/rclone.conf"
```

### Files Not Being Synced
```bash
# Check if sync service is running
ssh root@164.90.145.83 "systemctl status spaces-sync"

# Check for inotify support
ssh root@164.90.145.83 "apt install inotify-tools -y"
```

---

## Security Notes

⚠️ **Production Considerations:**

1. **Change FTP password**:
   ```bash
   ssh root@164.90.145.83 "echo 'geovision:STRONG_PASSWORD' | chpasswd"
   ```

2. **Use SFTP instead of FTP** (more secure):
   - Install openssh-server on Droplet (usually pre-installed)
   - Configure camera to use SFTP (port 22)

3. **Restrict uploads by file age**:
   ```bash
   # Uncomment in spaces_sync_watch.sh to delete files after sync
   # find "$UPLOAD_DIR" -type f -mtime +1 -delete
   ```

4. **Store credentials securely**:
   - Keep Spaces secret key in `.env` or OS keychain
   - Never commit to git
   - Rotate keys periodically

---

## Full Deployment Command (One-Liner)

SSH into Droplet and run:

```bash
apt update && apt install -y vsftpd curl inotify-tools && \
mkdir -p /home/camera_upload && chmod 755 /home/camera_upload && \
useradd -d /home/camera_upload -s /usr/sbin/nologin -m geovision 2>/dev/null || true && \
echo "geovision:geovision" | chpasswd && \
curl https://rclone.org/install.sh | bash && \
echo "✓ Setup complete! Configure rclone.conf and enable sync service."
```

---

## See Also

- `../droplet_to_spaces.md` — High-level architecture overview
- `../filezilla_ftp.md` — Local Windows FTP server alternative
- `../../SOFTWARE_INVENTORY.md` — Tool versions and updates
