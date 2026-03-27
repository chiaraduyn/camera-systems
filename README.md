# Camera Systems — Setup & Flood Monitoring Proposal

This repository contains documentation, configuration templates, and scripts to set up cameras for flood monitoring. It is organized so both newcomers (students, field techs) and future reviewers (employers, auditors) can quickly find highlights and deep-dive into details.

Top-level overview:

- `README.md` — this file (quick orientation).
- `HIGHLIGHTS.md` — one-page summary for reviewers or employers.
- `docs/` — step-by-step guides and background (setup, network, FTP, motion rules).
- `cameras/` — per-camera folders; each contains configs, sample images, and notes.
- `scripts/` — small helper scripts (recording software, checksums, automation examples).
- `SOFTWARE_INVENTORY.md` — canonical place to list installers, downloads, checksums, and commands used.

How to use this repo as an end user:

1. Read `HIGHLIGHTS.md` for the short story.
2. Pick a camera in `cameras/` (start with `cameras/geovision`).
3. Follow the step-by-step guide in `docs/geovision_setup.md` for initial setup.
4. Reuse templates in the camera folder and add your own configs and scripts.

If you run installers or save downloaded files, add them (or record their metadata) under `software/` and update `SOFTWARE_INVENTORY.md` so future reviewers can reproduce your environment.
# camera-systems
Documentation and configuration notes for SLOSH Lab camera setups and troubleshooting 
