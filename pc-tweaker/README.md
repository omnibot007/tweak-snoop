# pc-tweaker-app (AurelioAvila, 13⭐) — Free Tweaks Snoop #4

> **Source:** `https://github.com/AurelioAvila/pc-tweaker-app` — `src-tauri/src/tweaks.rs` (Tauri + Rust + React, 41 tweaks: 28 free / 13 Pro), `rollback.rs` snapshot store, `src/categories.tsx`. Site: `pctweaker.app` (winget `AurelioAvila.PCTweaker`).
> **Snoop method:** cloned `pc-tweaker-app`, parsed `tweaks.rs:all_tweaks()` — 41 `RegistryTweak` entries (Verified — Hive/Key/Value/on_value + requires_admin/pro). Every tweak snapshots original value first (`registry -> rollback_store.json`), one-click Scan + Fix all behind single UAC.

## TL;DR

The **cleanest free game** — only 41 tweaks but every one is documented in plain Rust, snapshotted atomically (`tmp + rename`, mutex, thread-safe), and cataloged as `RegistryTweak` struct. 28 free forever, 13 Pro (€9.99/mo, €59/yr). Pro = advanced: CPU priority, telemetry, HAGS, paging, VBS, etc. Free already covers most Viridian/Hellzerg/Duck overlap.

## Free vs Pro

- **Free 28:** UI (dark mode, hidden files, file extensions, taskbar left/chat/widgets/search, transparency, folder loading), Performance (GameDVR off, startup delay 0, menu 0, window animations off, drag outline, mouse hover 10), Privacy (advertising ID, Bing search, Start suggestions, tailored experiences, app launch tracking, feedback, location, Cortana, Copilot, suggested apps silent install), Gaming (fullscreen optimizations global, mouse accel off, sticky keys popup off)
- **Pro 13:** `priority_separation` (38), `disable_telemetry_tasks` (AllowTelemetry 0), `hardware_gpu_scheduling` (HwSchMode 2), `system_responsiveness` (0), `keep_kernel_in_ram` (DisablePagingExecutive 1), `auto_end_frozen_tasks` (AutoEndTasks 1), `instant_folder_loading` (FolderType NotSpecified), `disable_power_throttling` (PowerThrottlingOff 1), `games_gpu_priority` (GPU Priority 8), `disable_delivery_optimization` (DODownloadMode 0), `disable_recall` (DisableAIDataAnalysis 1), `disable_memory_integrity` (VBS Enabled 0) — biggest FPS gain but security trade.

## What it packs (41 — by category)

**Ui 9:** `dark_mode` (AppsUseLightTheme 0 HKCU), `show_hidden_files` (Hidden 1), `taskbar_align_left` (TaskbarAl 0), `hide_taskbar_chat` (TaskbarMn 0), `hide_taskbar_search` (SearchboxTaskbarMode 0), `instant_folder_loading` (Pro), `disable_start_suggestions` (ContentDeliveryManager 0), `show_file_extensions` (HideFileExt 0), `hide_taskbar_widgets` (TaskbarDa 0), `disable_transparency` (EnableTransparency 0)

**Performance 10:** `disable_game_dvr` (GameDVR_Enabled 0), `disable_startup_delay` (StartupDelayInMSec 0), `menu_show_delay` (MenuShowDelay 0 Str), `disable_window_animations` (MinAnimate 0 Str), `disable_drag_full_windows` (DragFullWindows 0), `mouse_hover_delay` (MouseHoverTime 10 Str), `disable_background_apps` (GlobalUserDisabled 1 Pro), `priority_separation` (Pro 38), `keep_kernel_in_ram` (Pro), `disable_power_throttling` (Pro PowerThrottlingOff 1)

**Privacy 12:** `disable_telemetry_tasks` (Pro AllowTelemetry 0 HKLM), `reset_advertising_id` (Enabled 0 HKCU), `disable_location_tracking` (DisableLocation 1 HKLM), `disable_bing_search` (BingSearchEnabled 0), `disable_start_suggestions` (SubscribedContent-338388 0), `disable_tailored_experiences` (Tailored… 0), `disable_app_launch_tracking` (Start_TrackProgs 0), `disable_feedback_requests` (NumberOfSIUFInPeriod 0), `disable_cortana` (AllowCortana 0 HKLM), `disable_copilot` (TurnOffWindowsCopilot 1), `disable_suggested_apps` (SilentInstalledAppsEnabled 0), `disable_recall` (Pro)

**Gaming 8:** `hardware_gpu_scheduling` (Pro HwSchMode 2 HKLM), `network_throttling_index` (0xffffffff HKLM — same as Viridian), `system_responsiveness` (Pro 0), `games_gpu_priority` (Pro 8), `disable_fullscreen_optimizations_global` (GameDVR_DXGIHonorFSE 1), `disable_mouse_acceleration` (MouseSpeed 0 Str), `disable_sticky_keys_prompt` (Flags 506 Str), `disable_memory_integrity` (Pro VBS 0 — biggest FPS but security off)

**Manutenzione 2:** `auto_end_frozen_tasks` (Pro AutoEndTasks 1), `disable_delivery_optimization` (Pro DODownloadMode 0 — stop uploading updates to strangers)

**Rollback:** `rollback.rs` — `RegValue::Dword/Str` + `RegistrySnapshot` (hive/path/name/original Option), `RollbackStore` (`rollback_store.json` in app_data, `Mutex<()>` + `AtomicU64` temp `json.<pid>.<seq>.tmp` + `rename` atomic), 6 SnapshotEntry kinds (Registry/PowerScheme/DNS/PowerSettingIndex/Service/RegistryKeyCreated/TcpCongestion/Composite). Fixes concurrent Game Sessions + UI race.

## Compare

|  | Viridian 14 | Hellzerg 62 | Duck 42 | RyTuneX 93 | pc-tweaker 41 |
|---|---|---|---|---|---|
| Free | all | all | all | all | **28/41** |
| Pro | upsell site | none | none | none | 13 (Stripe) |
| Stack | Electron/C++ | WinForms | WPF | WinUI3 | **Tauri Rust** |
| Rollback | button (2 destructive) | Enable* | JSON snapshot | HKLM queue | **tmp+rename atomic, mutex** |
| Unique | network deep | bulk privacy | 239 services/GPU | WinRT debloat | **HAGS, VBS, kernel in RAM, StartupDelay** |

## Repo

```
tweak-snoop/
├── viridian/ (14)
├── hellzerg/ (62+ deep)
├── optimizerDuck/ (42)
├── rytunex/ (93)
└── pc-tweaker/ (41: 28 free/13 Pro)
    ├── CATALOG.json — 41 RegistryTweak with hive/key/value/on_val/admin/pro
    └── README.md
```

## Next

One at a time — #4 done. Last of this batch: #5 `bradley1320/pc-cleanup` (29 tweaks, 10 modules, `config/tweaks.json` + CLI `-WhatIf`/`-Undo`). Say `next` to snoop it.
