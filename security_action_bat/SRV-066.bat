@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo CODE [SRV-066] Insufficient DNS Zone Transfer Settings >> "%TMP1%"
echo [Good]: DNS Zone Transfer is securely restricted >> "%TMP1%"
echo [Vulnerable]: DNS Zone Transfer is not adequately restricted >> "%TMP1%"

:: Use PowerShell to check DNS Zone Transfer settings
echo Checking DNS Zone Transfer settings via PowerShell: >> "%TMP1%"
powershell -Command "Get-DnsServerZone | Select-Object ZoneName, ZoneType, IsDsIntegrated, SecureSecondaries | Format-Table -AutoSize" >> "%TMP1%"

:: Note to administrators
echo Note: Review the SecureSecondaries property for each zone. 'None' means zone transfers are not allowed; 'Any' indicates a potential security risk. >> "%TMP1%"

:: Display the results
type "%TMP1%"

echo.
echo Script complete.
