param([Parameter(Mandatory)][string]$Tweak, [switch]$DryRun=$true)
# Tweak is Disable* name, will map to Enable*
$enable="Enable"+$Tweak.Substring(7)
Write-Host "Revert $Tweak -> $enable (DryRun=$DryRun) — see Enable* in OptimizeHelper.cs" -ForegroundColor Cyan
