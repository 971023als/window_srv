@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for SNMP service status analysis
set "csvFile=!resultDir!\SNMP_Service_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=서비스 관리"
set "code=SRV-147"
set "riskLevel=중"
set "diagnosisItem=불필요한 SNMP 서비스 실행"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ---------------------------------------- >> "!TMP1!"
echo CODE [SRV-147] 불필요한 SNMP 서비스 실행 >> "!TMP1!"
echo ---------------------------------------- >> "!TMP1!"

echo [양호]: SNMP 서비스가 비활성화되어 있는 경우 >> "!TMP1!"
echo [취약]: SNMP 서비스가 활성화되어 있는 경우 >> "!TMP1!"
echo ---------------------------------------- >> "!TMP1!"

:: SNMP 서비스 상태 확인
sc query SNMP | find "RUNNING" >nul
if %ERRORLEVEL% == 0 (
    set "diagnosisResult=WARN: SNMP 서비스를 사용하고 있습니다."
) else (
    set "diagnosisResult=OK: SNMP 서비스가 비활성화되어 있습니다."
)

echo %diagnosisResult% >> "!TMP1!"
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

type "!TMP1%"

echo.
echo.

endlocal
