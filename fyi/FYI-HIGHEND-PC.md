# FYI — High-End PC (Desktop / Workstation / Gaming Rig) — Max Benefit / Low Downside

> **For:** Desktop with discrete gaming GPU (RTX 40/30, RX 7000), 32GB+ RAM, good cooling, no battery. Assumes you can afford power/thermal headroom. For YOUR laptop see `FYI-LAPTOP-10750H-QuadroT1000.md`.
> **Deep scan:** same 281 tweaks cross-check, but high-end can enable Pro/Risky tweaks that laptop must skip. Risk tiers from Duck `Safe/Moderate/Risky` + pc-cleanup `Safe/Moderate/Advanced` + pc-tweaker `requires_pro`.

## Philosophy

High-end = optimize for **lowest latency + max sustained clocks**, not battery. You still keep Defender/SmartScreen/UAC/PageFile/SysMain on (all 5 repos refuse to kill them for good reason). You add HAGS, kernel residency, power plans, service trimming more aggressively.

## TIER S — Apply first (same 12 as laptop, plus power)

1. **StartupDelay 0, MenuShowDelay 0, Visuals off, FileExt on, Keyboard 0/31** — identical to laptop. Universal Safe.
2. **NetworkThrottling `0xFFFFFFFF` + SystemResponsiveness `0-10` + Games GPU 8 + SFIO High** — Duck `OptimizeMultimediaScheduler` full 8 regs. On desktop set `SystemResponsiveness 0` (pc-tweaker Pro value) not 10 — zeros background share, pure gaming rig.
3. **Win32PrioritySeparation 38** — same.
4. **Advertising/Bing/Tailored/AppTrack/Feedback off** — same 5.

## TIER A — High-end unlocks (Moderate/Risky but worth it HERE)

5. **Power: Ultimate Performance + USB selective suspend off + PowerSaving off**
   - `powercfg /setactive e9a42b02...` (Ultimate) or Bitsum Highest, `USB SelectiveSuspend 0` (`HKLM\...usb\EnableSelectiveSuspend 0` via Duck `DisableUSBPowerSaving`), `DisablePowerSaving` SvcHost. On desktop no battery, so max clocks sustained. On laptop this was SKIP.
   - Verify no `PowerThrottlingOff 1` conflict — both do same, keep one.

6. **Keep kernel/drivers in RAM** (`DisablePagingExecutive 1` HKLM) — pc-tweaker Pro, Viridian-adjacent. Needs 16GB+ (you have it). Prevents kernel page-out stutter. Skip if <16GB.

7. **HAGS on** (`HwSchMode 2` HKLM GraphicsDrivers) — pc-tweaker Pro. 5-8% input latency cut on RTX 30/40 with recent drivers. If you see artifacting or Quadro/workstation artifacts, revert (RyTuneX-style).

8. **Games GPU Priority 8 + Fullscreen optimizations off** (`GameDVR_DXGIHonorFSE 1`) — pc-tweaker `games_gpu_priority` + `disable_fullscreen_optimizations_global`. Desktop exclusive fullscreen still wins for older DX.

9. **SvcHost splitting by RAM** (Duck `ConsolidateServiceHosts` SvcHostSplitThresholdInKB = RAM KB, Hellzerg `ServiceHostSplitting` similar) — reduces service host overhead on 32GB+ rigs. Moderate, test.

10. **Service tuning (curated, not bulk)**
    - Instead of Duck's `ConfigureServices` Risky bulk (239 services), use **pc-cleanup** selective: `DiagTrack Disabled` (if no Xbox), `WSearch Manual` if you don't use Outlook search, `SysMain` leave Automatic (don't disable — SSD myth). Don't bulk-apply Duck 239.
    - Hellzerg `DisableSuperfetch` is SysMain same — skip.

11. **Delivery Optimization full off** (`DODownloadMode 0` + `DoSvc Disabled`) — pc-tweaker Pro / pc-cleanup Advanced. Stops P2P upload eating gaming bandwidth. Safe on desktop with fast internet.

12. **Recall / Copilot / Cortana / ActivityHistory off** — Duck `DisableRecall`/`Copilot` + pc-cleanup `DisableRecallAI`/`Copilot` (build 26100/22631 gated). No downside if you don't use AI features.

13. **GPU vendor tweaks (gated)**
    - AMD: `EnableULPS 0`, `DisablePowerGating 1`, `DisableAspm` etc (Duck Gpu 8). Only on AMD, test thermals.
    - NVIDIA: `DisableDynamicPstate` etc (Duck). On high-end NVIDIA can stabilize clocks, at cost of idle power (fine on desktop).
    - Intel: `DisableAsyncFlips`.

14. **AutoLogger ETL throttle** (`DisableAutoLogger` Moderate) — Duck/Hellzerg `AutoLogger-Diagtrack-Listener.etl` blank. Reduces disk I/O, safe.

## SKIP EVEN ON HIGH-END (low benefit or security)

- **Defender / SmartScreen off** — 19 regs, Hellzerg `DisableDefender` needs Safe Mode. No FPS worth it vs getting pwned.
- **TPM bypass / DisableAutomaticUpdates / Update pauses** — leaves unpatched.
- **IFEO Debugger `taskkill` + Firewall block** (pc-cleanup Advanced) — AV flag `T1546.012`, redundant vs registry 0.
- **SysMain/Superfetch off** — myth on SSD, increases page faults per pc-cleanup's own `What This Tool Does NOT Do`.
- **PageFile off / UAC off / Registry cleaning / RAM booster** — all 5 repos explicitly refuse — same.
- **AppX bulk remove** — Hellzerg `UWPHelper` any AppX / Viridian 17 — breaks 24H2 Explorer per pc-cleanup README. Use `DisablePreinstalledApps` (block reinstall) not `Remove-AppxPackage` bulk.
- **LongPaths 1, UTC clock, VBS off** — niche. VBS `disable_memory_integrity` is 5-10% FPS but removes HVCI — only for dedicated bench rig, not daily high-end.

## How to apply (high-end)

```powershell
# snapshot
.\viridian\scripts\Snapshot.ps1

# Safe base via pc-cleanup
.\pc-cleanup\src\main.ps1 -Profile Safe        # 18 Safe
# then add Moderate curated
.\pc-cleanup\src\main.ps1 -Module Privacy -Risk moderate  # adds DiagTrack/Cortana etc
# GPU/power via Duck
# optimizerDuck.exe → select PowerManagement + Performance + GPU(vendor) → Apply
# RyTuneX Store → OptimizeSystemPage 93 toggles → queue
```

Or via Tauri: `pc-tweaker` enable HAGS + priority + kernel in RAM (Pro) behind single UAC snapshot (`rollback_store.json` atomic).

## Revert

- pc-cleanup ` -Undo All` restores original values (not guessed defaults) + restores `previous_guid` for power plans.
- Duck `Revert` JSON per tweak (`%LocalAppData%\optimizerDuck\Revert\`).
- Hellzerg `Enable*` mirrors, RyTuneX `HKLM\RyTuneX` replay, Viridian `Revert-All.ps1`.

## Sum: Laptop vs High-End diff

| Laptop (your 10750H/Quadro) | High-End adds |
|---|---|
| High Performance only, keep power saving on battery | Ultimate Performance + USB suspend off + kernel in RAM + HAGS + GPU vendor + Svchost split + curated services |

Keep both FYIs in `tweak-snoop\fyi\`.
