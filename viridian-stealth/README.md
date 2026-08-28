# Viridian Stealth — Background Telemetry Killer

> **What this is:** The "background sneaky shit" from Viridian Free Utility v0.1.0 — packaged standalone so you can review/apply/revert without the full tweak suite.
> **Source:** `ViridianFreeEngine.exe` (321,536 B) strings + live `action:steps` — see `SOURCE.md`. Public mirror: `https://github.com/omnibot007/viridian-tweaks`

## What it does (hood terms)

Tells Windows to stop snitching + stop wasting CPU on reports.

**8 scheduled tasks → DISABLED:**
- `\Microsoft\Windows\Customer Experience Improvement Program\Consolidator`
- `\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser`
- `\Microsoft\Windows\Application Experience\ProgramDataUpdater`
- `Microsoft\Windows\Defrag\ScheduledDefrag`
- `Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector`
- `Microsoft\Windows\Feedback\Siuf\DmClient`
- `Microsoft\Windows\Maps\MapsUpdateTask`
- `Microsoft\Windows\Maintenance\WinSAT`

**2 registry kills:**
- `HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection AllowTelemetry = 0` (was 1)
- `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo Enabled = 0` (was 1)

Plus blanks `C:\ProgramData\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl` on system-clean path (not in this stealth pack — that's file delete).

**Effect:** less background CPU, less data sent to Microsoft, no more "how was Windows?" feedback, defrag/maps/auto-bench stop running. SSD users don't need ScheduledDefrag anyway.

## Fully revertible

Every disable has an exact `enable` opposite. No files deleted in this pack (unlike full Viridian `debloat`/`system-clean`).

## Usage

```powershell
# PREVIEW (no writes)
.\scripts\Apply.ps1 -DryRun
.\scripts\Revert.ps1 -DryRun

# APPLY (stealth on — must run elevated)
.\scripts\Apply.ps1

# REVERT (stealth off)
.\scripts\Revert.ps1

# CHECK
.\scripts\Verify.ps1
```

Backup is auto-created at `C:\Users\LENOVO\.backup\viridian-stealth-pre-<timestamp>\` + System Restore Point.

## Repo layout

```
viridian-stealth/
├── README.md
├── CATALOG.json  — machine-readable forward/revert
├── SOURCE.md     — verification
└── scripts/
    ├── Apply.ps1
    ├── Revert.ps1
    └── Verify.ps1
```
