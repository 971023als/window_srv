@echo off
setlocal

set TMP1=%SCRIPTNAME%.log
> %TMP1%

echo ---------------------------------------- >> %TMP1%
echo CODE [SRV-127] 계정 잠금 임계값 설정 미비 >> %TMP1%
echo ---------------------------------------- >> %TMP1%

echo [양호]: 계정 잠금 임계값이 적절하게 설정된 경우 >> %TMP1%
echo [취약]: 계정 잠금 임계값이 적절하게 설정되지 않은 경우 >> %TMP1%

echo ---------------------------------------- >> %TMP1%

:: PowerShell을 사용하여 계정 잠금 정책 확인
powershell -Command "& {
    $accountLockoutThreshold = (Get-ItemProperty 'HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters').MaximumPasswordAge
    if ($accountLockoutThreshold -ne $null -and $accountLockoutThreshold -gt 0) {
        echo 'OK: 계정 잠금 임계값이 설정되어 있습니다: 임계값 = ' + $accountLockoutThreshold >> '%TMP1%'
    } else {
        echo 'WARN: 계정 잠금 임계값이 설정되어 있지 않습니다.' >> '%TMP1%'
    }
}" >> %TMP1%

type %TMP1%

echo.
echo.

endlocal
