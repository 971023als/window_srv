@echo off
setlocal

set TMP1=%SCRIPTNAME%.log
> %TMP1%

echo ---------------------------------------- >> %TMP1%
echo CODE [SRV-123] 최종 로그인 사용자 계정 노출 >> %TMP1%
echo ---------------------------------------- >> %TMP1%

echo [양호]: 최종 로그인 사용자 정보가 노출되지 않는 경우 >> %TMP1%
echo [취약]: 최종 로그인 사용자 정보가 노출되는 경우 >> %TMP1%

echo ---------------------------------------- >> %TMP1%

:: PowerShell을 사용하여 최종 로그인한 사용자 정보 조회
powershell -Command "& {
    $lastLogonEvent = Get-EventLog -LogName Security -InstanceId 4624 -Newest 1
    if ($lastLogonEvent) {
        $message = '최종 로그인 사용자 정보: ' + $lastLogonEvent.ReplacementStrings[5]
        echo $message >> '%TMP1%'
    } else {
        echo '최종 로그인 사용자 정보를 조회할 수 없습니다.' >> '%TMP1%'
    }
}" >> %TMP1%

type %TMP1%

echo.
echo.

endlocal
