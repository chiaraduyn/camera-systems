# Scenario: Sierra Wireless RV55 modem — firmware update and recovery

Purpose: update firmware and recover the Sierra Wireless RV55 modem (used for remote field deployments with cellular backhaul).

Steps (summary)

1. Hard reset
- Hold the modem power button until the power LED flashes amber (not red) to perform a hard reset.

2. Download firmware
- Get the correct ALEOS firmware for RV55 (example: ALEOS 4.16.2.001) from the official Sierra Wireless site.

3. Recovery upload via AceManager
- Connect PC to RV55 via Ethernet and ensure PC Wi-Fi is off.
- Open AceManager but change the port to `9191` and use `http://192.168.13.31:9191` rather than HTTPS for recovery uploads.
- Upload the firmware file on the recovery page.

Notes
- Follow official Sierra Wireless documentation and record firmware versions and checksums in `SOFTWARE_INVENTORY.md`.
- Keep a physical checklist for field technicians: SIM provisioning, antenna connections, power-cycling steps, and signal testing.
