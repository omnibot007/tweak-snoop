param([Parameter(Mandatory)][string]$Tweak, [switch]$DryRun=$true, [switch]$Force)
# Example: .\scripts\Apply-Group.ps1 -Tweak DisableStartMenuAds -DryRun:$false
$path="C:\Users\LENOVO\hellzerg-optimizer\Optimizer\OptimizeHelper.cs"
$txt=Get-Content $path -Raw
if ($txt -notmatch "internal static void $Tweak\(\)") { throw "Unknown tweak $Tweak" }
Write-Host "Would invoke Optimizer OptimizeHelper::$Tweak (via Hellzerg exe). DryRun preview — see source in CATALOG.json" -ForegroundColor Yellow
if (-not $DryRun -or $Force) { Write-Host "Apply requires running Hellzerg Optimizer build or porting the C# SetValue calls — not auto-executed for safety. Use the original exe: https://github.com/hellzerg/optimizer/releases" -ForegroundColor Cyan }
