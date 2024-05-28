@echo off
setlocal enabledelayedexpansion

:: 임시 로그 파일 생성
set "SCRIPTNAME=%~n0"
set "TMP1=%SCRIPTNAME%.log"
type nul > "%TMP1%"

echo ------------------------------------------------ >> "%TMP1%"
echo CODE [SRV-119] 백신 프로그램 업데이트 상태 검사 >> "%TMP1%"
echo ------------------------------------------------ >> "%TMP1%"

echo [양호]: 백신 프로그램이 최신 버전으로 업데이트 되어 있는 경우 >> "%TMP1%"
echo [취약]: 백신 프로그램이 최신 버전으로 업데이트 되어 있지 않은 경우 >> "%TMP1%"
echo ------------------------------------------------ >> "%TMP1%"

:: 백신 프로그램의 업데이트 상태를 확인합니다 (예시: ClamAV)
for /f "tokens=*" %%i in ('clamscan --version') do set clamav_version=%%i
for /f "tokens=*" %%i in ('powershell -Command "& {(Invoke-WebRequest -Uri 'https://www.clamav.net/downloads').Content | Select-String -Pattern 'ClamAV\s[0-9.]+' -AllMatches | ForEach-Object {$_.Matches} | ForEach-Object {$_.Value} | Select-Object -First 1}"') do set latest_clamav_version=%%i

if "!clamav_version!"=="!latest_clamav_version!" (
  echo OK: ClamAV가 최신 버전입니다: !clamav_version! >> "%TMP1%"
) else (
  echo WARN: ClamAV가 최신 버전이 아닙니다. 현재 버전: !clamav_version!, 최신 버전: !latest_clamav_version! >> "%TMP1%"
)

echo ------------------------------------------------ >> "%TMP1%"
type "%TMP1%"

echo.
echo Script complete.

endlocal
