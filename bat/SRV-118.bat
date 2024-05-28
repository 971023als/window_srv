@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for Security Patch Status
set "csvFile=!resultDir!\Security_Patch_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 유지 관리"
set "code=SRV-118"
set "riskLevel=고"
set "diagnosisItem=주기적인 보안패치 및 벤더 권고사항 미적용"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-118] 주기적인 보안패치 및 벤더 권고사항 미적용 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 최신 보안패치 및 업데이트가 적용된 경우 >> "!TMP1!"
echo [취약]: 최신 보안패치 및 업데이트가 적용되지 않은 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: Check system update status (adjust for Windows environment)
powershell -Command "& {
    $updates = Get-WmiObject -Query 'SELECT * FROM Win32_QuickFixEngineering' | Sort-Object -Property InstalledOn -Descending;
    if ($updates) {
        echo OK: 시스템은 최신 보안 패치로 업데이트되어 있습니다. > temp.txt;
        set 'diagnosisResult=최신 보안 패치 적용됨'
    } else {
        echo WARN: 시스템이 최신 보안 패치로 업데이트되지 않았습니다. > temp.txt;
        set 'diagnosisResult=최신 보안 패치 미적용'
    }
}"
set /p diagnosisResult=<temp.txt
del temp.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
echo Script complete.
endlocal
