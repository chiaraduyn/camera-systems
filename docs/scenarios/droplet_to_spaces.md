# Scenario: Use a cloud Droplet as a bridge to object storage (DigitalOcean Space)

Purpose: forward images from cameras (via FTP/SFTP) to cloud object storage. This scenario documents a Linux (Ubuntu) droplet acting as an FTP endpoint, processing uploads, and pushing to object storage.

Summary of typical steps

1. SSH into the droplet
- ssh root@<droplet-ip>

2. System update
- apt update && apt upgrade -y

3. Configure an FTP/SFTP server or an incoming directory watcher
- Option: use vsftpd or sftp + a small processing script that uploads new files to Spaces.

4. Install tools for Spaces (e.g., s3cmd, rclone, or the DigitalOcean CLI)
- Example: install rclone and configure a `spaces` remote using the access key and secret (store credentials in environment variables or a config file outside git).

5. Create a systemd service or inotify-based script
- Watch the upload folder and trigger an `rclone copy` or `s3cmd put` to push files to the Space bucket.

6. Security and maintenance
- Keep the droplet patched (apt upgrade), rotate keys, and restrict SSH (disable password auth, use key pairs).
- Monitor disk usage and create log rotation for processing logs.

Notes from original logs
- The raw notes include example `apt` upgrade output and reminders to reboot when kernel upgrades occur. Apply updates during maintenance windows and reboot when required.

See also: `SOFTWARE_INVENTORY.md` (store any helper tool metadata) and consider providing a sample `rclone` config template in `scripts/`.
