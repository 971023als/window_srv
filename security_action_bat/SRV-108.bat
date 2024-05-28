@echo off
setlocal enabledelayedexpansion

set "TMP1=%SCRIPTNAME%.log"
type nul > %TMP1%

call :BAR

echo CODE [SRV-108] 로그에 대한 접근통제 및 관리 미흡 >> %TMP1%

echo [양호]: 로그 파일의 접근 통제 및 관리가 적절하게 설정되어 있는 경우 >> %TMP1%
echo [취약]: 로그 파일의 접근 통제 및 관리가 적절하게 설정되어 있지 않은 경우 >> %TMP1%

call :BAR

:: Windows 환경에서는 로그 설정 파일의 존재 여부를 이렇게 확인할 수 있습니다.
:: 이 예제에서는 실제 Windows 로그 설정 파일 경로를 사용해야 합니다.
set "filename=C:\Windows\System32\winevt\Logs\System.evtx"

if not exist "%filename%" (
  call :WARN "%filename% 가 존재하지 않습니다."
)

:: 여기서는 실제 로그 파일 설정의 접근 통제 및 관리를 검사하는 대신,
:: 간단한 메시지를 출력합니다. 실제 검사는 PowerShell 스크립트를 사용해야 합니다.
call :WARN "%filename%의 내용이 잘못되었습니다."

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
