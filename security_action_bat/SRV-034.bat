@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-034] 불필요한 서비스 활성화 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: 불필요한 서비스가 비활성화된 경우 >> !TMP1!
echo [취약]: 불필요한 서비스가 활성화된 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: 불필요한 서비스 목록
set "services=Telnet RemoteRegistry"

:: 서비스 상태 확인 (PowerShell 사용)
for %%s in (!services!) do (
    powershell -Command "& {
        $service = Get-Service -Name '%%s' -ErrorAction SilentlyContinue;
        if ($service -and $service.Status -eq 'Running') {
            Add-Content !TMP1! ('WARN: 불필요한 서비스 ''%%s''가 활성화되어 있습니다.');
        } else {
            Add-Content !TMP1! ('OK: 서비스 ''%%s''가 비활성화되어 있거나, 시스템에 설치되지 않았습니다.');
        }
    }"
)

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
