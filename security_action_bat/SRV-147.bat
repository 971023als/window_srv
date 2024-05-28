@echo off
setlocal

set TMP1=%SCRIPTNAME%.log
type NUL > %TMP1%

echo ---------------------------------------- >> %TMP1%
echo CODE [SRV-147] 불필요한 SNMP 서비스 실행 >> %TMP1%
echo ---------------------------------------- >> %TMP1%

echo [양호]: SNMP 서비스가 비활성화되어 있는 경우 >> %TMP1%
echo [취약]: SNMP 서비스가 활성화되어 있는 경우 >> %TMP1%

echo ---------------------------------------- >> %TMP1%

:: SNMP 서비스 상태 확인
sc query SNMP | find "RUNNING" >nul
if %ERRORLEVEL% == 0 (
    echo WARN: SNMP 서비스를 사용하고 있습니다. >> %TMP1%
) else (
    echo OK: SNMP 서비스가 비활성화되어 있습니다. >> %TMP1%
)

type %TMP1%

echo.
echo.

endlocal
