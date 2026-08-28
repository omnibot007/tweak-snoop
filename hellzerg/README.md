# Hellzerg Optimizer (18.3k⭐) — Free Tweaks Catalog Snoop

> **Source:** `https://github.com/hellzerg/optimizer` — `Optimizer/OptimizeHelper.cs` — 81 C# files, .NET 4.8.1. **NOTE: Repo is deprecated** — replaced by `hellzerg/optimizerNXT`. This catalog is the last public free game (v16.7, 2024-08-18).
> **Snoop method:** cloned `hellzerg/optimizer`, parsed every `Disable*`/`Enable*` method pair in `OptimizeHelper.cs` (Verified — 62 Disable, 60 perfect revert pairs). Every registry path below is verbatim from source (see `CATALOG.json`).

This is **#1 of the free-tweak snoops** — doing one at a time as requested. Next up after this: `optimizerDuck`, `RyTuneX`, etc.

## TL;DR Hood Terms

Hellzerg's shit is the **OG bulk pack** — 62 switches, way more than Viridian's 14. It's not a pretty Electron app, it's a raw WinForms tool you run after fresh Windows. It flips mad registry/service/schtasks/hosts all at once. Fully free, MIT-ish, no Discord paywall. Every disable has a matching enable (except 2).

## What it packs (62 tweaks)

**Privacy / Telemetry (biggest chunk):**
- `DisableTelemetryServices` (18 regs) — kills `DiagTrack`, `dmwappushservice`, `DcpSvc`, etc (Start=4)
- `DisableTelemetryRunner` — blocks `CompatTelRunner.exe` / `DeviceCensus.exe`
- `DisableTelemetryTasks` — schtasks for Compatibility Appraiser / ProgramDataUpdater / Consolidator (same 3 Viridian did but more)
- `DisableOffice2016Telemetry`, `DisableNvidiaTelemetry` (kills `NvTelemetryContainer`, 3 NvTm tasks), `DisableChromeTelemetry` (6 Chrome policies), `DisableFirefoxTelemetry` (2 Firefox policies + 2 Mozilla tasks), `DisableVisualStudioTelemetry` (12 regs + service), `DisableEdgeTelemetry` (14 regs), `DisableCoPilotAI` (7 regs — kills Recall + Copilot)

**Windows Bloat / Services:**
- `DisableCortana` (11 regs), `DisableOneDrive` (tweak + uninstall), `DisableXboxLive` (5 regs), `DisableGameBar` (7 regs), `DisableGamingMode`, `DisableSuperfetch` (SysMain, 5 regs), `DisableSearch` (Windows Search), `DisablePrintService`, `DisableFaxService`, `DisableSensorServices`, `DisableHomeGroup`, `DisableMediaPlayerSharing`, `DisableCompatibilityAssistant`, `DisableErrorReporting` (5 regs), `DisableNTFSTimeStamp`, `DisableSystemRestore` (2 regs), `DisableDefender` (19 regs — needs Safe Mode `/disabledefender`)

**Ads / Annoyances:**
- `DisableStartMenuAds` (22 regs — the biggest single tweak, kills ContentDeliveryManager spam), `DisableSkypeAds`, `DisableNewsInterests` (Widgets news), `DisableMyPeople`, `DisableWindowsInk`, `DisableSpellingAndTypingFeatures` (6 regs), `DisableCloudClipboard` (4 regs)

**Network / Performance:**
- `DisableNetworkThrottling` (2 regs — same as Viridian's `NetworkThrottlingIndex`), `DisablePerformanceTweaks` (11 regs), `DisableTransparency`, `DisableLegacyVolumeSlider`, `DisableTaskbarColor`, `RemoveMenusDelay` (MenuShowDelay 0 + MouseHoverTime 0), `DisableStickyKeys` (6 regs), `DisableLongPaths` (enables 260 char fix), `DisableModernStandby` (PlatformAoAcOverride), `DisableUTCTime` (RealTimeIsUniversal)

**Win11 / Edge / Power-user:**
- `DisableWidgets`, `DisableChat` (Meet), `DisableShowMoreOptions` (restores classic context menu via CLSID), `DisableTPMCheck` (7 regs — bypass CPU/TPM/RAM for Win11 upgrade), `DisableSnapAssist`, `DisableStickers`, `DisableEdgeDiscoverBar`, `DisableVirtualizationBasedSecurity` (DeviceGuard), `DisableSmartScreen` (7 regs), `DisableAutomaticUpdates` (10 regs), `DisableStoreUpdates` (6 regs), `DisableInsiderService`, plus `EnableDarkTheme`/`LightTheme`, `EnableQuickAccessHistory`, `EnableFilesCompactMode`, etc.

## Revert

60/62 have perfect `Enable*` mirror — they either `SetValue` back or `TryDeleteRegistryValue` + `StartService`. 2 without revert: `DisableTelemetryRunner` (hosts/process block) and `DisableClassicPhotoViewer` (imports .reg). Everything else `scripts/Revert-*.ps1` restores.

## Dangerous ones (pay attention)

- `DisableDefender` / `DisableSmartScreen` — kill security, not reversible without reboot/Safe Mode, breaks protection. Marked Advanced in Viridian terms.
- `DisableSystemRestore` — kills restore points (we create one before applying for that reason).
- `DisableTPMCheck` / `DisableAutomaticUpdates` — can leave you on vulnerable build.

## How this compares to Viridian's free game

|  | Viridian Free (14) | Hellzerg (62) |
|---|---|---|
| Privacy kills | 2 regs + 8 tasks | 50+ regs + 10+ tasks + hosts + services |
| Network | 10 netsh/reg | 1 (throttling only) — Viridian deeper on TCP |
| Debloat | 17 Appx removals | Full UWP remover via `UWPHelper.cs` + `CleanHelper.cs` (not just 17) |
| Revert | In-app button per card | Every tweak has Enable* (no UI card, just toggle) |
| Safety | 2 destructive | 3 advanced (Defender/SmartScreen/Restore) |

## Deep Snoop #2 — Bonus Helpers (Logged)

Beyond `OptimizeHelper`'s 62, we logged 4 more modules:

**`CleanHelper.cs` — Browser & Junk Cleaner (DESTRUCTIVE)**
- `PreviewTemp()` → `%TEMP%`, `PreviewMinidumps()` → `%WINDIR%\Minidump`, `PreviewErrorReports()` → `%LOCALAPPDATA%\Microsoft\Windows\WER\*` + `%ProgramData%\Microsoft\Windows\WER\*`, `PreviewInternetExplorerCache()` → `INetCache\IE` / `WebCache.old`, `EmptyRecycleBin()` → `SHEmptyRecycleBin`, plus `PreviewChromeClean` / `FirefoxClean` / `EdgeClean` / `BraveClean` (each: Cache + Cookies + History + Session + Passwords/Login Data). All via `PreviewFolder()` → `Clean()` = `File.Delete`/`Directory.Delete` — no recycle bin fallback like pc-tweaker app. Count: **~40 paths**.

**`UWPHelper.cs` — Full AppX Killer**
- `GetUWPApps()` → `Get-AppxPackage | Select Name,InstallLocation` (or `Where NonRemovable=False`), `UninstallUWPApp(app)` → `Get-AppxPackage -AllUsers '{app}' | Remove-AppxPackage`, `RestoreAllUWPApps()` → `Get-AppxPackage -AllUsers | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register $_.InstallLocation\AppXManifest.xml}`. Not limited to 17 like Viridian — **any AppX**.

**`StartupHelper.cs` — Startup Manager**
- Scans **7 locations**: `HKLM\...\Run`, `HKLM\RunOnce`, `HKLM\Wow6432Node\...\Run`, `HKCU\...\Run`, `HKCU\RunOnce`, `%ProgramData%\...\Startup` (*.exe/*.bat/*.cmd + *.lnk), `%APPDATA%\...\Startup`. Toggles via registry delete / file delete.

**`HostsHelper.cs` + `Utilities.cs` / `SilentOps.cs` — Extra**
- `HostsHelper` → `%SystemRoot%\System32\drivers\etc\hosts` with `ReadHosts`/`SaveHosts` (sanitize double spaces), `AddEntry`/`RemoveEntry`/`RemoveEntryFromTemplate`, `RestoreDefaultHosts` (from `Resources/hosts`), `ReadOnly` toggle.
- `Utilities_extra` → `DisableSvcHostProcessSplitting` (RAM-based), `EnableSvcHostProcessSplitting`, `TaskManager`/`CommandPrompt`/`ControlPanel`/`FolderOptions`/`RunDialog`/`ContextMenu`/`Firewall`/`RegistryEditor` toggles, `ProcessCleaner`, `SetDNSForAllNICs` (CleanBrowsing DNS), RegistryFixes.

These are now in `CATALOG.json:deep_snoop` — see `CATALOG.json:320+` for exact paths/commands.

## Consolidated Repo Merge

As requested, we're merging all snoops into **one master repo**: `tweak-snoop` — Viridian (14) + Hellzerg deep (62+4 modules) + next snoops will append as folders. This keeps one place to review, not 5 repos.

## Repo layout

```
hellzerg-catalog/  (now merged → tweak-snoop/hellzerg/)
├── README.md
├── CATALOG.json       — 62 tweaks + deep_snoop (Clean/UWP/Startup/Hosts)
├── SOURCE.md          — verification steps
└── scripts/
    ├── Apply-Group.ps1  — run one tweak (DryRun default)
    ├── Revert-Group.ps1
    ├── Revert-All.ps1   — all 60 reversible
    └── Verify.ps1
```

## Next

Deep snoop #2 logged. Moving to **#2 `optimizerDuck` (8.7k, GPL v3)** snoop next as planned.
