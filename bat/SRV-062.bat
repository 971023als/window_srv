@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for DNS service audit
set "csvFile=!resultDir!\DNS_Service_Audit.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Server Name,Zone Transfer,Version Query,Diagnosis Result" > "!csvFile!"

REM Define security details
set "category=DNS 보안"
set "code=SRV-062"
set "riskLevel=중"
set "diagnosisItem=DNS 서비스 정보 노출"
set "diagnosisResult="
set "status="

REM Setup log file
set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo 코드 [SRV-062] DNS 서비스 정보 노출 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"
echo [양호]: DNS 서비스 정보가 안전하게 보호됨 >> "!TMP1!"
echo [취약]: DNS 서비스 정보가 노출됨 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: Check DNS version hiding and unnecessary zone transfer using PowerShell
powershell -Command "& {
    Import-Module DNSServer;
    $dnsServers = Get-DnsServer
    foreach ($server in $dnsServers) {
        $zoneTransfers = Get-DnsServerZoneTransfer -ComputerName $server.Name
        $hideVersion = Get-DnsServerSetting -ComputerName $server.Name | Select-Object -ExpandProperty DisableVersionQuery

        $versionQueryResult = if ($hideVersion -eq $true) {'Protected'} else {'Exposed'}
        $zoneTransferResult = if ($zoneTransfers.AllowZoneTransfer -eq 'None') {'Restricted'} else {'Allowed'}
        
        $diagnosisResult = \"$server.Name,$zoneTransfers.AllowZoneTransfer,$versionQueryResult,$zoneTransferResult\"
        echo \"!category!\",\"!code!\",\"!riskLevel!\",\"!diagnosisItem!\",\"$server.Name\",\"$zoneTransferResult\",\"$versionQueryResult\",\"$diagnosisResult\" >> \"!csvFile!\"
    }
}" >> "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
echo 스크립트 완료.
endlocal
