# GeoVision camera — per-camera assets

This folder contains templates and per-deployment notes for GeoVision cameras.

Files you should add here per deployment:
- `config.json` — exported settings or a small JSON manifest describing IP, credentials (DO NOT store plaintext secrets in git; use placeholders), and upload settings.
- `example_filename_template.txt` — example naming conventions.
- `notes.md` — deployment-specific notes (mounting location, power, PoE injector model, etc.).

Example `config.json` (DO NOT commit secrets):

{
  "camera_model": "GV-TBL8804",
  "ip": "192.168.13.100",
  "ftp_server": "192.168.13.50",
  "ftp_user": "geovision",
  "snapshot_interval_minutes": 5
}
