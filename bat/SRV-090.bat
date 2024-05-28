@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for Remote Registry service status analysis
set "csvFile=!resultDir!\Remote_Registry_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 보안"
set "code=SRV-090"
set "riskLevel=높음"
set "diagnosisItem=원격 레지스트리 서비스 활성화 검사"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo 코드 [SRV-090] 불필요한 원격 레지스트리 서비스 활성화 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 원격 레지스트리 서비스가 비활성화됨 >> "!TMP1!"
echo [취약]: 원격 레지스트리 서비스가 활성화됨 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: 원격 레지스트리 서비스의 상태 확인
sc query RemoteRegistry | findstr /C:"STATE" > temp_status.txt
findstr /C:"RUNNING" temp_status.txt > nul

if !errorlevel! equ 0 (
    set "diagnosisResult=WARN: 원격 레지스트리 서비스가 활성화되어 있습니다."
    echo !diagnosisResult! >> "!TMP1!"
) else (
    set "diagnosisResult=OK: 원격 레지스트리 서비스가 비활성화되어 있습니다."
    echo !diagnosisResult! >> "!TMP1!"
)

del temp_status.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
echo 스크립트 완료.
endlocal
