@echo off
setlocal

:: 결과 로그 파일 정의
set "TMP1=%~n0.log"
:: 로그 파일 초기화
type NUL > "%TMP1%"

:: 로그 파일에 헤더 정보 추가
echo ---------------------------------------- >> "%TMP1%"
echo CODE [SRV-150] 로컬 로그온 허용 >> "%TMP1%"
echo ---------------------------------------- >> "%TMP1%"

echo [양호]: 웹 서버에서 버전 정보 및 운영체제 정보 노출이 제한된 경우 >> "%TMP1%"
echo [취약]: 웹 서버에서 버전 정보 및 운영체제 정보가 노출되는 경우 >> "%TMP1%"
echo ---------------------------------------- >> "%TMP1%"

:: IIS 서버 설정 확인 (PowerShell을 사용)
powershell -Command "& {Import-Module WebAdministration; if((Get-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter 'system.webServer/security/requestFiltering' -name '.').removeServerHeader -eq $true) {echo OK: 서버 헤더 제거가 활성화되어 있습니다.} else {echo WARN: 서버 헤더 제거가 활성화되어 있지 않습니다.}; if((Get-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter 'system.webServer/httpProtocol/customHeaders' -name '.').collection | Where-Object { $_.name -eq 'X-Powered-By' }) {echo WARN: X-Powered-By 헤더가 노출됩니다.} else {echo OK: X-Powered-By 헤더 노출이 제한됩니다.}}" >> "%TMP1%"

:: 결과 출력
type "%TMP1%"

echo.
echo Script complete.
endlocal
