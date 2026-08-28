# Source verification

## Artifacts read this session (Verified)

- `C:\Users\LENOVO\AppData\Local\Programs\Viridian Free Utility\resources\app.asar` unpacked to `C:\Users\LENOVO\AppData\Local\Temp\opencode\viridian-extract\` via `npx @electron/asar extract`:
  - `main.js:42-55` `freeSecret()` XOR+base64 (free VPS secret, isolated to `/api/free/*`)
  - `engine-bridge.js:28-78` `EngineBridge` (TCP 51877, `Start-Process -Verb RunAs`) + `StdioEngineBridge`
  - `renderer/app.html` `data-group`/`data-revert` per card, `renderer/app.js:190+` `engineSend({action:run|revert})`
- `C:\Users\LENOVO\AppData\Local\Programs\Viridian Free Utility\resources\engine\ViridianFreeEngine.exe` 321,536 B, 2026-06-12.
- Live interrogation:
  ```powershell
  py -3 -c "subprocess.Popen([exe], ...); send {id:1,action:steps,group:g}" # for each of 14 groups
  ```
  Dumped labels in `CATALOG.json` (verified `network-basic` → 10 labels, etc.)
- Raw string dump:
  ```powershell
  re.findall(b'[ -~]{6,}', open(exe,'rb').read()) | Select-String "Reg.exe|powercfg|netsh|schtasks|ipconfig"
  ```
  54 `Reg.exe add`, 2 `delete`, full command lines captured verbatim in catalog.
- Current state:
  ```powershell
  powercfg /getactivescheme  # 8c5e7fda... High performance
  Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling  # PowerThrottlingOff=1
  schtasks /query /tn "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"  # Disabled
  ```

## Repro
```powershell
$exe="C:\Users\LENOVO\AppData\Local\Programs\Viridian Free Utility\resources\engine\ViridianFreeEngine.exe"
py -3 -c "import subprocess,json; p=subprocess.Popen([r'$exe'], stdin=subprocess.PIPE, stdout=subprocess.PIPE, text=True); print(p.stdout.readline()); p.stdin.write(json.dumps({'id':1,'action':'steps','group':'network-basic'})+'\n'); p.stdin.flush(); print(p.stdout.readline())"
# repeat for debloat, visual-tweaks, ...
```

## Hashes (add your own)
```powershell
Get-FileHash $exe -Algorithm SHA256
Get-FileHash "C:\Users\LENOVO\AppData\Local\Programs\Viridian Free Utility\resources\app.asar" -Algorithm SHA256
```

## Limitations
- `debloat`/`system-clean` revert is not captured because it doesn't exist in binary — verified by absence of `Add-AppxPackage`/`reg import` strings.
- Engine also exposes `action:stats` (PDH CPU/RAM/disk/net) and `action:procreduce` — not tweak-related.
