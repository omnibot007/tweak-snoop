# optimizerDuck (8.7k⭐) — Free Tweaks Snoop #2

> **Source:** `https://github.com/itsfatduck/optimizerDuck` — `Domain/Optimizations/Categories/*.cs` (7 categories, WPF .NET 10, GPL v3). No installer, single .exe, fully offline.
> **Snoop method:** cloned `optimizerDuck`, parsed every `class * : BaseOptimization` across 7 category files + `Domain/Customize` (Desktop/Gaming/Preferences). Count: **42 optimizations** (Verified — 28 Safe, 13 Moderate, 1 Risky). Plus 4 Customize categories (extra ~20 toggles). Every tweak has 4-step revert (Registry/Service/Task/Shell) with JSON in `%LocalAppData%\optimizerDuck\Revert\`.

## TL;DR

Duck is the **polite Viridian** — same goals (performance/privacy/GPU/power/bloat) but everything is **audited, reversible, risk-labeled**. Viridian hides tweaks in an exe + hard-deletes temps; Duck writes a revert file BEFORE it touches you, and its `Disk Cleanup` offers recycle-bin safety (Viridian deletes forever). Fully open-source GH Actions build, no telemetry, no Discord paywall.

## What it packs (42 optimizations)

**Performance (7):**
- `DisableBackgroundApps` (Moderate) — `HKCU\...BackgroundAccessApplications GlobalUserDisabled 1` + `BackgroundAppGlobalToggle 0`
- `ConsolidateServiceHosts` (Moderate) — `HKLM\SYSTEM\CurrentControlSet\Control SvcHostSplitThresholdInKB = <your RAM in KB>` (like Hellzerg's svc host split)
- `ProcessPriority` (Safe) — `HKLM\...\PriorityControl Win32PrioritySeparation 38` (Short, Variable, High foreground boost)
- `OptimizeMultimediaScheduler` (Safe) — `SystemProfile NoLazyMode 1`, `AlwaysOn 1`, `NetworkThrottlingIndex 0xFFFFFFFF`, `SystemResponsiveness 10` + `Tasks\Games Priority 2 / Scheduling High / SFIO High / GPU 8`
- `KeyboardLatencyOptimization` (Safe) — `HKCU\Control Panel\Keyboard KeyboardDelay 0 / KeyboardSpeed 31` (same as Viridian `input-response`)
- `DisableAccessibilityKeyboardHotkeys` (Moderate) — StickyKeys/ToggleKeys flags
- `LiftWebDavFileSizeLimit` (Safe) — `WebClient\Parameters FileSizeLimitInBytes 0xFFFFFFFF`

**PowerManagement (4):**
- `DisableHibernateAndFastStartup` (Moderate), `DisableUSBPowerSaving` (Safe), `InstallOptimizerDuckPowerPlan` (Safe — custom high-perf plan), `DisablePowerSaving` (Safe) — note Task Manager 100% CPU bug (#29) cosmetic only.

**SecurityAndPrivacy (13 — biggest):**
- `DisableTelemetry` (Moderate) — DiagTrack + AppCompat etc (like our stealth pack but more regs)
- `DisableErrorReporting`, `DisableAdvertisingAndSuggestions`, `DisableNewsAndInterests`, `HideMeetNowButton` (Win10), `DisableActivityHistory`, `DisableLocationAndSensors`, `DisableAutoLogger` (ETL), `DisableCortana` (Win10), `DisableCopilot` (Win11), `DisableContentDeliveryManager` (OEM reinstall block + `SilentInstalledApps`), `DisableFindMyDevice`, `DisableDeliveryOptimization`

**UserExperience (6):**
- `SpeedUpExplorerAndMenus` — `Explorer\Serialize StartupDelayInMSec 0` + `MenuShowDelay 0`
- `DisableVisualEffects` — `TaskbarAnimations 0 / ListviewShadow 0 / EnableTransparency 0 / EnableAeroPeek 0`
- `DisableStartMenuWebSearch` — `Explorer DisableSearchBoxSuggestions 1` (same as Hellzerg StartMenuAds)
- `DisableStartRecommended` (Win11), `DisableSettings365Ads` — `HKLM\...CloudContent DisableConsumerAccountStateContent 1`, `MaximizeUpdatePauseLimit` — `FlightSettingsMaxPauseDays 0xFFFFFFFF`

**BloatwareAndServices (2 but heavy):**
- `DisablePreinstalledApps` (Safe) — `ContentDeliveryManager PreInstalledAppsEnabled 0 / PreInstalledAppsEverEnabled 0 / OemPreInstalledAppsEnabled 0 / SilentInstalledAppsEnabled 0` (blocks OEM reinstall, not just uninstall like Viridian 17)
- `ConfigureServices` (**Risky** — 1 of only 1) — **239 services** tuned: `AJRouter Disabled`, `DiagTrack Disabled`, `WSearch Manual`, `Spooler Manual`, `Xbl* Manual`, `WUpdate Manual`, `DiagTrack Disabled`, etc. Full list in `BloatwareAndServices.cs:ConfigureServices` `servicesToChange`. This is the SysMain/DiagTrack heavy pack Hellzerg also does.

**Gpu (8 — vendor-specific, gated by condition):**
- AMD: `AmdDisableUlps` (EnableULPS 0), `AmdDisablePowerGating` (DisablePowerGating 1 + PP_GPUPowerDown 0), `AmdDisableVideoClockGating`, `AmdDisableAspm`
- NVIDIA: `NvidiaDisableDynamicPstate`, `NvidiaDisableAsyncPstates`
- Intel: `IntelDisableAsyncFlips`, `IntelDisableAdaptiveVsync`
- Each writes to `HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968...}\0000` (GPU class) — gated by `AmdGpuCondition`/`NvidiaGpuCondition` etc, so only runs on matching hardware.

**AI (2 — Win11 only):**
- `DisableRecall` (Moderate) — kills AI snapshot history, `DisableClickToDo` (Safe)

**Customize (extra, not counted in 42 but snoop-worthy):**
- Desktop: This PC/Recycle Bin/User Files/Network/Control Panel icons, shortcut arrow
- Preferences: Taskbar alignment/combine/widgets/TaskView/EndTask/clock seconds/dark mode/file extensions/hidden files/clipboard history/compact view/snap assist/Bing search etc
- Gaming: Game Mode/Game Bar/background recording/mouse accel/fullscreen optimizations/HAGS/DLSS indicator
- System: NumLock on boot, Verbose status, UTC hardware clock, SmartNameResolution, DevMode, LongPaths

**Revert:** 4 step types `RegistryRevertStep`/`ServiceRevertStep`/`ScheduledTaskRevertStep`/`ShellRevertStep` — JSON with thread-safe I/O, one-click per-tweak. Superior to Viridian's hard-delete + Hellzerg's Enable* (no saved state).

## Compare (free game)

|  | Viridian (14) | Hellzerg (62) | Duck (42+20) |
|---|---|---|---|
| Design | hidden exe strings | raw WinForms, deprecated | WPF .NET10, active, reflection-discovered |
| Risk labels | Safe only claim | none | **Safe/Moderate/Risky** per tweak |
| Revert | in-app button, 2 destructive | Enable* mirrors (no snapshot) | **JSON snapshot before apply** + one-click |
| Services | none | some (4) | **239 services** in one tweak (Risky) |
| GPU | none | edge telemetry only | **8 vendor GPU tweaks** |
| Cleaner | deletes forever | deletes forever (~40) | **Disk Cleanup to recycle safety** |

## Repo

```
tweak-snoop/
├── viridian/ (14)
├── hellzerg/ (62+ deep)
└── optimizerDuck/
    ├── CATALOG.json — 42 + Customize, risk breakdown 28/13/1
    └── README.md
```

## Next

One at a time — Duck done. Want me to snoop #3 `RyTuneX` or jump to `pc-tweaker-app`? Say `next` or name.
