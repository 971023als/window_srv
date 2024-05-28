@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-043] 웹 서비스 경로 내 불필요한 파일 존재 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!
echo [양호]: 웹 서비스 경로 내 불필요한 파일이 존재하지 않음 >> !TMP1!
echo [취약]: 웹 서비스 경로 내 불필요한 파일이 존재함 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: 기본 IIS 웹 서비스 경로 설정
set "WEB_SERVICE_PATH=C:\inetpub\wwwroot"

:: 웹 서비스 경로 내 흔히 발견되는 불필요한 파일 목록 작성
echo %WEB_SERVICE_PATH% 내 흔히 발견되는 불필요한 파일 검사 중: >> !TMP1!
dir "%WEB_SERVICE_PATH%\*.bak" /s /b >> !TMP1!
dir "%WEB_SERVICE_PATH%\*.tmp" /s /b >> !TMP1!
dir "%WEB_SERVICE_PATH%\*test*" /s /b >> !TMP1!
dir "%WEB_SERVICE_PATH%\*example*" /s /b >> !TMP1!

:: 주의: 이 스크립트는 흔한 패턴을 기반으로 파일을 나열합니다. 수동으로 검토해 주세요.
echo 주의: 나열된 파일을 수동으로 검토하여 필요한 파일인지 확인해 주세요. >> !TMP1!

:: 결과 표시
type !TMP1!

echo.
echo 스크립트 완료.
