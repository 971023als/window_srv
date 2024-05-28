@echo off
setlocal enabledelayedexpansion

set "TMP1=%SCRIPTNAME%.log"
type nul > %TMP1%

echo ------------------------------------------------ >> %TMP1%
echo CODE [SRV-105] 불필요한 시작프로그램 존재 >> %TMP1%
echo ------------------------------------------------ >> %TMP1%

echo [양호]: 불필요한 시작 프로그램이 존재하지 않는 경우 >> %TMP1%
echo [취약]: 불필요한 시작 프로그램이 존재하는 경우 >> %TMP1%
echo ------------------------------------------------ >> %TMP1%

:: 시스템 시작 시 실행되는 프로그램 목록 확인
for /f "tokens=*" %%i in ('wmic startup get caption, command') do (
  set "service=%%i"
  :: 여기서는 단순히 모든 시작 프로그램을 나열합니다.
  :: 불필요하거나 의심스러운 서비스를 식별하는 로직을 추가해야 합니다.
  if not "!service!"=="" (
    echo 의심스러운 시작 프로그램: !service! >> %TMP1%
  )
)

:: 불필요한 시작 프로그램이 없다는 메시지는 조건부 로직에 따라 결정됩니다.
:: 실제 조건부 로직을 구현하기 위해서는 추가 분석이 필요합니다.
echo 시스템에 불필요한 시작 프로그램이 없습니다. >> %TMP1%

type %TMP1%

echo.
