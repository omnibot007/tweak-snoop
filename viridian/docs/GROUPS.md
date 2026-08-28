# Per-group deep dive

All commands are verbatim from `ViridianFreeEngine.exe` (see `SOURCE.md`). Forward = what Apply does; Revert = what the in-app Revert button sends.

## `network-basic`
- **Why:** reset stack, then apply safe throughput tweaks.
- **Forward:** `netsh winsock reset` → `netsh int ip reset` → `ipconfig /flushdns` → `rss=enabled`, `ecncapability=disabled`, `timestamps=disabled`, `DefaultTTL=64`, `Tcp1323Opts=1` (window scaling), `NetworkThrottlingIndex=0xFFFFFFFF`, `heuristics disabled`.
- **Revert:** `rss=default`, `ecn=default`, `timestamps=default`, `delete DefaultTTL/Tcp1323Opts`, `NetworkThrottlingIndex=10`, `heuristics default`. Note: `winsock reset`/`int ip reset` are not undone — they are idempotent.

## `debloat` ⚠️ DESTRUCTIVE
- `Remove-AppxPackage` for 17 packages. No backup/rollback in engine. Reinstall via Store or `Add-AppxPackage -Register` from `C:\Program Files\WindowsApps`.

## `visual-tweaks` / `disable-animations`
Overlap: both flip `EnableTransparency` + `TaskbarAnimations`. Visual adds Task View hide + Explorer ads off + dark theme + file extensions show. Disable-animations adds Aero Shake off + MinAnimate + MenuShowDelay. Reverts are exact inverses (0↔1, 0↔400).

## `power-plan`
- `HibernateEnabled 0/1`, `PowerThrottlingOff 1/0`, `HiberbootEnabled 0/1`, `powercfg /setactive High performance ↔ Balanced`. Requires admin HKLM.

## `system-clean` ⚠️ DESTRUCTIVE
- Deletes `%TEMP%`, `C:\Windows\Temp`, `C:\Windows\Prefetch`, `C:\Windows\SoftwareDistribution\Download`, blanks `AutoLogger-Diagtrack-Listener.etl`. No backup.

## `game-mode`, `mouse-fix`, `input-response`, `startup-opt`, `flush-dns`
- Simple HKCU reg flips or ipconfig. Fully revertible.

## `laptop-basic`, `laptop-battery-perf`, `laptop-display`
- All `powercfg /setacvalueindex`/`setdcvalueindex` on `SCHEME_CURRENT`. GUIDs: `54533251-...-94d3...` cooling policy, `2a737...-48e6...` USB suspend, `19cbb...-12bb...` WiFi perf, `501a...-ee12...` PCIe, `54533...-893dee...` CPU min, `bc503...` CPU max, `4f971...-5ca8...` lid action, `7516...-fbd9...` adaptive brightness, plus `monitor-timeout-ac`. Reverts restore balanced defaults.

## `telemetry` (bundled)
- 8 tasks `schtasks /change /disable` ↔ `/enable`, plus `AllowTelemetry 0↔1`, `AdvertisingInfo 0↔1`.

## `procreduce`
- `action:procreduce` streams step labels, trims working set. No registry write.
