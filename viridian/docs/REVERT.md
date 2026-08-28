# How to revert

## 1. In-app (preferred for safe groups)
Every card except System Clean has a `Revert` button (`renderer/app.js: runGroupButton mode=revert`). It sends `action:revert` with same group to the engine. Engine runs the inverse commands listed in `CATALOG.json`.

Order doesn't matter, but for power do `laptop-*` before `power-plan`.

## 2. Scripts in this repo (offline, no Viridian needed)
```powershell
# Preview
.\scripts\Revert-Group.ps1 -Group network-basic -DryRun
# Run one
.\scripts\Revert-Group.ps1 -Group power-plan
# All safe groups
.\scripts\Revert-All.ps1 -DryRun
.\scripts\Revert-All.ps1
```
Scripts are idempotent; they echo `DryRun` without writing. Must run elevated for HKLM/power/schtasks.

## 3. System Restore (if something broke hard)
Run `Snapshot.ps1` **before** applying tweaks to create a Restore Point + reg/power/tasks exports. Restore via `rstrui.exe` or:
```powershell
Restore-Computer -RestorePoint <number>
reg import .\snapshot\HKLM.reg
powercfg /import .\snapshot\power.pow
```

## What cannot be reverted via scripts
- `debloat`: reinstall Appx manually (Microsoft Store → Library) or `Get-AppxPackage -AllUsers *<name>* | Add-AppxPackage -Register`.
- `system-clean`: files are gone; restore from Recycle? No — they are hard deleted. Check `C:\Windows\SoftwareDistribution\Download` re-creates on next Windows Update.

## Verify after revert
```powershell
.\scripts\Verify.ps1
```
Checks `powercfg /getactivescheme`, `HKLM\...\PowerThrottlingOff`, `HKCU\...`, task states.
