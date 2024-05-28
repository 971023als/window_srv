@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for Cron Service Logging Status
set "csvFile=!resultDir!\Cron_Logging_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 로깅"
set "code=SRV-112"
set "riskLevel=중"
set "diagnosisItem=Cron 서비스 로깅 미설정"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-112] Cron 서비스 로깅 미설정 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: Cron 서비스 로깅이 적절하게 설정되어 있는 경우 >> "!TMP1!"
echo [취약]: Cron 서비스 로깅이 적절하게 설정되어 있지 않은 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: Check the presence of log file configuration settings
set "logging_conf=C:\Windows\System32\winevt\Logs"
if not exist "%logging_conf%\TaskScheduler.evtx" (
    echo WARN: Cron 서비스 로그 파일(TaskScheduler.evtx)이 존재하지 않습니다. >> "!TMP1!"
    set "diagnosisResult=로그 파일 미발견"
) else (
    echo OK: Cron 서비스 로그 파일(TaskScheduler.evtx)이 존재합니다. >> "!TMP1!"
    set "diagnosisResult=로그 파일 발견"
)

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1%"

echo.
echo Script complete.
endlocal
