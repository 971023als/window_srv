@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for local logon policy analysis
set "csvFile=!resultDir!\Local_Logon_Policy_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 접근 보안"
set "code=SRV-150"
set "riskLevel=중"
set "diagnosisItem=로컬 로그온 허용"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ---------------------------------------- >> "!TMP1%"
echo CODE [SRV-150] 로컬 로그온 허용 >> "!TMP1%"
echo ---------------------------------------- >> "!TMP1%"
echo [양호]: 로컬 로그온이 비활성화된 경우 >> "!TMP1%"
echo [취약]: 로컬 로그온이 활성화된 경우 >> "!TMP1%"
echo ---------------------------------------- >> "!TMP1%"

:: 로컬 로그온 정책 상태 확인 (PowerShell 사용)
powershell -Command "& {
    $secpol = secedit /export /cfg tempsec.cfg
    $policyStatus = Select-String -Path tempsec.cfg -Pattern 'SeDenyInteractiveLogonRight'
    if ($policyStatus) {
        $status = 'OK: 로컬 로그온이 비활성화되어 있습니다.'
    } else {
        $status = 'WARN: 로컬 로그온이 활성화되어 있습니다.'
    }
    del tempsec.cfg
    \"$status\" | Out-File -FilePath temp.txt;
}"
set /p diagnosisResult=<temp.txt
del temp.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ---------------------------------------- >> "!TMP1%"
type "!TMP1%"

echo.

endlocal
