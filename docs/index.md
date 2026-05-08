# Camera Systems — Monitoring Setup & Documentation

Documentation and configuration notes for SLOSH Lab camera setups and troubleshooting.

This repository contains documentation, configuration templates, and scripts to set up cameras for environmental monitoring. It is organized so both newcomers (students, field techs) and future reviewers (employers, auditors) can quickly find highlights and deep-dive into details.

Top-level overview:

- [README.md](../README.md) — quick orientation.
- [HIGHLIGHTS.md](highlights.md) — one-page summary for reviewers or employers.
- [PROPOSAL.md](proposal.md) — project proposal checklist and deliverables.
- [docs/](.) — step-by-step guides and scenario documents (setup, network, FTP, motion rules, modem recovery, cloud bridge).
- [cameras/](../cameras) — per-camera folders; each contains configs, sample images, and notes.
- [scripts/](../scripts) — small helper scripts (tests, rotation, automation examples).
- [SOFTWARE_INVENTORY.md](software_inventory.md) — canonical place to list installers, downloads, checksums, and commands used.

For contributors: keep secrets out of git (use local `.env` files, OS keychains, or a `secrets/` directory that is gitignored). When adding a new camera type, create `cameras/<vendor>/` and a scenario in `docs/scenarios/`.

If you run installers or save downloaded files, add them (or record their metadata) under `software/` and update [SOFTWARE_INVENTORY.md](software_inventory.md) so future reviewers can reproduce your environment.
