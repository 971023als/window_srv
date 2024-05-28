@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for Log Review and Reporting Status
set "csvFile=!resultDir!\Log_Review_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=로그 관리"
set "code=SRV-115"
set "riskLevel=중"
set "diagnosisItem=로그의 정기적 검토 및 보고 미수행"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-115] 로그의 정기적 검토 및 보고 미수행 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 로그가 정기적으로 검토 및 보고되고 있는 경우 >> "!TMP1!"
echo [취약]: 로그가 정기적으로 검토 및 보고되지 않는 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: Check for the existence of log review and reporting scripts and reports
set "log_review_script=C:\path\to\log\review\script"
set "log_report=C:\path\to\log\report"

if not exist "%log_review_script%" (
    echo WARN: 로그 검토 및 보고 스크립트가 존재하지 않습니다. >> "!TMP1!"
    set "diagnosisResult=로그 검토 스크립트 미발견"
) else (
    echo OK: 로그 검토 및 보고 스크립트가 존재합니다. >> "!TMP1!"
    set "diagnosisResult=로그 검토 스크립트 발견"
)

if not exist "%log_report%" (
    echo WARN: 로그 보고서가 존재하지 않습니다. >> "!TMP1!"
    set "diagnosisResult=!diagnosisResult!, 로그 보고서 미발견"
) else (
    echo OK: 로그 보고서가 존재합니다. >> "!TMP1!"
    set "diagnosisResult=!diagnosisResult!, 로그 보고서 발견"
)

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1%"

echo.
echo Script complete.
endlocal
