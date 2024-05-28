@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-029] SMB 세션 중단 관리 설정 미비 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: SMB 서비스의 세션 중단 시간이 적절하게 설정된 경우 >> !TMP1!
echo [취약]: SMB 서비스의 세션 중단 시간 설정이 미비한 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: SMB 세션 중단 시간 설정 확인 (PowerShell 사용)
powershell -Command "& {
    $path = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters';
    $deadtime = Get-ItemPropertyValue -Path $path -Name 'autodisconnect' -ErrorAction SilentlyContinue;
    if ($null -ne $deadtime) {
        if ($deadtime -gt 0) {
            Add-Content !TMP1! ('OK: SMB 세션 중단 시간(autodisconnect)이 적절하게 설정되어 있습니다: ' + $deadtime + ' 분');
        } else {
            Add-Content !TMP1! 'WARN: SMB 세션 중단 시간(autodisconnect) 설정이 미비합니다.';
        }
    } else {
        Add-Content !TMP1! 'WARN: SMB 세션 중단 시간(autodisconnect) 설정이 레지스트리에 존재하지 않습니다.';
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
