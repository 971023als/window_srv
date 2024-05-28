@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-016] 불필요한 RPC서비스 활성화 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: 불필요한 RPC 서비스가 비활성화 되어 있는 경우 >> !TMP1!
echo [취약]: 불필요한 RPC 서비스가 활성화 되어 있는 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: 불필요한 RPC 서비스 활성화 상태 확인 (PowerShell 사용)
powershell -Command "& {
    $RpcServices = @('RpcSs', 'DcomLaunch'); # 예시 RPC 서비스 이름
    foreach ($service in $RpcServices) {
        $ServiceStatus = Get-Service -Name $service -ErrorAction SilentlyContinue;
        if ($ServiceStatus -and $ServiceStatus.Status -eq 'Running') {
            Add-Content !TMP1! 'WARN: 불필요한 RPC 서비스 (' + $service + ') 가 활성화 되어 있습니다.';
        } else {
            Add-Content !TMP1! 'OK: 불필요한 RPC 서비스 (' + $service + ') 가 비활성화 되어 있습니다.';
        }
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
