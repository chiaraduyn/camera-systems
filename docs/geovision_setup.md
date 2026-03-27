# GeoVision camera — setup guide (direct-to-PC)

This guide converts the raw notes into a step-by-step, reproducible procedure for students and deployers.

Assumptions / contract:
- Inputs: a GeoVision camera, a Windows PC with Ethernet, power (PoE optional), and downloaded GeoVision firmware/software.
- Outputs: camera uploads snapshot images to an FTP folder on the PC when motion or scheduled snapshots occur.
- Error modes: network mismatch (wrong subnet), FileZilla not listening, wrong FTP credentials, camera settings not applied.

1) Network basics
- Example IPs used in the notes:
  - PC Ethernet IP: 192.168.13.50
  - Camera IP: 192.168.13.100
  - Subnet mask: 255.255.255.0
- Both devices must be in the same subnet.

2) Install GeoVision software
- Download GV-EasySetup / WebConfig Plugin from the GeoVision website.
- Install, allow drivers and firewall permissions, reboot if prompted.

3) Optional: Firmware update
- Access camera via web interface (http://<camera-ip>).
- Maintenance → Firmware Upgrade → upload .bin → wait for restart.

4) Static IP for direct connection
- If connecting the camera directly to the laptop, configure static IPs on the laptop Ethernet and camera as above.

5) FileZilla Server setup
- Create a folder for uploads, e.g., C:\Users\Guest-UH\Desktop\Geovision_FTP
- In FileZilla Server: Edit → Users → Add user `geovision` with password `geovision123` (example)
- Shared folders → add the native path, virtual path `/`, allow Read/Write and create directories if missing.
- Ensure FileZilla is listening on port 21 and Windows Firewall allows it. Use real IP (192.168.13.50), not 127.0.0.1.

6) Camera FTP configuration (Web Interface → Network → FTP)
- Server IP: laptop Ethernet IP (e.g., 192.168.13.50)
- Port: 21
- Username/password: match FileZilla user
- Upload Images: enabled (for now, leave video upload off)
- File Path: `/` (root of mapped folder)
- File Name: template like CAM1_%Y-%m-%d_%H-%M-%S.jpg
- Overwrite: OFF
- Test and watch FileZilla log for connection and STOR

7) Motion detection and rule setup (Event → Motion Detection)
- Enable motion detection, draw zones, sensitivity 55–65%, object size medium.
- Event → Rule Settings → Conventional → Trigger Source: Motion Detection.
- Attach action: Upload to FTP, send 1 image per trigger with 1 sec interval.
- Enable Plan → set schedule to armed 24/7 if desired.

8) Testing checklist
- Clear the FTP folder.
- Trigger motion in live view.
- Confirm files appear in the folder and FileZilla shows connection and STOR logs.
- If it fails: check FileZilla listening, firewall, subnet, and camera rules.

9) Optional enhancements & field notes
- Use scheduled snapshots (e.g., every 5 minutes) for flood monitoring instead of relying solely on motion triggers.
- Add naming conventions and rotation/cleanup scripts to manage storage.
- Field deployment: transition to PoE with a switch or a cellular modem (e.g., Sierra Wireless) that uses the same FTP uploading rules.

10) Reproducibility notes
- Save any downloaded installers, firmware, and checksums to `software/` and list them in `SOFTWARE_INVENTORY.md`.
- Commit camera-specific configs into `cameras/<camera-name>/` (example below).
