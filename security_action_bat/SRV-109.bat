@echo off
setlocal enabledelayedexpansion

set "TMP1=%SCRIPTNAME%.log"
type nul > %TMP1%

call :BAR

echo CODE [SRV-109] 시스템 주요 이벤트 로그 설정 미흡 >> %TMP1%

echo [양호]: 주요 이벤트 로그 설정이 적절하게 구성되어 있는 경우 >> %TMP1%
echo [취약]: 주요 이벤트 로그 설정이 적절하게 구성되어 있지 않은 경우 >> %TMP1%

call :BAR

:: Windows 환경에서 로그 설정 파일 존재 여부 확인 (예시)
:: 실제 Windows 설정 파일이 아닌 예시 경로입니다.
set "filename=C:\Path\To\Logging\Config\File"

if not exist "%filename%" (
  call :WARN "%filename% 가 존재하지 않습니다."
)

:: Windows에서는 로그 설정을 파일 검사로 확인하기 어렵습니다.
:: PowerShell 또는 다른 메커니즘을 사용하여 설정 확인 필요

:: 여기서는 간단한 메시지 출력으로 대체합니다.
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
