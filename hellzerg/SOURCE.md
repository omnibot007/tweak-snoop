# Source

- Clone: `git clone https://github.com/hellzerg/optimizer.git C:\Users\LENOVO\hellzerg-optimizer`
- Parsed: `Optimizer/OptimizeHelper.cs` — 62 `internal static void Disable*()` + 63 `Enable*()` (60 pairs, 2 orphans: DisableTelemetryRunner, DisableClassicPhotoViewer). Verified via `Select-String` + Python re.
- Sample bodies kept in `CATALOG.json` `regs` count; full source is the proof.
- Deprecated notice: README.md states deprecated, replaced by `hellzerg/optimizerNXT` — this catalog is the frozen free game.
