@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for Telnet service status analysis
set "csvFile=!resultDir!\Telnet_Service_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=네트워크 보안"
set "code=SRV-158"
set "riskLevel=중"
set "diagnosisItem=불필요한 Telnet 서비스 실행"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-158] 불필요한 Telnet 서비스 실행 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: Telnet 서비스가 비활성화되어 있는 경우 >> "!TMP1!"
echo [취약]: Telnet 서비스가 활성화되어 있는 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: Telnet 서비스 상태 확인 (Command 사용)
sc query TlntSvr | find "RUNNING" >nul
if !ERRORLEVEL! == 0 (
    set "diagnosisResult=WARN: Telnet 서비스가 실행 중입니다."
) else (
    set "diagnosisResult=OK: Telnet 서비스가 비활성화되어 있습니다."
)

echo "!diagnosisResult!" >> "!TMP1!"

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

type "!TMP1!"

echo.
endlocal
