@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-027] 서비스 접근 IP 및 포트 제한 미비 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: 서비스에 대한 IP 및 포트 접근 제한이 적절하게 설정된 경우 >> !TMP1!
echo [취약]: 서비스에 대한 IP 및 포트 접근 제한이 설정되지 않은 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: 방화벽 규칙 확인 (PowerShell 사용)
powershell -Command "& {
    $FirewallRules = Get-NetFirewallRule -Enabled True -Direction Inbound | Where-Object { $_.Action -eq 'Block' };
    if ($FirewallRules.Count -gt 0) {
        foreach ($rule in $FirewallRules) {
            $ruleName = $rule.DisplayName;
            Add-Content !TMP1! ('OK: 방화벽 규칙 '''+ $ruleName +'''가 접근을 차단하도록 설정되어 있습니다.');
        }
    } else {
        Add-Content !TMP1! 'WARN: 서비스에 대한 IP 및 포트 접근 제한을 설정하는 방화벽 규칙이 없습니다.';
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
