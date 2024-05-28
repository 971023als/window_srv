@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-028] 원격 터미널 접속 타임아웃 미설정 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: SSH 원격 터미널 접속 타임아웃이 적절하게 설정된 경우 >> !TMP1!
echo [취약]: SSH 원격 터미널 접속 타임아웃이 설정되지 않은 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: SSH 타임아웃 설정 확인 (PowerShell 사용)
powershell -Command "& {
    $SshdConfigPath = 'C:\ProgramData\ssh\sshd_config';
    if (Test-Path $SshdConfigPath) {
        $ConfigContent = Get-Content $SshdConfigPath;
        $ClientAliveInterval = $ConfigContent | Where-Object { $_ -match '^ClientAliveInterval' };
        $ClientAliveCountMax = $ConfigContent | Where-Object { $_ -match '^ClientAliveCountMax' };
        if ($ClientAliveInterval -and $ClientAliveCountMax) {
            Add-Content !TMP1! 'OK: SSH 원격 터미널 타임아웃 설정이 적절하게 구성되어 있습니다.';
        } else {
            Add-Content !TMP1! 'WARN: SSH 원격 터미널 타임아웃 설정이 미비합니다.';
        }
    } else {
        Add-Content !TMP1! 'INFO: OpenSSH 구성 파일(sshd_config)이 존재하지 않습니다.';
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
