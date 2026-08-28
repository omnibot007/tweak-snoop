# RyTuneX (5.3k⭐) — Free Tweaks Snoop #3

> **Source:** `https://github.com/rayenghanmi/RyTuneX` — WinUI3 .NET 10, AGPL v3, Store + winget, 73 C# files. **Active** (last 2026).
> **Snoop method:** cloned `RyTuneX`, parsed `Helpers/OptimizeSystemHelper.cs` (93 Disable/Enable bases, 186 methods) + `Views/*.xaml` ToggleSwitch `Tag` + `Helpers/OptimizationOptions`. Verified `OptimizeSystemPage.xaml` 37 toggles + `PrivacyPage.xaml` 32 toggles = **98 unique XAML tags**, 101 including Features/Debloat filters. Full 93 bases in `CATALOG.json`.

## TL;DR

RyTuneX is the **Store-friendly Viridian** — WinUI3, Microsoft Store signed, no SmartScreen. Unlike Hellzerg's raw registry dumps, RyTuneX queues every toggle through `IntelligentOptimizationEngine.cs` → `ExecuteToggleActionAsync` with `HKLM\RyTuneX` state tracking + rollback `ItemRollbackService`. 93 toggles, all `Disable*`/`Enable*` pairs, queued serially (`_toggleQueue`).

## What it packs (93 bases, 98 XAML tags)

**OptimizeSystemPage (37 — performance/services):**
- `MenuShowDelay` / `MouseHoverTime` (0), `KeyboardLatency`, `MouseAcceleration`, `BackgroundApps`, `SystemProfile` (Multimedia), `PowerThrottling`, `UsbPowerSaving`, `SysMain` (SysMain), `SystemRestore`, `SmartScreen`, `RemoteRegistry`, `RemoteAssistance`, `WindowShake`, `LinkResolve`, `ServiceTimeouts`/`TaskTimeouts`, `LowDiskSpaceChecks`, `Cortana`, `Search`, `GamingMode`/`FullscreenOptimizations`/`GpuDriverTweaks`, `StoreUpdates`, `Drivers` (ExcludeWUDrivers), `PrioritizeForegroundApplications` (Win32PrioritySeparation), `OptimizeNTFS`, `LegacyBootMenu`, `ServiceHostSplitting` (SvcHost threshold), `WPBT` (platform binary table), `CopyMoveContextMenu`, `AutoComplete`, `CrashDump`, `FileExtensionsAndHiddenFiles`, `SystemProfile`, `ClassicContextMenu` (`{86ca1aa0...}`), `TaskbarToLeft`, `VBS`, `WindowsTransparency`/`DarkMode`/`VerboseLogon`/`Stickers`/`Chat`/`Widgets`/`SnapAssist` etc.

**PrivacyPage (32 — telemetry/ads):**
- `TelemetryServices` (DiagTrack etc), `AdvertisingID`, `BluetoothAdvertising`, `NewsAndInterests`, `SpotlightFeatures`, `TailoredExperiences`, `CloudOptimizedContent`, `FeedbackNotifications`, `Edge/Chrome/Firefox/Nvidia/VisualStudio Telemetry`, `ActivityFeed`/`ActivityUploads`, `Cdp`, `DiagnosticsToast`, `OnlineSpeechPrivacy`, `LocationFeatures`, `Biometrics`, `AutomaticRestartSignOn`, `HandwritingDataSharing`/`TextInputDataCollection`/`InputPersonalization`, `SafeSearchMode`, `ClipboardSync`/`MessageSync`/`SettingSync`, `VoiceActivation`, `FindMyDevice`, `SMBv1`/`SMBv2` (LanmanServer)

**Other pages (not just toggles):**
- **DebloatSystemPage** — `GetWin32Apps`/`GetUWPApps` via WinRT `PackageManager` + registry `Uninstall` roots (HKLM/HKCU x64/x32), `UninstallUwpAppAsync` (`RemovePackageAsync` + `Remove-AppxProvisionedPackage`), `UninstallWin32AppAsync` (QuietUninstallString + `RemoveEdge.ps1`)
- **StartupPage** (`StartupHelper.cs`) — 7 locations like Hellzerg (HKLM/HKCU Run/RunOnce + Startup folders)
- **PackagesPage** — winget packages (`WingetPackage.cs`)
- **ServicesPage** — `Services\Services` helpers
- **NetworkPage** — `NetworkAdapter.cs` DNS + `PingerHelper`
- **HostsHelper** — `etc\hosts` editor
- **FeaturesPage** — Windows optional features toggles
- **PoliciesPage** — `PolicyHelper.cs` + `IntelligentOptimizationEngine` queue

**Rollback:**
- `ItemRollbackService.cs` + `Services\ItemRollbackService` + registry `HKLM\SOFTWARE\RyTuneX` (every toggle `IsOn ? 1 : 0`) + `RevertAllChanges()` loops saved `1`s and fakes `ToggleSwitch IsOn=false`. Safer than Viridian.

## Compare

|  | Viridian (14) | Hellzerg (62) | Duck (42) | RyTuneX (93) |
|---|---|---|---|---|
| Toggles | 14 groups | 62 Disable | 42 optimizations | **93 bases / 98 XAML** |
| UI | Electron | WinForms deprecated | WPF | **WinUI3 Store** |
| Revert | button per card (2 destructive) | Enable* mirror | JSON snapshot | **registry HKLM\RyTuneX queue + rollback** |
| Debloat | 17 AppX | any AppX | block reinstall + 239 services | **WinRT PackageManager + Win32 UninstallString** |
| Network | 10 netsh | 1 | none | NetworkAdapter + DNS |
| Risk | Safe claim | none | Safe/Moderate/Risky | no label, but queued + rollback |

## Repo

```
tweak-snoop/
├── viridian/ (14)
├── hellzerg/ (62+ deep)
├── optimizerDuck/ (42)
└── rytunex/  (93 bases / 98 tags)
    ├── CATALOG.json — bases + xaml_tags + optimize/privacy splits
    └── README.md
```

## Next

RyTuneX #3 done. Next #4 `AurelioAvila/pc-tweaker-app` (33 free) or #5 `bradley1320/pc-cleanup` (29 tweaks, `config/tweaks.json`). Say `next`.
