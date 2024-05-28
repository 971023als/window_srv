@echo off
setlocal

set TMP1=%SCRIPTNAME%.log
> %TMP1%

echo ---------------------------------------- >> %TMP1%
echo CODE [SRV-126] 자동 로그온 방지 설정 미흡 >> %TMP1%
echo ---------------------------------------- >> %TMP1%

echo [양호]: 자동 로그온이 비활성화된 경우 >> %TMP1%
echo [취약]: 자동 로그온이 활성화된 경우 >> %TMP1%

echo ---------------------------------------- >> %TMP1%

:: PowerShell을 사용하여 자동 로그온 설정 확인
powershell -Command "& {
    $autoLogonKey = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
    $autoLogonValue = Get-ItemProperty -Path $autoLogonKey -Name 'AutoAdminLogon' -ErrorAction SilentlyContinue
    if ($autoLogonValue.AutoAdminLogon -eq '1') {
        echo 'WARN: 자동 로그온이 활성화되어 있습니다.' >> '%TMP1%'
    } else {
        echo 'OK: 자동 로그온이 비활성화되어 있습니다.' >> '%TMP1%'
    }
}" >> %TMP1%

type %TMP1%

echo.
echo.

endlocal
