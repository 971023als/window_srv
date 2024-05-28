@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for web service process privilege checks
set "csvFile=!resultDir!\Web_Service_Privilege_Check.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service Name,Service Account,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=웹 보안"
set "code=SRV-045"
set "riskLevel=중"
set "diagnosisItem=웹 서비스 프로세스 권한 제한 검사"
set "serviceName=Apache2.4"  REM Example service name for Apache, change as necessary
set "serviceAccount="
set "diagnosisResult="
set "status="

REM Setup log file
set "TMP1=!resultDir!\%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo 코드 [SRV-045] 웹 서비스 프로세스 권한 제한 미비 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"
echo [양호]: 웹 서비스 프로세스가 과도한 권한으로 실행되지 않음 >> "!TMP1!"
echo [취약]: 웹 서비스 프로세스가 과도한 권한으로 실행됨 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: Check under which account the service is running
for /f "tokens=2 delims=: " %%a in ('sc qc "%serviceName%" ^| findstr /C:"SERVICE_START_NAME"') do (
    set "serviceAccount=%%a"
)

:: Assuming manual review is required to determine if privileges are excessive
set "diagnosisResult=Manual review required"
set "status=Review Required"
echo SERVICE_START_NAME: !serviceAccount! >> "!TMP1!"

:: Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!serviceName!","!serviceAccount!","!diagnosisResult!","!status!" >> "!csvFile!"

:: Display the results
type "!TMP1!"

echo.
echo 스크립트 완료.

endlocal
