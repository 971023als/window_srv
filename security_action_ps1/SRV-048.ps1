@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo 코드 [SRV-048] 불필요한 웹 서비스 실행 조치 스크립트 >> "%TMP1%"
echo -------------------------------------------------- >> "%TMP1%"

:: IIS 웹 서비스 중지
powershell -Command "& {Stop-Service -Name 'W3SVC' -Force; echo IIS 웹 서비스를 중지했습니다. >> '%TMP1%'}"

:: 기본 웹사이트 제거
powershell -Command "& {Import-Module WebAdministration; Remove-WebSite -Name 'Default Web Site'; echo 'Default Web Site'를 제거했습니다. >> '%TMP1%'}"

:: 사용되지 않는 IIS 기능 확인 및 제거 지침 제공
echo 사용되지 않는 IIS 기능이 있는 경우, Windows 기능 제거를 통해 수동으로 제거하세요. >> "%TMP1%"

:: 결과 표시 및 로그 파일 삭제
type "%TMP1%"

echo.
echo 스크립트 완료. 로그 파일을 확인하세요.

:: 로그 파일 삭제 (선택적)
del "%TMP1%"
