# Project highlights — Flood-area camera proposal

Purpose: deploy camera systems to monitor flood-prone areas. Provide reproducible setup steps so students and future reviewers can install, configure, and verify cameras and supporting software.

Quick facts:
- Camera vendor used in notes: GeoVision (example configuration included).
- Primary workflow: camera uploads photos to FTP server on a laptop (FileZilla) for collection and review.
- Network model: direct Ethernet for initial testing; later PoE/switch or cellular modem for field deployment.

Key deliverables in this repo:
- Step-by-step setup guides for initial testing and field deployment.
- Per-camera folders containing config templates and example commands.
- Software inventory with exact installers/versions and any scripts used.

Who this is for:
- Students: follow `docs/*` to learn how to assemble and configure systems.
- Field techs: use `cameras/*` templates to deploy consistently.
- Employers/auditors: review `HIGHLIGHTS.md` and `SOFTWARE_INVENTORY.md` for reproducibility evidence.
