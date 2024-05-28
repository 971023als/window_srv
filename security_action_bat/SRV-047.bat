@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo 코드 [SRV-047] 웹 서비스 경로 내 불필요한 링크 파일 존재 >> "%TMP1%"
echo [양호]: 웹 서비스 경로 내 불필요한 심볼릭 링크 파일이 존재하지 않음 >> "%TMP1%"
echo [취약]: 웹 서비스 경로 내 불필요한 심볼릭 링크 파일이 존재함 >> "%TMP1%"

:: IIS 웹 서비스 경로 설정 (실제 경로에 맞게 조정하세요)
set "IIS_WEB_SERVICE_PATH=C:\inetpub\wwwroot"

:: IIS 웹 서비스 경로 내 심볼릭 링크(.lnk 및 기타 링크 파일) 검색
echo %IIS_WEB_SERVICE_PATH% 내 심볼릭 링크 파일 검사 중: >> "%TMP1%"
dir "%IIS_WEB_SERVICE_PATH%\*.lnk" /s /b >> "%TMP1%"
dir "%IIS_WEB_SERVICE_PATH%\*.url" /s /b >> "%TMP1%"

:: 관리자에게의 주의사항
echo 주의: 이 스크립트는 .lnk 및 .url 바로가기 파일을 나열합니다. 수동으로 검토하여 필요한 파일인지 확인해 주세요. >> "%TMP1%"

:: 결과 표시
type "%TMP1%"

echo.
echo 스크립트 완료.
