# Quick Setup Checklist: Reolink → Spaces Pipeline

**Droplet IP**: 164.90.145.83
**Bucket**: photo-ftp-store (sfo3)
**Access Key**: DO8016PL8P9XJZMHVQ9P
**Region**: sfo3

---

## Phase 1: Droplet FTP Setup (5 min)

- [ ] SSH into: `ssh root@164.90.145.83`
- [ ] Run: `bash scripts/setup_droplet_ftp.sh` (from repo or inline)
- [ ] Verify vsftpd: `systemctl status vsftpd`

## Phase 2: rclone Configuration (3 min)

- [ ] Run: `bash scripts/configure_rclone.sh`
- [ ] **Edit `/root/.config/rclone/rclone.conf`** → add your Secret Key
- [ ] Test: `rclone --config /root/.config/rclone/rclone.conf lsd do_spaces:`

## Phase 3: Enable Sync Service (2 min)

- [ ] Copy files to system:
  ```bash
  sudo cp scripts/spaces_sync_watch.sh /usr/local/bin/ && chmod +x /usr/local/bin/spaces_sync_watch.sh
  sudo cp scripts/spaces-sync.service /etc/systemd/system/
  ```
- [ ] Enable: `sudo systemctl daemon-reload && sudo systemctl enable spaces-sync && sudo systemctl start spaces-sync`
- [ ] Check status: `sudo systemctl status spaces-sync`

## Phase 4: Reolink App Configuration (2 min)

- [ ] Open Reolink app → Settings → **Network → FTP**
- [ ] **Server IP**: `164.90.145.83`
- [ ] **Username**: `geovision`
- [ ] **Password**: `geovision`
- [ ] **Port**: `21`
- [ ] Enable "Upload Images" / "Upload on Motion"
- [ ] Click **Test** → should succeed

## Phase 5: Test End-to-End (2 min)

- [ ] Take snapshot in Reolink app
- [ ] SSH into Droplet, check: `ls -la /home/camera_upload/`
- [ ] Wait 5-10 seconds for sync
- [ ] Verify in Spaces: `rclone --config /root/.config/rclone/rclone.conf ls do_spaces:photo-ftp-store/camera-uploads`

---

## Total Time: ~15 minutes

**If stuck**, check:
- Droplet IP is reachable: `ping 164.90.145.83`
- FTP port open: `nmap -p 21 164.90.145.83` (or telnet)
- Sync logs: `tail -f /var/log/spaces-sync.log` on Droplet
- Full guide: `docs/scenarios/reolink_ftp_to_spaces.md`
