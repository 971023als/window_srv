@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for password policy audit
set "csvFile=!resultDir!\Password_Policy_Audit.csv"
echo "Category,Policy,Value,Status,Comments" > "!csvFile!"

REM Define security details
set "category=네트워크 보안"
set "code=SRV-067"
set "riskLevel=높음"
set "diagnosisItem=암호 정책 검사"
set "service=Security Policy"
set "diagnosisResult="
set "status="

set "logFile=%~n0.log"
type nul > "!logFile!"

echo ------------------------------------------------ >> "!logFile!"
echo CODE [SRV-067] 암호 정책 취약성 검사 >> "!logFile!"
echo ------------------------------------------------ >> "!logFile!"

echo [Good]: Password policy is compliant >> "!logFile!"
echo [Vulnerable]: Password policy is not compliant >> "!logFile!"
echo ------------------------------------------------ >> "!logFile!"

REM Setup PowerShell script
set "psScript=!resultDir!\check_password_policies.ps1"
(
    echo $PasswordPolicies = @(
    echo    "MinimumPasswordLength",
    echo    "PasswordComplexity",
    echo    "MaximumPasswordAge",
    echo    "MinimumPasswordAge"
    echo )
    echo 
    echo foreach `($policy in $PasswordPolicies`) {
    echo    `$secpol = secedit /export /cfg secpol.cfg
    echo    `$policyValue = `(Get-Content -Path .\secpol.cfg | Select-String `$policy`).ToString().Split('=')[1].Trim()
    echo    `$compliance = if (`$policyValue -gt 0) {'Compliant'} else {'Non-Compliant'}
    echo    Write-Output "`$policy,`$policyValue,`$compliance"
    echo }
    echo 
    echo Remove-Item -Path .\secpol.cfg -Force
) > "%psScript%"

REM Execute PowerShell script and save output to CSV
powershell -ExecutionPolicy Bypass -File "%psScript%" >> "!csvFile!"

REM Display results
type "!csvFile!"

echo.
echo Script complete.
endlocal
