@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-015] 불필요한 NFS 서비스 실행 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: 불필요한 NFS 서비스 관련 데몬이 비활성화 되어 있는 경우 >> !TMP1!
echo [취약]: 불필요한 NFS 서비스 관련 데몬이 활성화 되어 있는 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: NFS 서비스 실행 상태 확인 (PowerShell 사용)
powershell -Command "& {
    $NfsService = Get-Service -Name 'NfsService' -ErrorAction SilentlyContinue;
    if ($NfsService -and $NfsService.Status -eq 'Running') {
        Add-Content !TMP1! 'WARN: 불필요한 NFS 서비스 관련 데몬이 실행 중입니다.';
    } else {
        Add-Content !TMP1! 'OK: 불필요한 NFS 서비스 관련 데몬이 비활성화';
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
