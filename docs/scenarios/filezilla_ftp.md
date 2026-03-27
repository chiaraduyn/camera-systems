# Scenario: FileZilla FTP server for collecting camera snapshots (Windows)

Purpose: configure a local FTP server on a Windows laptop to receive snapshots from cameras (used in lab and early deployments).

Steps

1. Create a folder for uploads
- Example: C:\Users\Guest-UH\Desktop\Geovision_FTP

2. Install FileZilla Server
- Download from https://filezilla-project.org and install as a service if desired.

3. Create FTP user
- FileZilla Server → Edit → Users → Add user (e.g., `geovision`) → set a password.

4. Map shared folder
- Users → Shared folders → Add native path (e.g., the folder from step 1) and set Virtual Path `/`.
- Grant Read and Write permissions, and enable `Create native directory if it does not exist`.

5. Networking and firewall
- Ensure FileZilla Server is listening on port 21 and Windows Firewall allows incoming connections to the FileZilla service.
- When cameras will connect directly to the laptop, use the laptop's real IP (e.g., 192.168.13.50) not 127.0.0.1.

6. Test from camera
- Camera web UI → Network → FTP: set Server IP to laptop IP, Port 21, username/password, enable Upload Images.
- Use the `Test` button and watch FileZilla logs for connection and `STOR` events.

7. Troubleshooting
- If uploads fail: check FileZilla is running and listening, Windows Firewall rules, that the camera and laptop are on the same subnet, and that the FTP credentials match.

Automation tips
- For long-running deployments, add a rotation/cleanup script (move images to an archive, or delete after N days). Put scripts in `scripts/` and document cron/scheduled task entries.

See also: `../scenarios/geovision_direct.md` and `scripts/check_ftp_connect.sh`.
