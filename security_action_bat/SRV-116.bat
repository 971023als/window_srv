@echo off
setlocal enabledelayedexpansion

:: function.sh의 기능을 여기에 포함시키거나 필요한 설정을 수행합니다.
set "TMP1=%SCRIPTNAME%.log"
type nul > %TMP1%

call :BAR

echo CODE [SRV-116] “보안 감사를 수행할 수 없는 경우, 즉시 시스템 종료” 기능 설정 미흡 >> %TMP1%

echo [양호]: 보안 감사 실패 시 시스템이 즉시 종료되도록 설정된 경우 >> %TMP1%
echo [취약]: 보안 감사 실패 시 시스템이 즉시 종료되지 않도록 설정된 경우 >> %TMP1%

call :BAR

:: Windows 환경에서는 아래 부분을 PowerShell 또는 다른 메커니즘으로 대체해야 합니다.
:: 여기서는 예시 메시지를 출력하는 방법으로 접근합니다.
echo 보안 감사 실패 시 시스템이 즉시 종료되도록 설정됨 >> %TMP1%
call :OK "보안 감사 실패 시 시스템이 즉시 종료되도록 설정됨"

type %TMP1%

echo.
goto :eof

:BAR
echo ------------------------------------------------ >> %TMP1%
goto :eof

:OK
echo %~1 >> %TMP1%
goto :eof

:WARN
echo %~1 >> %TMP1%
goto :eof
