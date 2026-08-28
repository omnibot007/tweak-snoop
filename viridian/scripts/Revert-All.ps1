<#
Revert-All.ps1 — Revert every safe Viridian group in dependency-safe order.
Safe = all except debloat + system-clean (destructive).
DryRun by default prints without executing.
#>
param([switch]$DryRun = $true, [switch]$Force)

Set-StrictMode -Version Latest

$catalog = Get-Content "$PSScriptRoot\..\CATALOG.json" -Raw | ConvertFrom-Json

# Dependency-safe order: laptop power first, then power-plan, then rest
$order = @("laptop-display","laptop-battery-perf","laptop-basic","power-plan","network-basic","visual-tweaks","disable-animations","game-mode","mouse-fix","startup-opt","flush-dns","input-response","telemetry")

function Invoke-Cmds($cmds) {
  foreach ($c in $cmds) {
    if ($DryRun) { Write-Host "DRYRUN> $c" -ForegroundColor Yellow }
    else {
      Write-Host "> $c" -ForegroundColor Cyan
      try { cmd /c $c 2>&1 | Out-Null } catch { Write-Warning "$c failed: $_" }
    }
  }
}

if ($DryRun -and -not $Force) { Write-Host "DryRun ON — add -DryRun:`$false or -Force to execute." -ForegroundColor Magenta }

# Warn about destructive groups not reverted
Write-Host "Skipping destructive groups: debloat (Appx), system-clean (file deletes) — manual restore required." -ForegroundColor Red

foreach ($id in $order) {
  $g = $catalog.groups | Where-Object { $_.id -eq $id }
  if (!$g) { continue }
  if (-not $g.revert -or $g.revert.Count -eq 0) { continue }
  Write-Host "`n== revert $id — $($g.ui) ==" -ForegroundColor Green
  Invoke-Cmds $g.revert
  if (-not $DryRun) { Start-Sleep -Milliseconds 400 }
}

if (-not $DryRun) {
  Write-Host "`nRevert done. Consider reboot for power/net/tweaks to fully apply." -ForegroundColor Green
  Write-Host "Verify: .\scripts\Verify.ps1" -ForegroundColor Cyan
}
