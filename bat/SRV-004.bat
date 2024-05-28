@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for SMTP service analysis
set "csvFile=!resultDir!\SMTP_Service_Analysis.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 관리"
set "code=SRV-004"
set "riskLevel=중"
set "diagnosisItem=SMTP 서비스 상태 검사"
set "diagnosisResult="
set "status="

:: Windows에서 SMTP 서비스 (예: Simple Mail Transfer Protocol) 실행 여부 확인
sc query "SMTPSVC" | find /i "RUNNING" > nul
if not errorlevel 1 (
    set "diagnosisResult=SMTP 서비스가 실행 중입니다."
    set "status=취약: 필요하지 않음에도 실행 중"
) else (
    set "diagnosisResult=SMTP 서비스가 비활성화되어 있거나 실행 중이지 않습니다."
    set "status=양호"
)

:: SMTP 포트 25 상태 확인
netstat -an | find ":25 " > nul
if not errorlevel 1 (
    set "diagnosisResult=!diagnosisResult! SMTP 포트(25)가 열려 있습니다. 불필요한 서비스가 실행 중일 수 있습니다."
    set "status=취약: 포트 열림"
) else (
    set "diagnosisResult=!diagnosisResult! SMTP 포트(25)는 닫혀 있습니다."
    set "status=!status! 포트 닫힘"
)

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!diagnosisResult!","!status!" >> "!csvFile!"

REM Display the CSV content
type "!csvFile!"
echo

endlocal
