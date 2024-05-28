@echo off
setlocal enabledelayedexpansion

set "TMP1=%SCRIPTNAME%.log"
type nul > %TMP1%

call :BAR

echo CODE [SRV-115] 로그의 정기적 검토 및 보고 미수행 >> %TMP1%

echo [양호]: 로그가 정기적으로 검토 및 보고되고 있는 경우 >> %TMP1%
echo [취약]: 로그가 정기적으로 검토 및 보고되지 않는 경우 >> %TMP1%

call :BAR

:: 로그 검토 및 보고 스크립트 존재 여부 확인
set "log_review_script=C:\path\to\log\review\script"
if not exist "%log_review_script%" (
  call :WARN "로그 검토 및 보고 스크립트가 존재하지 않습니다."
) else (
  call :OK "로그 검토 및 보고 스크립트가 존재합니다."
)

:: 로그 보고서 존재 여부 확인
set "log_report=C:\path\to\log\report"
if not exist "%log_report%" (
  call :WARN "로그 보고서가 존재하지 않습니다."
) else (
  call :OK "로그 보고서가 존재합니다."
)

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
