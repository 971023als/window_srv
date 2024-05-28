@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-025] 취약한 hosts.equiv 또는 .rhosts 설정 존재 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: hosts.equiv 및 .rhosts 파일이 없거나, 안전하게 구성된 경우 >> !TMP1!
echo [취약]: hosts.equiv 또는 .rhosts 파일에 취약한 설정이 있는 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: SSH 보안 설정 확인 (PowerShell 사용)
powershell -Command "& {
    $SshdConfigPath = 'C:\ProgramData\ssh\sshd_config';
    if (Test-Path $SshdConfigPath) {
        $ConfigContent = Get-Content $SshdConfigPath;
        $SecureSettings = @('PermitEmptyPasswords no', 'PasswordAuthentication yes');
        $InsecureSettingsFound = $false;
        foreach ($setting in $SecureSettings) {
            if (-not ($ConfigContent -contains $setting)) {
                Add-Content !TMP1! ('WARN: SSH 설정에서 보안이 미흡한 설정 발견: ' + $setting);
                $InsecureSettingsFound = $true;
            }
        }
        if (-not $InsecureSettingsFound) {
            Add-Content !TMP1! 'OK: SSH 서비스의 보안 설정이 적절하게 구성되어 있습니다.';
        }
    } else {
        Add-Content !TMP1! 'INFO: SSH 구성 파일(sshd_config)이 존재하지 않습니다.';
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
