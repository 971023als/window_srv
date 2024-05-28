@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for Event Log Configuration Status
set "csvFile=!resultDir!\Event_Log_Config_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 로깅"
set "code=SRV-109"
set "riskLevel=중"
set "diagnosisItem=시스템 주요 이벤트 로그 설정 미흡"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-109] 시스템 주요 이벤트 로그 설정 미흡 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 주요 이벤트 로그 설정이 적절하게 구성되어 있는 경우 >> "!TMP1!"
echo [취약]: 주요 이벤트 로그 설정이 적절하게 구성되어 있지 않은 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: Checking the configuration of the event log settings
powershell -Command "& {
    $logProperties = Get-WinEvent -ListLog 'Application, Security, System';
    foreach ($log in $logProperties) {
        if ($log.IsEnabled -and $log.LogMode -eq 'Circular') {
            echo OK: '$($log.LogName)' 로그가 적절하게 설정되어 있습니다. >> '!TMP1!'
        } else {
            echo WARN: '$($log.LogName)' 로그 설정이 적절하지 않습니다. >> '!TMP1!'
        }
    }
}"

REM Save results to CSV
set /p diagnosisResult=<"%TMP1%"
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1%"

echo.
echo Script complete.
endlocal
