@echo off
setlocal

:: 결과 로그 파일 정의
set "TMP1=%~n0.log"
:: 로그 파일 초기화
type NUL > "%TMP1%"

echo ---------------------------------------- >> "%TMP1%"
echo CODE [SRV-148] 웹 서비스 정보 노출 >> "%TMP1%"
echo ---------------------------------------- >> "%TMP1%"
echo [양호]: 웹 서버에서 버전 정보 및 운영체제 정보 노출이 제한된 경우 >> "%TMP1%"
echo [취약]: 웹 서버에서 버전 정보 및 운영체제 정보가 노출되는 경우 >> "%TMP1%"
echo ---------------------------------------- >> "%TMP1%"

:: PowerShell을 사용하여 IIS 웹 서버의 헤더 정보 설정 확인
powershell -Command "& {Import-Module WebAdministration; $removeServerHeader = (Get-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter 'system.webServer/security/requestFiltering/removeServerHeader' -name '.').Value; $xPoweredBy = Get-WebConfiguration '/system.webServer/httpProtocol/customHeaders' -PSPath 'MACHINE/WEBROOT/APPHOST' | Where-Object { $_.name -eq 'X-Powered-By' }; if ($removeServerHeader -eq $true -and $xPoweredBy -eq $null) { echo OK: 서버 헤더 및 X-Powered-By 헤더 노출이 제한됩니다. >> "%TMP1%" } else { echo WARN: 서버 헤더 또는 X-Powered-By 헤더가 노출될 수 있습니다. >> "%TMP1%" } }"

:: 결과 출력
type "%TMP1%"

echo.
echo Script complete.
endlocal
