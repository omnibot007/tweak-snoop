<#
Snapshot.ps1 — Backup before applying Viridian tweaks.
Creates: Restore Point + reg exports (HKLM/HKCU keys touched) + power scheme export + schtasks state + Appx list.
Run elevated.
#>
param([string]$OutDir = "$PSScriptRoot\..\snapshot-$(Get-Date -Format yyyyMMdd-HHmmss)")

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  Write-Warning "Not elevated — HKLM/power/schtasks exports will be incomplete. Re-run as Administrator."
}

New-Item -ItemType Directory -Path $OutDir -Force | Out-Null
Write-Host "Snapshot -> $OutDir" -ForegroundColor Cyan

# Restore Point (requires System Protection enabled)
try {
  Enable-ComputerRestore -Drive "C:\" -ErrorAction SilentlyContinue
  Checkpoint-Computer -Description "Viridian tweaks snapshot $(Get-Date -Format s)" -RestorePointType MODIFY_SETTINGS -ErrorAction Stop
  Write-Host "Restore Point created." -ForegroundColor Green
} catch { Write-Warning "Checkpoint-Computer failed: $_ (System Protection may be off — enable via SystemPropertiesProtection.exe)" }

# Reg exports - every key the engine touches
$keys = @(
  "HKLM\SYSTEM\CurrentControlSet\Control\Power",
  "HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling",
  "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power",
  "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters",
  "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile",
  "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection",
  "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo",
  "HKCU\SOFTWARE\Microsoft\GameBar",
  "HKCU\Control Panel\Mouse",
  "HKCU\Control Panel\Keyboard",
  "HKCU\Control Panel\Desktop",
  "HKCU\Control Panel\Desktop\WindowMetrics",
  "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced",
  "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize",
  "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run"
)
foreach ($k in $keys) {
  $hive = ($k -split "\\")[0]
  $path = $k.Substring($hive.Length+1)
  $psPath = if ($hive -eq "HKLM") { "HKLM:\$path" } else { "HKCU:\$path" }
  $safe = ($k -replace "[:\\ ]","_")
  try {
    # reg.exe export is more faithful than Get-ItemProperty for binary values
    $out = Join-Path $OutDir "$safe.reg"
    reg export "$k" "$out" /y 2>$null | Out-Null
    if (!(Test-Path $out)) { Get-ItemProperty -Path $psPath -ErrorAction Stop | Out-File (Join-Path $OutDir "$safe.txt") }
    Write-Host "exported $k" -ForegroundColor DarkGray
  } catch { Write-Warning "export failed $k : $_" }
}

# Power
try { powercfg /export (Join-Path $OutDir "power.pow") 2>&1 | Out-Null; Write-Host "powercfg exported" -ForegroundColor DarkGray } catch {}

# Tasks
try { schtasks /query /fo LIST /v | Out-File (Join-Path $OutDir "schtasks.txt") -Encoding utf8; Write-Host "schtasks dumped" -ForegroundColor DarkGray } catch {}

# Appx
try { Get-AppxPackage | Select-Object Name, PackageFullName | Out-File (Join-Path $OutDir "appx.txt") -Encoding utf8 } catch {}

# Catalog copy
Copy-Item "$PSScriptRoot\..\CATALOG.json" $OutDir -ErrorAction SilentlyContinue
Get-FileHash "$OutDir\*.reg" -ErrorAction SilentlyContinue | Out-File (Join-Path $OutDir "hashes.txt")

Write-Host "Done. To restore: reg import <file>.reg, powercfg /import, schtasks /change /enable, rstrui.exe" -ForegroundColor Green
