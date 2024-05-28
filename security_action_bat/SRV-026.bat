@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-026] root 계정 원격 접속 제한 미비 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: SSH를 통한 Administrator 계정의 원격 접속이 제한된 경우 >> !TMP1!
echo [취약]: SSH를 통한 Administrator 계정의 원격 접속이 제한되지 않은 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: SSH 구성 파일에서 PermitRootLogin 설정 확인 (PowerShell 사용)
powershell -Command "& {
    $SshdConfigPath = 'C:\ProgramData\ssh\sshd_config';
    if (Test-Path $SshdConfigPath) {
        $ConfigContent = Get-Content $SshdConfigPath;
        $PermitRootLogin = $ConfigContent | Where-Object { $_ -match 'PermitRootLogin' };
        if ($PermitRootLogin -match 'no') {
            Add-Content !TMP1! 'OK: SSH를 통한 Administrator 계정의 원격 접속이 제한되어 있습니다.';
        } else {
            Add-Content !TMP1! 'WARN: SSH를 통한 Administrator 계정의 원격 접속 제한 설정이 미흡합니다.';
        }
    } else {
        Add-Content !TMP1! 'INFO: OpenSSH 구성 파일(sshd_config)이 존재하지 않습니다.';
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
