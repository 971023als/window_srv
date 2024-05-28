@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for Scheduled Task Analysis
set "csvFile=!resultDir!\Scheduled_Task_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 유지 관리"
set "code=SRV-101"
set "riskLevel=낮음"
set "diagnosisItem=불필요한 예약된 작업 존재"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo 코드 [SRV-101] 불필요한 예약된 작업 존재 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 불필요한 cron 작업이 존재하지 않는 경우 >> "!TMP1!"
echo [취약]: 불필요한 cron 작업이 존재하는 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: 시스템의 모든 예약된 작업을 검사합니다
for /f "tokens=*" %%i in ('schtasks /query /fo LIST ^| findstr "TaskName"') do (
    echo Task found: %%i >> "!TMP1%"
    REM Here you might add logic to check if the task is necessary or not
    REM Example: if %%i==specificTaskName echo Unnecessary task found: %%i >> "!TMP1%"
)

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
echo 스크립트 완료.
endlocal
