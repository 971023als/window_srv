@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-004] 불필요한 SMTP 서비스 실행 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: SMTP 서비스가 비활성화되어 있거나 필요한 경우에만 실행되는 경우 >> !TMP1!
echo [취약]: SMTP 서비스가 필요하지 않음에도 실행되고 있는 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: Windows에서 SMTP 서비스 (예: Simple Mail Transfer Protocol) 실행 여부 확인
sc query "SMTPSVC" | find /i "RUNNING" > nul
if not errorlevel 1 (
    echo SMTP 서비스가 실행 중입니다. >> !TMP1!
) else (
    echo SMTP 서비스가 비활성화되어 있거나 실행 중이지 않습니다. >> !TMP1!
)

:: SMTP 포트 25 상태 확인
netstat -an | find ":25 " > nul
if not errorlevel 1 (
    echo SMTP 포트(25)가 열려 있습니다. 불필요한 서비스가 실행 중일 수 있습니다. >> !TMP1!
) else (
    echo SMTP 포트(25)는 닫혀 있습니다. >> !TMP1!
)

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
