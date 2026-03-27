# Software inventory and reproducibility

Record everything you install or run here. For each item include:
- Name, vendor, version
- Download URL (or repository), checksum (sha256), local path in this repo if stored
- Commands used to install or configure

Example entry:

- GeoVision GV‑EasySetup (web plugin)
  - Vendor: GeoVision
  - Version: unknown (record after download)
  - URL: https://www.geovision.com
  - Local copy: software/geovision_gv-easysetup.exe (add if you keep installers)
  - SHA256: <fill in after download>
  - Install notes: run installer as administrator, allow firewall access, reboot if prompted.

- FileZilla Server
  - Vendor: FileZilla
  - Version: <recorded version>
  - URL: https://filezilla-project.org
  - Notes: create FTP user `geovision`, map native path, listen on port 21.

When you download installers or firmware, create a `software/` folder and add the files or at minimum the metadata and checksums so future users can verify what was used.
