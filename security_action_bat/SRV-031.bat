@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-031] 계정 목록 및 네트워크 공유 이름 노출 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: SMB 서비스에서 계정 목록 및 네트워크 공유 이름이 노출되지 않는 경우 >> !TMP1!
echo [취약]: SMB 서비스에서 계정 목록 및 네트워크 공유 이름이 노출되는 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: 네트워크 공유의 열거 제한 설정 확인 (PowerShell 사용)
powershell -Command "& {
    $registryPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters';
    $restrictNullSessAccess = Get-ItemPropertyValue -Path $registryPath -Name 'RestrictNullSessAccess' -ErrorAction SilentlyContinue;
    if ($null -ne $restrictNullSessAccess -and $restrictNullSessAccess -eq 1) {
        Add-Content !TMP1! 'OK: SMB 서비스에서 계정 목록 및 네트워크 공유 이름이 적절하게 보호되고 있습니다.';
    } else {
        Add-Content !TMP1! 'WARN: SMB 서비스에서 계정 목록 또는 네트워크 공유 이름이 노출될 수 있습니다.';
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
