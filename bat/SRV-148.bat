@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for web service information exposure analysis
set "csvFile=!resultDir!\Web_Service_Info_Exposure.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=웹 서비스 보안"
set "code=SRV-148"
set "riskLevel=중"
set "diagnosisItem=웹 서비스 정보 노출"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ---------------------------------------- >> "!TMP1!"
echo CODE [SRV-148] 웹 서비스 정보 노출 >> "!TMP1!"
echo ---------------------------------------- >> "!TMP1!"
echo [양호]: 웹 서버에서 버전 정보 및 운영체제 정보 노출이 제한된 경우 >> "!TMP1!"
echo [취약]: 웹 서버에서 버전 정보 및 운영체제 정보가 노출되는 경우 >> "!TMP1!"
echo ---------------------------------------- >> "!TMP1!"

:: PowerShell을 사용하여 IIS 웹 서버의 헤더 정보 설정 확인
powershell -Command "& {
    Import-Module WebAdministration;
    $removeServerHeader = (Get-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST' -filter 'system.webServer/security/requestFiltering/removeServerHeader' -name '.').Value;
    $xPoweredBy = Get-WebConfiguration '/system.webServer/httpProtocol/customHeaders' -PSPath 'MACHINE/WEBROOT/APPHOST' | Where-Object { $_.name -eq 'X-Powered-By' };
    if ($removeServerHeader -eq $true -and $xPoweredBy -eq $null) {
        $diagnosisResult = 'OK: 서버 헤더 및 X-Powered-By 헤더 노출이 제한됩니다.'
    } else {
        $diagnosisResult = 'WARN: 서버 헤더 또는 X-Powered-By 헤더가 노출될 수 있습니다.'
    }
    \"$diagnosisResult\" | Out-File -FilePath temp.txt;
}"
set /p diagnosisResult=<temp.txt
del temp.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

type "!TMP1%"

echo.
echo Script complete.
endlocal
