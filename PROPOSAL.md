# Flood Monitoring Camera Proposal

Project goal: design and document a reusable system to monitor areas that flood. The city wants a clear proposal and reproducible setup so cameras and software can be installed, maintained, and audited.

Audience and reuse:
- Students: step-by-step instructions to build, test, and deploy camera setups.
- Field techs: configuration templates and scripts for consistent deployments.
- Employers/auditors: concise highlights and a complete software inventory so they can reproduce the environment.

What to include in the repo for each deployment (requirements):
1. Hardware & placement notes: camera model, mount location, PoE/surge protection, power source.
2. Network & connectivity: IP plan, firewall rules, modem or PoE switch models, and sample NAT/port-forwarding if remote access is needed.
3. Software & firmware: installers, firmware, checksums (or at minimum names and exact versions). Put actual files in `software/` if permitted by licensing, otherwise list metadata in `SOFTWARE_INVENTORY.md`.
4. Configuration: exported camera settings or `config.json` templates in `cameras/<name>/` (avoid committing secrets).
5. Scripts & automation: any scripts run for rotation, uploading, or maintenance in `scripts/` with usage notes.
6. Highlights & report: a one-page summary showing what was done, key findings, and where data is stored — add to `HIGHLIGHTS.md`.

How students should work with this repo:
- Treat `README.md` and `HIGHLIGHTS.md` as the starting point.
- Use `docs/` for step-by-step tasks.
- When you download or run third-party installers, update `SOFTWARE_INVENTORY.md` with the version and checksum and add the installer under `software/` if allowed.
- Keep secrets out of git. Use local `.env` files, OS keychains, or hardware secret management.

Deliverables for the city proposal:
- This repo (or a zipped snapshot) with `HIGHLIGHTS.md`, `PROPOSAL.md`, `SOFTWARE_INVENTORY.md`, and one or more `cameras/*` folders populated with configs. If required, include example images or a demo video to show proof of concept.
