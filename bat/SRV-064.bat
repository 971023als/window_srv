@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for DNS version audit
set "csvFile=!resultDir!\DNS_Version_Audit.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Server Version,Result" > "!csvFile!"

REM Define security details
set "category=DNS 보안"
set "code=SRV-064"
set "riskLevel=중"
set "diagnosisItem=DNS 서버 버전 검사"
set "diagnosisResult="
set "status="

REM Setup log file
set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo 코드 [SRV-064] DNS 서버 버전 검사 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"
echo [양호]: DNS 서비스가 최신 버전으로 업데이트되어 있습니다. >> "!TMP1!"
echo [취약]: DNS 서비스가 최신 버전으로 업데이트되어 있지 않습니다. >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

REM Setup PowerShell script
set "psScript=%TEMP%\dns_version_check.ps1"
(
    echo $dnsServer = Get-WmiObject -Namespace "root\MicrosoftDNS" -Class "MicrosoftDNS_Server"
    echo if ($dnsServer) {
    echo    $version = $dnsServer.Version
    echo    Write-Output "DNS 서버 버전: $version"
    echo    if ($version -ge "버전_번호") {
    echo        Write-Output "양호: DNS 서비스가 최신 버전으로 업데이트되어 있습니다."
    echo    } else {
    echo        Write-Output "취약: DNS 서비스가 최신 버전으로 업데이트되어 있지 않습니다."
    echo    }
    echo } else {
    echo    Write-Output "DNS 서비스 정보를 찾을 수 없습니다."
    echo }
) > "%psScript%"

REM Execute PowerShell script and save output to log
set "logFile=!resultDir!\DNS_Version_Audit_Log.txt"
powershell -ExecutionPolicy Bypass -File "%psScript%" > "!logFile!"

REM Read result and write to CSV
for /F "tokens=*" %%i in ('type "!logFile!"') do (
    set "output=%%i"
    setlocal enabledelayedexpansion
    echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!output!" >> "!csvFile!"
    endlocal
)

REM Cleanup
del "%psScript%"

REM Display results
echo ------------------------------------------------ >> "!TMP1!"
type "!logFile!" >> "!TMP1!"
type "!TMP1!"
echo.
echo 스크립트 완료.

endlocal
