@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for Security Audit Policy Status
set "csvFile=!resultDir!\Security_Audit_Policy_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 보안"
set "code=SRV-116"
set "riskLevel=고"
set "diagnosisItem=보안 감사를 수행할 수 없는 경우, 즉시 시스템 종료 설정 미흡"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-116] “보안 감사를 수행할 수 없는 경우, 즉시 시스템 종료” 기능 설정 미흡 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 보안 감사 실패 시 시스템이 즉시 종료되도록 설정된 경우 >> "!TMP1!"
echo [취약]: 보안 감사 실패 시 시스템이 즉시 종료되지 않도록 설정된 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: Check the security policy setting via PowerShell
powershell -Command "& {
    $regPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa';
    $crashOnAuditFail = (Get-ItemProperty -Path $regPath -Name 'CrashOnAuditFail').CrashOnAuditFail;
    if ($crashOnAuditFail -eq 1) {
        echo OK: 보안 감사 실패 시 시스템이 즉시 종료되도록 설정되어 있습니다. >> '!TMP1!'
        set 'diagnosisResult=설정 적절'
    } else {
        echo WARN: 보안 감사 실패 시 시스템이 즉시 종료되지 않도록 설정되어 있습니다. >> '!TMP1!'
        set 'diagnosisResult=설정 미흡'
    }
}"

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1%"

echo.
echo Script complete.
endlocal
