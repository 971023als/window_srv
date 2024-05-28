@echo off
SetLocal EnableDelayedExpansion

set "SCRIPTNAME=%~n0"
set "TMP1=%SCRIPTNAME%.log"

:: 로그 파일 초기화
type NUL > "%TMP1%"

echo BAR >> "%TMP1%"
echo CODE [SRV-171] FTP 서비스 정보 노출 >> "%TMP1%"
echo [양호]: FTP 서버에서 버전 정보 및 기타 세부 정보가 노출되지 않는 경우 >> "%TMP1%"
echo [취약]: FTP 서버에서 버전 정보 및 기타 세부 정보가 노출되는 경우 >> "%TMP1%"
echo BAR >> "%TMP1%"

:: FTP 서비스 실행 상태 확인
for /f "tokens=*" %%i in ('sc query ftpsvc ^| findstr /C:"RUNNING"') do (
    set "serviceStatus=%%i"
)

:: 서비스 상태에 따른 메시지 출력
if defined serviceStatus (
    echo FTP 서비스가 실행 중입니다. >> "%TMP1%"
    :: FTP 서버 버전 정보 및 세부 정보 노출 여부 점검 로직 필요
    echo [주의] FTP 서버의 버전 정보 및 세부 정보 노출 여부를 수동으로 확인해야 합니다. >> "%TMP1%"
) else (
    echo FTP 서비스가 실행되지 않습니다. >> "%TMP1%"
)

echo BAR >> "%TMP1%"

:: 결과 표시 및 스크립트 종료
type "%TMP1%"
echo.
echo 스크립트 완료.

EndLocal
