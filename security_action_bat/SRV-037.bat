@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-037] 취약한 FTP 서비스 실행 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: FTP 서비스가 비활성화 되어 있는 경우 >> !TMP1!
echo [취약]: FTP 서비스가 활성화 되어 있는 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: FTP 서비스 상태 확인 (PowerShell 사용)
powershell -Command "& {
    $service = Get-Service -Name 'FTPSvc' -ErrorAction SilentlyContinue;
    if ($service -and $service.Status -eq 'Running') {
        Add-Content !TMP1! 'WARN: FTP 서비스가 활성화되어 있습니다.';
    } else {
        Add-Content !TMP1! 'OK: FTP 서비스가 비활성화되어 있습니다.';
    }
    
    $port21Listening = Test-NetConnection -ComputerName localhost -Port 21 -InformationLevel Quiet;
    if ($port21Listening) {
        Add-Content !TMP1! 'WARN: 시스템에서 포트 21이(가) 열려 있습니다. FTP 서비스가 활성화되어 있을 수 있습니다.';
    } else {
        Add-Content !TMP1! 'OK: 시스템에서 포트 21이(가) 닫혀 있습니다. FTP 서비스가 비활성화되어 있습니다.';
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
