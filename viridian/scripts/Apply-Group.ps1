<#
Apply-Group.ps1 — Run forward commands for a single Viridian group.
Defaults to DryRun (print only).
#>
param([Parameter(Mandatory)][ValidateSet("network-basic","debloat","visual-tweaks","disable-animations","power-plan","system-clean","game-mode","mouse-fix","startup-opt","flush-dns","input-response","laptop-basic","laptop-battery-perf","laptop-display","telemetry")][string]$Group, [switch]$DryRun = $true, [switch]$Force)

$catalog = Get-Content "$PSScriptRoot\..\CATALOG.json" -Raw | ConvertFrom-Json
$g = $catalog.groups | Where-Object { $_.id -eq $Group }
if (!$g) { throw "Unknown group $Group" }

Write-Host "Group: $($g.id) — $($g.ui)" -ForegroundColor Cyan
Write-Host "Labels:" -ForegroundColor DarkGray; $g.labels | ForEach-Object { Write-Host "  - $_" }
if ($g.note) { Write-Host "Note: $($g.note)" -ForegroundColor Yellow }
if ($g.revertible -eq $false) { Write-Host "WARNING: Destructive / not revertible via engine!" -ForegroundColor Red }

Write-Host "`nForward commands:" -ForegroundColor Green
foreach ($c in $g.forward) {
  if ($DryRun -and -not $Force) { Write-Host "DRYRUN> $c" -ForegroundColor Yellow }
  else { Write-Host "> $c" -ForegroundColor Cyan; cmd /c $c 2>&1 | Out-Null }
}
if ($DryRun -and -not $Force) { Write-Host "`nDryRun ON — add -Force to execute." -ForegroundColor Magenta }
