set "category=시스템 관리"
set "code=SRV-149"
set "riskLevel=상"
set "diagnosisItem=디스크 볼륨 암호화 미적용"
set "diagnosisResult="
set "status="

@echo off
setlocal

:: 결과 로그 파일 정의
set "TMP1=%~n0.log"
:: 로그 파일 초기화
type NUL > "%TMP1%"

echo ------------------------------------------------ >> "%TMP1%"
echo CODE [SRV-148] 웹 서비스 정보 노출 >> "%TMP1%"
echo ------------------------------------------------ >> "%TMP1%"
echo [양호]: 웹 서버에서 버전 정보 및 운영체제 정보 노출이 제한된 경우 >> "%TMP1%"
echo [취약]: 웹 서버에서 버전 정보 및 운영체제 정보가 노출되는 경우 >> "%TMP1%"
echo ------------------------------------------------ >> "%TMP1%"

:: IIS 서버 설정 확인 (PowerShell을 사용하여 IIS 설정을 직접 확인)
powershell -Command "& {
    Import-Module WebAdministration;
    $customHeaders = Get-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter 'system.webServer/httpProtocol/customHeaders' -name '.';
    
    $serverHeader = $customHeaders.collection | Where-Object { $_.name -eq 'Server' };
    $xPoweredByHeader = $customHeaders.collection | Where-Object { $_.name -eq 'X-Powered-By' };
    
    if ($serverHeader -and $xPoweredByHeader) {
        echo WARN: 서버 버전 정보 및 운영체제 정보가 노출될 수 있습니다. >> "%TMP1%";
    } else {
        echo OK: 서버 버전 정보 및 운영체제 정보의 노출이 제한되었습니다. >> "%TMP1%";
    }
}" >> "%TMP1%"

:: 결과 출력
type "%TMP1%"

echo.
echo Script complete.
endlocal
