@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for DNS service status analysis
set "csvFile=!resultDir!\DNS_Service_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=네트워크 보안"
set "code=SRV-174"
set "riskLevel=중"
set "diagnosisItem=DNS 서비스 실행 상태 검사"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-174] 불필요한 DNS 서비스 실행 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: DNS 서비스가 비활성화 되어 있는 경우 >> "!TMP1!"
echo [취약]: DNS 서비스가 활성화 되어 있는 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: DNS 서비스 상태 확인 (Dnscache 서비스를 예로 사용)
sc query Dnscache | find "RUNNING" > NUL
if %ERRORLEVEL% == 0 (
    set "diagnosisResult=WARN: DNS 서비스(Dnscache)가 활성화되어 있습니다."
) else (
    set "diagnosisResult=OK: DNS 서비스(Dnscache)가 비활성화되어 있습니다."
)

:: 결과 저장
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.

endlocal
