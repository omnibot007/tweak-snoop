# FYI — Laptop: Lenovo 20SUS34900 / i7-10750H (6C/12T) / 32GB DDR4-3200 / Quadro T1000 — High-Benefit / Low-Downside

> **For:** YOUR laptop as scanned 2026-08-28. LAPTOP DETECTED (Battery 5B10W13959), High Performance already active (`8c5e7fda...`), `PowerThrottlingOff=1`, `MenuShowDelay=0`, `EnableTransparency=0`, `AllowTelemetry=0` stealth already applied. **i7-10750H is 14nm 45W, Quadro T1000 is NOT a gaming GPU** — thermal/power headroom matters. Don't treat this like a desktop.
> **Deep scan:** cross-checked 281 tweaks across `viridian` 15 + `hellzerg` 62 + `duck` 42 + `rytunex` 93 + `pc-tweaker` 41 + `pc-cleanup` 29. This FYI is deduplicated consensus `Safe` + verified low risk on THIS hardware.

## Why laptop = different

- Battery: you have 32GB RAM but 10750H will throttle at 95C. Killing all power saving (`laptop-battery-perf` CPU 100% on battery, `DisablePowerSaving` SvcHost) **drains battery 2x and thermal throttles anyway**. High perf on AC = good, max perf on battery = bad.
- Quadro T1000 (32.0.16.1656) is workstation, not gaming — HAGS/`DisableMemoryIntegrity`/`keep_kernel_in_ram` gains are tiny vs RTX, but VBS off is security loss. Skip.
- You already run Bitsum Highest Performance + 3x Ultimate Performance plans installed — don't stack another.

## APPLY THIS (12 tweaks, all Safe, instant revert)

**Copy-paste DryRun:** `tweak-snoop\viridian\scripts\Verify.ps1` then `pc-cleanup` CLI ` -WhatIf`

1. **StartupDelay 0** (`HKCU\...\Explorer\Serialize StartupDelayInMSec 0`) — Viridian/ Duck/ pc-tweaker/ pc-cleanup Safe. No downside.
2. **MenuShowDelay 0 + MouseHover 10** (`HKCU\Control Panel\Desktop MenuShowDelay 0` + `MouseHoverTime 10`) — already 0 on your machine ✅ keep it.
3. **Visuals off** (`TaskbarAnimations 0`, `EnableTransparency 0` ✅ already, `MinAnimate 0`, `UserPreferencesMask`) — frees Quadro compositing, already done ✅.
4. **File extensions on** (`HideFileExt 0`) — safety, zero perf cost.
5. **Keyboard 0/31** (`KeyboardDelay 0 / KeyboardSpeed 31`) — Safe, gaming/input.
6. **Network: Throttling `0xFFFFFFFF` + SystemResponsiveness `10` + Games GPU 8** (`HKLM\...Multimedia\SystemProfile`) — Viridian `network-basic` 7-9 + Duck `OptimizeMultimediaScheduler`. Biggest online micro-lag fix. Revert `10`/`20` default.
7. **Foreground priority `Win32PrioritySeparation 38` (0x26)** — Duck/pc-tweaker/Hellzerg `PrioritizeForeground`. Short+Variable+High boost, classic gaming tweak.
8. **Advertising/Bing/Tailored/AppLaunch/Feedback off** (5× HKCU `Safe`) — `AdvertisingInfo Enabled 0`, `BingSearchEnabled 0`, `TailoredExperiences 0`, `Start_TrackProgs 0`, `NumberOfSIUFInPeriod 0`. Pure privacy, no app break.
9. **GameDVR/Game Bar background off** (`GameDVR_Enabled 0`, `AllowGameDVR 0` HKLM) — only if you DON'T use Win+G recording. Saves Quadro encoder.
10. **Mouse accel off** (`MouseSpeed 0` Str) — linear aim. Safe, personal.
11. **Background apps off** (`GlobalUserDisabled 1`) — Moderate but fine on 32GB, stops Store polling. Re-enable if Mail/Calendar push needed.
12. **Keep stealth as is** — `AllowTelemetry 0` + 8 tasks Disabled already ✅ don't revert.

## SKIP ON THIS LAPTOP (or why)

- **laptop-battery-perf** (CPU 100% min/max on DC, USB/WiFi max on battery) — kills battery, thermal throttle on 10750H, no FPS gain unplugged. Your `laptop-basic` AC tweaks are OK, battery-perf not.
- **DisableUSBPowerSaving / DisablePowerSaving (Duck)** — same, drains.
- **Install Power Plans** — you already have 3 Ultimate + Bitsum. Adding Duck's plan duplicates, Task Manager 100% bug (#29).
- **ConfigureServices Risky (Duck 239 services)** / Hellzerg bulk — one Audio/BT/Spooler mismatch breaks laptop. Use `pc-cleanup` service list individually if needed, not bulk.
- **HAGS `HwSchMode 2`** / `keep_kernel_in_ram` / `games_gpu_priority 8` Pro — Quadro T1000 gains <2%, HAGS can add latency on workstation drivers. Test if you want but not Tier S.
- **VBS/Memory Integrity off** — 5-10% FPS on gaming rigs but removes driver exploit protection. Not for daily laptop.
- **IFEO / Firewall block telemetry** (pc-cleanup Advanced) — AV will flag `T1546.012`, breaks DiagTrack. Registry `AllowTelemetry 0` already enough.
- **Cleaners that delete `Minidump`/`WER`/`Chrome Login Data`** — Hellzerg `CleanHelper` deletes forever, Duck safe recycles. Don't run Hellzerg Clean on this machine with work data.

## How to apply (safe)

```powershell
# snapshot first (creates Restore Point + .reg)
.\viridian\scripts\Snapshot.ps1

# preview
.\pc-cleanup\src\main.ps1 -WhatIf  # or tweak-snoop\pc-cleanup
.\viridian\scripts\Verify.ps1

# apply those 12 via pc-cleanup Safe profile (covers 1-5,8,10) + manual regs for 6,7,9,11
.\pc-cleanup\src\main.ps1 -Profile Safe
# then for network + priority: use Duck or manual RegValue below
```

Manual regs for 6+7 (if not using Duck):

```reg
HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile NetworkThrottlingIndex=0xFFFFFFFF
HKLM\...SystemProfile SystemResponsiveness=10
HKLM\...SystemProfile\Tasks\Games GPU Priority=8
HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl Win32PrioritySeparation=38
```

Revert: `viridian\scripts\Revert-All.ps1 -DryRun $false` or `pc-cleanup -Undo All` or Duck `Revert` JSON.

## Already applied — don't re-do

- High Performance `8c5e...` ✅
- PowerThrottlingOff 1 ✅
- Stealth telemetry 0 + Consolidated Disabled ✅
- MenuShowDelay 0, Transparency 0 ✅
