@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for DNS service status analysis
set "csvFile=!resultDir!\DNS_Service_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=네트워크 보안"
set "code=SRV-173"
set "riskLevel=중"
set "diagnosisItem=DNS 서비스의 취약한 동적 업데이트 설정"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-173] DNS 서비스의 취약한 동적 업데이트 설정 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: DNS 동적 업데이트가 안전하게 구성된 경우 >> "!TMP1!"
echo [취약]: DNS 동적 업데이트가 취약하게 구성된 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: DNS 설정 확인 (PowerShell 사용)
powershell -Command "& {
    Import-Module DNSServer;
    $dnsZones = Get-DnsServerZone;
    $vulnerableZones = $dnsZones | Where-Object { $_.IsDsIntegrated -eq $false -and $_.DynamicUpdate -ne 'None' };
    if ($vulnerableZones) {
        $status = 'WARN: DNS 동적 업데이트 설정이 취약합니다: ' + ($vulnerableZones | ForEach-Object { $_.ZoneName }) -join ', ';
    } else {
        $status = 'OK: DNS 동적 업데이트가 안전하게 구성되어 있습니다.'
    }
    \"$status\" | Out-File -FilePath temp.txt;
}"
set /p diagnosisResult=<temp.txt
del temp.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.

endlocal
