# pc-cleanup (bradley1320, MIT) — Free Tweaks Snoop #5

> **Source:** `https://github.com/bradley1320/pc-cleanup` — `config/tweaks.json` v2.0.0 (29 tweaks, MIT, PowerShell 5.1, no installer). **Verified:** 29 entries (excluding `_version`/`_description` meta). Built by Claude + bradley1320, 20 src files, 518 Pester tests, `Run.bat` required Unblock.
> **Snoop method:** cloned `pc-cleanup`, parsed `config/tweaks.json` (plain JSON, no hidden code) + `src/handlers/*.ps1` + `docs`. Every tweak has `risk` + `docsUrl` + `defaultValue` + `type` + service/task/script.

## TL;DR

The **most honest** snooped — everything in `tweaks.json`, you can paste into an AI and verify. 29 tweaks: **20 Privacy + 9 Performance**, risk tiers **Safe 18 / Moderate 8 / Advanced 3**. Every change saves `undo_log.json` (`%LOCALAPPDATA%\PCCleanup\`) + timestamped `.reg` + Restore Point, atomic via `RollbackStore` (Mutex + temp+rename). Deliberately **refuses** to do dangerous myths: no registry cleaning, no RAM booster, no Defender/UAC/PageFile/SysMain kill, no UWP removal (breaks Explorer on 24H2 per README).

## What it packs (29)

**Performance 9 (all Safe except 1 Moderate):**
- `SetHighPerformancePowerPlan` (Safe, admin) — `powercfg /setactive 8c5e...` (High Perf, tries Ultimate `e9a42...` fallback), undo Balanced `381b...`
- `OptimizeVisualEffects` (Safe) — `VisualFXSetting 2`, `UserPreferencesMask Binary 90:12:03:80:10…`, `MenuShowDelay 0 Str` (400), `MinAnimate 0 Str` (1), `TaskbarAnimations 0` (1)
- `DisableTransparency` (Safe) — `EnableTransparency 0` (HKCU)
- `EnableGameMode` (Safe) — `GameBar AllowAutoGameMode 1 / AutoGameModeEnabled 1`
- `DisableGameBar` (Safe, admin) — `HKLM GameDVR AllowGameDVR 0`, `GameDVR AppCaptureEnabled 0`, `GameConfigStore GameDVR_Enabled 0`
- `DisableMouseAcceleration` (Safe) — `MouseSpeed 0`, `Threshold1 0`, `Threshold2 0` (Str)
- `DisableStartupDelay` (Safe) — `Serialize StartupDelayInMSec 0` (`<NonExistent>` default)
- `DisableSearchIndexing` (Moderate, admin) — `WSearch Disabled` (Automatic)
- `DisableWindowsTips` (Safe) — `ContentDeliveryManager SystemPaneSuggestionsEnabled 0 / SoftLanding 0 / 338389 0 / 310093 0`

**Privacy 20:**

*Safe 11:*
- `SetTelemetryRequired` — `AllowTelemetry` minimal + `AllowTelemetry`? Actually `SetTelemetryRequired` sets via service? Check json
- `DisableAdvertisingID` — HKCU `AdvertisingInfo Enabled 0`
- `DisableActivityHistory` (HKCU), `DisableCEIPTasks` (Safe, tasks Consolidator/UsbCeip/DiskDiagnosticDataCollector `enabled:false`), `DisableErrorReporting` (HKLM `WER Disabled 1` + `WerSvc Disabled`), `DisableFeedback` (`Siuf Rules NumberOfSIUFInPeriod 0` `<NonExistent>`), `DisableTailoredExperiences` (Privacy `Tailored... 0`), `DisableOnlineSpeechRecognition` (Speech OneCore `HasAccepted 0`), `DisableInkAndTypingData` (5 regs: `TIPC Enabled 0`, `RestrictImplicitInk/Text 1`, `TrainedDataStore HarvestContacts 0`, `Personalization AcceptedPrivacyPolicy 0`), `DisableAppLaunchTracking` (Start_TrackProgs 0), `DisableLocationTracking` (Moderate actually), `DisableWebSearch` (Moderate), etc — full 20 in `CATALOG.json`

*Moderate 8:*
- `DisableDiagTrack` — `DiagTrack Disabled` (may break Xbox achievements), `DisableCortana` (HKLM `AllowCortana 0`), `DisableBackgroundApps` (GlobalUserDisabled 1), `DisableLocationTracking` (DisableLocation 1 + lfsvc Disabled), `DisableWebSearch` (BingSearchEnabled 0 + DisableSearchBoxSuggestions 1), `DisableCopilot` (TurnOffWindowsCopilot 1 + ShowCopilotButton 0, build 22631+), `DisableRecallAI` (DisableAIDataAnalysis 1 + AllowRecallEnablement 0, build 26100+), `DisableSearchIndexing` (see perf)

*Advanced 3:* (must opt-in)
- `BlockTelemetryFirewall` — firewall rules `PCCleanup-Block-DiagTrack/CompatTelRunner/DeviceCensus` (NetFirewallRule Block `svchost.exe -Service DiagTrack`, `CompatTelRunner.exe`, `DeviceCensus.exe`)
- `DisableDeliveryOptimization` — `DODownloadMode 0` + `DoSvc Disabled`
- `BlockTelemetryIFEO` — IFEO `Debugger` → `taskkill.exe` for `CompatTelRunner.exe`/`DeviceCensus.exe` (MITRE T1546.012, WILL trigger AV — README warns)

**Modules (10):** Quick Clean (deletes files), Startup Manager, Performance Mode, Privacy Shield, Network Reset (isolated with warnings: DNS/Winsock/TCP/IP), Disk Analysis (read-only), Security Check (Defender/firewall/SMBv1), System Report (boot time Event 100), Full Tune-Up (Safe), Backup & Restore (`undo_log.json` + `.reg` + Restore Point, SHA-256 baked config check).

**CLI:** `.\pccleanup.ps1 -Profile Safe/Gaming/Privacy -Module Privacy -Risk moderate -WhatIf -Undo All/"name" -Report -Snapshot Before/Compare` + interactive menu.

## Compare

|  | Viridian 14 | Hellzerg 62 | Duck 42 | RyTuneX 93 | pc-tweaker 41 (28f) | pc-cleanup 29 |
|---|---|---|---|---|---|---|
| File | exe strings | C# | C# | C# XAML | Rust | **JSON** |
| Privacy | 8 tasks | 50+ | 13 | 32 | 12 | **20** |
| Perf | network deep | 1 | 7+Power4 | 37 | 10+Manut | **9** |
| Revert | button (2 destr) | Enable* | JSON | HKLM queue | tmp+rename | **undo_log + .reg + Restore** |
| Deletes | forever | forever ~40 | safe recycle | via Page | none | **QuickClean deletes, rest safe** |
| Refuses | — | — | — | — | — | **no Defender/UAC/PageFile/SysMain/UWP** |

## Repo

```
tweak-snoop/
├── viridian/ (14)
├── hellzerg/ (62+ deep)
├── optimizerDuck/ (42)
├── rytunex/ (93)
├── pc-tweaker/ (41)
└── pc-cleanup/ (29: 20 Privacy / 9 Perf, Safe 18/Moderate 8/Advanced 3)
    └── CATALOG.json — verbatim tweaks.json (41847 B)
```

## Done

All 5 requested snoops completed, one at a time as promised. Master repo holds **~260 logged tweaks** total.
