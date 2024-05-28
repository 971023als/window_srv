@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for Log Management Status Analysis
set "csvFile=!resultDir!\Log_Management_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 로깅"
set "code=SRV-108"
set "riskLevel=중"
set "diagnosisItem=로그에 대한 접근통제 및 관리 미흡"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-108] 로그에 대한 접근통제 및 관리 미흡 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 로그 파일의 접근 통제 및 관리가 적절하게 설정되어 있는 경우 >> "!TMP1!"
echo [취약]: 로그 파일의 접근 통제 및 관리가 적절하게 설정되어 있지 않은 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: 로그 설정 파일 경로 설정
set "filename=C:\Windows\System32\winevt\Logs\System.evtx"

if exist "%filename%" (
    echo OK: "%filename% 가 존재합니다." >> "!TMP1!"
    REM Here you could add logic with PowerShell or another tool to verify access controls
    echo Info: 로그 파일 접근 권한 및 관리 상태 확인이 필요합니다. >> "!TMP1!"
) else (
    echo WARN: "%filename% 가 존재하지 않습니다." >> "!TMP1!"
)

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1%"

echo.
echo Script complete.
endlocal
