@echo off
setlocal

set "TMP1=%SCRIPTNAME%.log"
> "%TMP1%"

echo 코드 [SRV-057] 웹 서비스 경로 내 접근 통제 미흡 >> "%TMP1%"
echo [양호]: 웹 서비스 경로 내 파일에 대한 접근 권한이 적절하게 설정됨 >> "%TMP1%"
echo [취약]: 웹 서비스 경로 내 파일에 대한 접근 권한이 적절하게 설정되지 않음 >> "%TMP1%"

:: 웹 서비스 경로 설정 (실제 경로에 맞게 조정하세요)
set "WEB_SERVICE_PATH=C:\Path\To\Web\Service"

:: 웹 서비스 경로 내 파일의 권한 목록
echo %WEB_SERVICE_PATH% 내 파일에 대한 권한 목록: >> "%TMP1%"
for /R "%WEB_SERVICE_PATH%" %%G in (*.*) do (
    icacls "%%G" >> "%TMP1%"
)

:: 관리자에게의 주의 사항
echo 주의: 나열된 권한을 수동으로 검토하여 적절하게 설정되었는지 확인해 주세요. >> "%TMP1%"

:: 결과 표시
type "%TMP1%"

echo.
echo 스크립트 완료.
