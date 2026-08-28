<#
Revert-Group.ps1 — Run revert commands for a single Viridian group.
#>
param([Parameter(Mandatory)][ValidateSet("network-basic","debloat","visual-tweaks","disable-animations","power-plan","system-clean","game-mode","mouse-fix","startup-opt","flush-dns","input-response","laptop-basic","laptop-battery-perf","laptop-display","telemetry")][string]$Group, [switch]$DryRun = $true, [switch]$Force)

$catalog = Get-Content "$PSScriptRoot\..\CATALOG.json" -Raw | ConvertFrom-Json
$g = $catalog.groups | Where-Object { $_.id -eq $Group }
if (!$g) { throw "Unknown group $Group" }
if (-not $g.revert -or $g.revert.Count -eq 0) { Write-Host "No revert commands for $Group (destructive — manual restore needed)." -ForegroundColor Red; return }

Write-Host "Revert: $($g.id) — $($g.ui)" -ForegroundColor Cyan
foreach ($c in $g.revert) {
  if ($DryRun -and -not $Force) { Write-Host "DRYRUN> $c" -ForegroundColor Yellow }
  else { Write-Host "> $c" -ForegroundColor Cyan; cmd /c $c 2>&1 | Out-Null }
}
if ($DryRun -and -not $Force) { Write-Host "`nDryRun ON — add -Force to execute." -ForegroundColor Magenta }
