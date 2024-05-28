@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for DNS Zone Transfer audit
set "csvFile=!resultDir!\DNS_Zone_Transfer_Audit.csv"
echo "Zone Name,Zone Type,Directory Integrated,Zone Transfer Security,Comments" > "!csvFile!"

REM Define security details
set "category=네트워크 보안"
set "code=SRV-066"
set "riskLevel=중"
set "diagnosisItem=DNS Zone 전송 설정 검사"
set "diagnosisResult="
set "status="

set "logFile=%~n0.log"
type nul > "!logFile!"

echo ------------------------------------------------ >> "!logFile!"
echo CODE [SRV-066] Insufficient DNS Zone Transfer Settings >> "!logFile!"
echo ------------------------------------------------ >> "!logFile!"

echo [Good]: DNS Zone Transfer is securely restricted >> "!logFile!"
echo [Vulnerable]: DNS Zone Transfer is not adequately restricted >> "!logFile!"
echo ------------------------------------------------ >> "!logFile!"

:: Use PowerShell to check DNS Zone Transfer settings and export to CSV
powershell -Command "& {
    Import-Module DNSServer;
    $zones = Get-DnsServerZone | Select-Object ZoneName, ZoneType, IsDsIntegrated, SecureSecondaries;
    foreach ($zone in $zones) {
        $secSetting = if ($zone.SecureSecondaries -eq 'None') {'Securely Restricted'} elseif ($zone.SecureSecondaries -eq 'Any') {'Not Adequately Restricted'} else {$zone.SecureSecondaries};
        $comments = if ($zone.SecureSecondaries -eq 'Any') {'Potential security risk'} else {'No issues detected'};
        $diagnosisResult = \"$secSetting - $comments\";
        echo \"$zone.ZoneName\",\"$zone.ZoneType\",\"$zone.IsDsIntegrated\",\"$secSetting\",\"$comments\" >> "!csvFile!";
        echo \"$zone.ZoneName - $secSetting ($comments)\" >> "!logFile!";
    }
}"

:: Note to administrators in log file
echo Note: Review the SecureSecondaries property for each zone. 'None' means zone transfers are not allowed; 'Any' indicates a potential security risk. >> "!logFile!"

:: Display the results
type "!logFile!"

echo.
echo Script complete.
endlocal
