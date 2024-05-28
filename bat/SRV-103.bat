@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for LAN Manager authentication level analysis
set "csvFile=!resultDir!\LAN_Manager_Auth_Level.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=보안 설정"
set "code=SRV-103"
set "riskLevel=중"
set "diagnosisItem=LAN Manager 인증 수준 미흡"
set "service=시스템 보안"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-103] LAN Manager 인증 수준 미흡 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: LAN Manager 인증 수준이 적절하게 설정되어 있는 경우 >> "!TMP1!"
echo [취약]: LAN Manager 인증 수준이 미흡하게 설정되어 있는 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: LAN Manager 인증 수준을 확인하는 PowerShell 스크립트
powershell -Command "& {
    $regPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa';
    $lmCompatibilityLevel = (Get-ItemProperty -Path $regPath -Name 'lmCompatibilityLevel').lmCompatibilityLevel;
    if ($lmCompatibilityLevel -ge 3) {
        \"$status = 'OK: LAN Manager 인증 수준이 적절하게 설정되어 있습니다.'\" | Out-File -FilePath temp.txt;
    } else {
        \"$status = 'WARN: LAN Manager 인증 수준이 미흡하게 설정되어 있습니다.'\" | Out-File -FilePath temp.txt;
    }
}"
set /p diagnosisResult=<temp.txt
del temp.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1%"

echo.
echo Script complete.
endlocal
