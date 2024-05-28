@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for Startup Program Analysis
set "csvFile=!resultDir!\Startup_Program_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 최적화"
set "code=SRV-105"
set "riskLevel=낮음"
set "diagnosisItem=불필요한 시작프로그램 존재"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-105] 불필요한 시작프로그램 존재 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 불필요한 시작 프로그램이 존재하지 않는 경우 >> "!TMP1!"
echo [취약]: 불필요한 시작 프로그램이 존재하는 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: 시스템 시작 시 실행되는 프로그램 목록 확인
for /f "tokens=*" %%i in ('wmic startup get caption, command /format:list') do (
  set "service=%%i"
  if not "!service!"=="" (
    echo Checking startup program: !service! >> "!TMP1!"
    REM Add logic here to check against a list of necessary services, for example:
    REM if "!service!"=="UnnecessaryService" echo Unnecessary startup program: !service! >> "!TMP1%"
  )
)

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1%"

echo.
echo Script complete.
endlocal
