param([Parameter(Mandatory)][int]$AppPid)

$ErrorActionPreference = 'Continue'
$pass = 0; $fail = 0; $results = @()

$windows = winapp ui list-windows -a $AppPid --json 2>$null | ConvertFrom-Json
$hwnd = ($windows | Where-Object { $_.title -ne "PopupHost" } | Select-Object -First 1).hwnd
Write-Host "Testing app PID $AppPid (HWND: $hwnd)"

function Test-UI {
    param([string]$Name, [scriptblock]$Script)
    try {
        $output = & $Script 2>&1
        if ($LASTEXITCODE -eq 0) {
            $script:pass++; $script:results += @{ name = $Name; status = "PASS" }
            Write-Host "  PASS: $Name" -ForegroundColor Green
        } else {
            $script:fail++; $script:results += @{ name = $Name; status = "FAIL"; detail = "$output" }
            Write-Host "  FAIL: $Name — $output" -ForegroundColor Red
        }
    } catch {
        $script:fail++; $script:results += @{ name = $Name; status = "FAIL"; detail = "$_" }
        Write-Host "  FAIL: $Name — $_" -ForegroundColor Red
    }
}

New-Item -ItemType Directory -Force -Path "D:\wsatools\winui 3\wsa_pacman\screenshots" | Out-Null

# ─── Initial screenshot ───
winapp ui screenshot -a $AppPid -o "D:\wsatools\winui 3\wsa_pacman\screenshots\01-initial.png" 2>$null

# ─── Navigation elements ───
Write-Host "`n[Navigation]"
Test-UI "NavItemWsa exists"      { winapp ui wait-for "NavItemWsa"      -a $AppPid -t 3000 }
Test-UI "NavItemUninstall exists" { winapp ui wait-for "NavItemUninstall" -a $AppPid -t 3000 }
Test-UI "NavItemSettings exists"  { winapp ui wait-for "NavItemSettings"  -a $AppPid -t 3000 }

# ─── WSA page (default) ───
Write-Host "`n[WSA Page]"
Test-UI "RefreshStatus button exists" { winapp ui wait-for "BtnRefreshStatus" -a $AppPid -t 3000 }
Test-UI "ManageApps button exists"    { winapp ui wait-for "BtnManageApps"    -a $AppPid -t 3000 }
Test-UI "ManageSettings button exists"{ winapp ui wait-for "BtnManageSettings" -a $AppPid -t 3000 }

winapp ui screenshot -a $AppPid -o "D:\wsatools\winui 3\wsa_pacman\screenshots\02-wsa-page.png" 2>$null

# ─── Navigate to Uninstall ───
Write-Host "`n[Uninstall Page]"
Test-UI "Navigate to Uninstall" { winapp ui invoke "NavItemUninstall" -a $AppPid }
Start-Sleep -Milliseconds 500
Test-UI "BtnScan exists"             { winapp ui wait-for "BtnScan"            -a $AppPid -t 3000 }
Test-UI "BtnBackupRegistry exists"   { winapp ui wait-for "BtnBackupRegistry"  -a $AppPid -t 3000 }
Test-UI "BtnCleanup exists"          { winapp ui wait-for "BtnCleanup"         -a $AppPid -t 3000 }
Test-UI "BtnCleanup disabled by default" {
    winapp ui wait-for "BtnCleanup" -a $AppPid -p IsEnabled --value "False" -t 2000
}

winapp ui screenshot -a $AppPid -o "D:\wsatools\winui 3\wsa_pacman\screenshots\03-uninstall-page.png" 2>$null

# ─── Navigate to Settings ───
Write-Host "`n[Settings Page]"
Test-UI "Navigate to Settings" { winapp ui invoke "NavItemSettings" -a $AppPid }
Start-Sleep -Milliseconds 500
Test-UI "SettingPort exists"         { winapp ui wait-for "SettingPort"         -a $AppPid -t 3000 }
Test-UI "SettingAutostart exists"    { winapp ui wait-for "SettingAutostart"    -a $AppPid -t 3000 }
Test-UI "SettingAutoBackup exists"   { winapp ui wait-for "SettingAutoBackup"   -a $AppPid -t 3000 }
Test-UI "SettingTimeout exists"      { winapp ui wait-for "SettingTimeout"      -a $AppPid -t 3000 }
Test-UI "SettingLanguage exists"     { winapp ui wait-for "SettingLanguage"     -a $AppPid -t 3000 }
Test-UI "SettingBackupDir exists"    { winapp ui wait-for "SettingBackupDir"    -a $AppPid -t 3000 }

winapp ui screenshot -a $AppPid -o "D:\wsatools\winui 3\wsa_pacman\screenshots\04-settings-page.png" 2>$null

# ─── Back to WSA ───
Write-Host "`n[Return Navigation]"
Test-UI "Navigate back to WSA"  { winapp ui invoke "NavItemWsa" -a $AppPid }
Start-Sleep -Milliseconds 500
Test-UI "WSA page restored"     { winapp ui wait-for "BtnRefreshStatus" -a $AppPid -t 3000 }

winapp ui screenshot -a $AppPid -o "D:\wsatools\winui 3\wsa_pacman\screenshots\05-final.png" 2>$null

# ─── Results ───
Write-Host "`nPassed: $pass | Failed: $fail"
$results | ConvertTo-Json | Out-File "D:\wsatools\winui 3\wsa_pacman\test-results.json"
if ($fail -gt 0) { exit 1 } else { exit 0 }
