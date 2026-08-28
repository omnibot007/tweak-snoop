<#
Verify.ps1 — Report current values vs Viridian forward/revert expectations.
#>
Set-StrictMode -Version Latest
Write-Host "=== Power ===" -ForegroundColor Cyan
powercfg /getactivescheme
try { Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -ErrorAction Stop | Format-List PowerThrottlingOff } catch { Write-Host "PowerThrottling key missing" -ForegroundColor Yellow }
try { Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Power" | Format-List HiberbootEnabled } catch {}
try { Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Power" | Format-List HibernateEnabled } catch {}

Write-Host "`n=== Network ===" -ForegroundColor Cyan
try { Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" | Format-List DefaultTTL, Tcp1323Opts } catch {}
try { Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" | Format-List NetworkThrottlingIndex } catch {}
netsh int tcp show global | Select-String "RSS|ECN|Timestamp|Heuristics"

Write-Host "`n=== Visual/Game/Mouse/Keyboard ===" -ForegroundColor Cyan
Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" -ErrorAction SilentlyContinue | Format-List EnableTransparency, AppsUseLightTheme
Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -ErrorAction SilentlyContinue | Format-List TaskbarAnimations, ShowTaskViewButton, HideFileExt, ShowSyncProviderNotifications, DisallowShaking
Get-ItemProperty "HKCU:\Control Panel\Desktop\WindowMetrics" -ErrorAction SilentlyContinue | Format-List MinAnimate
Get-ItemProperty "HKCU:\Control Panel\Desktop" -ErrorAction SilentlyContinue | Format-List MenuShowDelay
Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\GameBar" -ErrorAction SilentlyContinue | Format-List AllowAutoGameMode, AutoGameModeEnabled
Get-ItemProperty "HKCU:\Control Panel\Mouse" -ErrorAction SilentlyContinue | Format-List MouseSpeed, MouseThreshold1, MouseThreshold2, MouseSensitivity
Get-ItemProperty "HKCU:\Control Panel\Keyboard" -ErrorAction SilentlyContinue | Format-List KeyboardDelay, KeyboardSpeed

Write-Host "`n=== Tasks (telemetry) ===" -ForegroundColor Cyan
"schtasks /query /tn \Microsoft\Windows\Customer Experience Improvement Program\Consolidator" | ForEach-Object { try { schtasks /query /tn "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /fo LIST | Select-String Status } catch {} }
schtasks /query /tn "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" 2>&1 | Select-String "Disabled|Ready|Status"

Write-Host "`n=== StartupApproved ===" -ForegroundColor Cyan
Get-ItemProperty "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" -ErrorAction SilentlyContinue | Format-List Discord, Spotify, Steam, EpicGamesLauncher

Write-Host "`nDone. Compare to CATALOG.json revert vs forward." -ForegroundColor Green
