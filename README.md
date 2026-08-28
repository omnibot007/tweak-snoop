# Tweak Snoop — Free Game Master Repo

> **Consolidated** from Viridian + Hellzerg deep snoops. Next snoops append as folders. One repo to review all free tweaks.
> **Public knowledge only** — every tweak extracted from public GitHub / locally installed free app strings, no cracking.

## Contents

| Folder | Source | What’s logged |
|--------|--------|---------------|
| `viridian/` | Viridian Free Utility v0.1.0 (`ViridianFreeEngine.exe` + `app.asar`) | 14 groups + hidden telemetry (10), live `action:steps` verified, `CATALOG.json` 23KB |
| `viridian-stealth/` | Viridian stealth subset | 8 tasks + 2 regs (AllowTelemetry/AdvertisingInfo) standalone pack, already applied to your laptop 2026-08-28 |
| `hellzerg/` | hellzerg/optimizer 18.3k ⭐ (deprecated, v16.7) `OptimizeHelper.cs` + 4 helpers | **62 Disable* tweaks** (60 revert pairs) + **deep_snoop**: CleanHelper (~40 browser/temp paths), UWPHelper (any AppX), StartupHelper (7 locations), HostsHelper (hosts file), Utilities_extra |

**Total cataloged:** 76+ tweak groups, 100+ distinct registry/service/task/paths, all with revert mapping where exists.

## Quick compare

|  | Viridian Free | Hellzerg |
|---|---|---|
| Privacy | 2 regs + 8 tasks | 50+ regs + 10+ tasks + services + hosts |
| Network | 10 netsh/reg | 1 throttling only |
| Debloat | 17 fixed AppX | any AppX via UWPHelper |
| Cleaner | 5 paths (temp/prefetch) | ~40 paths (browsers, WER, temp, recycle) |
| Revert | In-app buttons | Enable* mirrors (60/62) |

## Next snoops (one at a time)

- [ ] #2 `itsfatduck/optimizerDuck` (8.7k, GPL v3, `tweaks.json`)
- [ ] #3 `rayenghanmi/RyTuneX` (5.3k, WinUI3)
- [ ] #4 `AurelioAvila/pc-tweaker-app` (33 free tweaks)
- [ ] #5 `bradley1320/pc-cleanup` (29 tweaks, MIT)

Each will be added as `tweak-snoop/<name>/` with `CATALOG.json` + `README.md` + scripts.

## Usage

```powershell
# review
code tweak-snoop

# verify what’s applied
.\viridian-stealth\scripts\Verify.ps1
.\hellzerg\scripts\Apply-Group.ps1 -Tweak DisableStartMenuAds -DryRun

# snapshot before applying anything
.\viridian\scripts\Snapshot.ps1
```

## Source verification

See each folder’s `SOURCE.md` / `CATALOG.json:deep_snoop`.
