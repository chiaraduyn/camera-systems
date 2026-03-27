# Scenario: GeoVision camera — direct connection to Windows PC

Purpose: set up a GeoVision camera directly connected to a Windows PC (Ethernet or PoE) so the camera uploads snapshots to an FTP folder on the PC.

When to use: initial testing, lab proof-of-concept, and local deployments without a network gateway.

Steps (summary)

1. Network basics
- Ensure PC and camera are on the same subnet. Example addresses used during testing:
  - PC Ethernet IP: 192.168.13.50
  - Camera IP: 192.168.13.100
  - Subnet mask: 255.255.255.0

2. Install GeoVision software
- Download GV‑EasySetup / WebConfig Plugin from GeoVision and install on the Windows PC. Allow drives and firewall prompts.

3. Optional: Firmware update
- Access camera web UI (http://<camera-ip>) → Maintenance → Firmware Upgrade → upload .bin → wait for restart.

4. Configure static IP for a direct cable connection
- Set static IP on PC Ethernet and camera so they can see each other without a gateway.

5. Configure camera web settings
- Login to camera web interface and set Network → FTP to point at your PC (see `filezilla_ftp.md` for server setup).

6. Motion detection and rules
- Configure motion zones, sensitivity (55–65%), and object size (medium).
- Event → Rule Settings → Conventional → Trigger Source: Motion Detection.
- Attach action: Upload to FTP; set 1 image per trigger, 1 sec interval.

7. Testing checklist
- Clear the FTP folder on the PC.
- Trigger motion in camera live view and confirm images appear.
- Check FTP server logs for connection, login, and STOR entries.

Notes & enhancements
- For flood monitoring, consider scheduled snapshots (e.g., every 5 minutes) rather than relying only on motion events.
- Keep naming convention with timestamps: CAM1_%Y-%m-%d_%H-%M-%S.jpg
- Move configuration templates for each deployment into `cameras/<name>/config.example.json` and never commit secrets.

See also: `../geovision_setup.md`, `filezilla_ftp.md`.
