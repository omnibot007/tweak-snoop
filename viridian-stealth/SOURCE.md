# Source verification

- Engine: `C:\Users\LENOVO\AppData\Local\Programs\Viridian Free Utility\resources\engine\ViridianFreeEngine.exe` (321,536 B)
- Strings dump: `re.findall(b'[ -~]{6,}', open(exe,'rb').read()) | Select-String "schtasks|AllowTelemetry|AdvertisingInfo"`
  - 8 `schtasks /change /tn ... /disable` + 2 `Reg.exe add ... AllowTelemetry/AdvertisingInfo`
  - Revert is `/enable` + `... /d 1`
- Pre-apply snapshot: `C:\Users\LENOVO\.backup\viridian-stealth-pre-<ts>\` contains `DataCollection.reg`, `schtasks-before.txt`, Restore Point.
- Verify: `schtasks /query /tn "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"` + `Get-ItemProperty HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection`
