# Viridian Free Utility — Tweaks Catalog (v0.1.0)

> **Source:** `C:\Users\LENOVO\AppData\Local\Programs\Viridian Free Utility\resources\engine\ViridianFreeEngine.exe` (321,536 B) + Electron `resources/app.asar` (`main.js`, `engine-bridge.js`, `renderer/app.html`/`app.js`).
> **Extracted:** 2026-08-28 via live `stdio` JSON interrogation (`action:steps` per group) + raw binary string dump. Every command below is the verbatim `Reg.exe`/`powercfg`/`netsh`/`schtasks`/`ipconfig`/PowerShell string the engine executes.

This repo is a **read-only, reviewable mirror** of what the Viridian Free app would run on your laptop. Nothing here runs automatically — review `scripts/` and run manually when you want.

## How Viridian runs them

- Engine needs admin: spawned via `powershell Start-Process ... -Verb RunAs` on `127.0.0.1:51877` (`engine-bridge.js:32-78`) or inherits elevation when the app is packaged (`StdioEngineBridge`).
- Renderer sends `{action: run|revert|steps|stats|procreduce, group}` → engine replies line-delimited JSON.
- Each card has **Apply** (`data-group`) and **Revert** (`data-revert`) (`renderer/app.html`). `system-clean` and `debloat` have degraded/no revert.

## Risk tiers

| Tier | Groups | Revert |
|------|--------|--------|
| **Safe + fully revertible** | `visual-tweaks`, `disable-animations`, `game-mode`, `mouse-fix`, `input-response`, `flush-dns`, `startup-opt`, `laptop-*`, `power-plan`, `network-basic` | Engine `revert` restores original registry/power values. Also covered by `scripts/Revert-All.ps1`. |
| **Destructive** | `debloat` (17 Appx removals), `system-clean` (deletes `%TEMP%`, `C:\Windows\Temp`, `Prefetch`, `SoftwareDistribution\Download`, `AutoLogger` etl) | Not restored by engine — must reinstall Appx from Store or recreate files. |
| **Transient** | `procreduce` | `EmptyWorkingSet` on 10-20 background procs — reboot restores. |

## Groups at a glance

| Group | UI Location | What it does | Count |
|-------|-------------|--------------|-------|
| `network-basic` | Network Tweaks hero | `winsock reset` + `int ip reset` + flush DNS + RSS/ECN/timestamps/TTL/Tcp1323Opts/throttling/heuristics | 10 |
| `debloat` | Windows Tweaks → Debloat Windows | `Remove-AppxPackage` 17 MS apps | 17 |
| `visual-tweaks` | Windows Tweaks → Visual Tweaks | Transparency/taskbar animations/Task View/Explorer ads/dark theme/file extensions | 6 |
| `disable-animations` | Windows Tweaks → Disable Animations | Transparency/taskbar animations/Aero Shake/window animations/menu delay | 5 |
| `power-plan` | Windows Tweaks → Performance Power Plan | Hibernate off, power throttling off, fast startup off, `High performance` GUID | 4 |
| `system-clean` | General Tweaks → System Clean | Delete temp/prefetch/update cache/telemetry log | 5 |
| `game-mode` | General Tweaks → Enable Game Mode | `AllowAutoGameMode` + `AutoGameModeEnabled` | 2 |
| `mouse-fix` | General Tweaks → Mouse Precision Fix | `MouseSpeed`/`Threshold1`/`Threshold2`/`MouseSensitivity` → 1:1 | 4 |
| `startup-opt` | General Tweaks → Startup Optimizer | Disable Discord/Spotify/Steam/Epic at `StartupApproved\Run` | 4 |
| `flush-dns` | General Tweaks → Flush DNS Cache | `ipconfig /flushdns` + `/registerdns` | 2 |
| `input-response` | General Tweaks → Faster Input Response | `KeyboardDelay 0`, `KeyboardSpeed 31` | 2 |
| `laptop-basic` | Laptop Tweaks → Basic Laptop Tweaks | AC cooling active, USB suspend off AC, WiFi max perf AC, PCIe off AC | 6 |
| `laptop-battery-perf` | Laptop Tweaks → Max Performance on Battery | CPU 100% min/max on DC, USB/WiFi max on DC | 5 |
| `laptop-display` | Laptop Tweaks → Lid & Display | Lid DoNothing AC, monitor timeout 0, adaptive brightness off AC | 4 |
| *(hidden)* telemetry | bundled with debloat/system-clean path | 8 `schtasks /change /disable` + `AllowTelemetry 0`, `AdvertisingInfo 0` | 10 |
| `procreduce` | Process Reduction → Reduce Processes | Trim working set of safe background procs | 10-20 |

## Repo layout

```
viridian-tweaks/
├── README.md               — this file
├── CATALOG.json            — machine-readable catalog (labels + forward/revert commands)
├── docs/
│   ├── GROUPS.md           — per-group deep dive (registry keys + exact commands)
│   ├── REVERT.md           — how to undo safely (in-app vs scripts vs System Restore)
│   └── SOURCE.md           — how extraction was verified
└── scripts/
    ├── Snapshot.ps1        — create Restore Point + reg/power/tasks/Appx backup
    ├── Apply-Group.ps1     — run a single group's forward commands (dry-run default)
    ├── Revert-Group.ps1    — run a single group's revert commands
    ├── Revert-All.ps1      — revert every safe group in dependency-safe order
    └── Verify.ps1          — report current vs expected values
```

## Quick review

```powershell
# 1) Snapshot before you touch anything
.\scripts\Snapshot.ps1

# 2) Preview what a group would do (no writes)
.\scripts\Apply-Group.ps1 -Group network-basic -DryRun

# 3) Actually apply / revert one group
.\scripts\Apply-Group.ps1 -Group visual-tweaks
.\scripts\Revert-Group.ps1 -Group visual-tweaks

# 4) Undo everything safe
.\scripts\Revert-All.ps1 -DryRun
.\scripts\Revert-All.ps1
```

## Current machine snapshot (2026-08-28)

- Active power scheme: `8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c` **High performance** (already applied)
- `HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling\PowerThrottlingOff = 1` (throttling disabled)
- `\Microsoft\Windows\Customer Experience Improvement Program\Consolidator` — **Disabled** (already applied)
- Restore Point / reg backup: **not yet created** — run `Snapshot.ps1`.

## Warning

- **Laptop tweaks are laptop-only** (`renderer/app.html:693` hint). Running `laptop-*` on a desktop can misconfigure cooling/power.
- `debloat` and `system-clean` **cannot be undone** by `Revert-All.ps1` — they delete packages/files.

## License

Catalog + scripts are your own notes for personal review. Viridian Free Utility itself remains property of Viridian Tweaks (`vtweaks.com`).

## Source verification

See `docs/SOURCE.md` for exact `strings` extraction + live engine JSON dumps and file hashes.
