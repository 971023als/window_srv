@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for core system file permission analysis
set "csvFile=!resultDir!\System_File_Permission_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 보안"
set "code=SRV-084"
set "riskLevel=높음"
set "diagnosisItem=시스템 핵심 파일 권한 설정"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo 코드 [SRV-084] 시스템 핵심 파일 권한 설정 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 시스템 핵심 파일이 적절한 권한으로 설정됨 >> "!TMP1!"
echo [취약]: 시스템 핵심 파일이 적절한 권한으로 설정되지 않음 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: PATH 환경 변수에서 잠재적으로 안전하지 않은 항목 검사
echo PATH에서 안전하지 않은 항목 검사 중 >> "!TMP1!"
set "insecure=0"

for %%A in (%PATH:;= %) do (
    if "%%A"=="." (
        set /a insecure+=1
        echo 경고: PATH에 "."이 포함되어 있어 안전하지 않을 수 있음 >> "!TMP1%"
    )
)

if !insecure! equ 0 (
    echo OK: PATH에 안전하지 않은 항목이 포함되지 않음 >> "!TMP1%"
) else (
    echo 경고: PATH에 안전하지 않은 항목이 포함됨 >> "!TMP1%"
)

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
echo 스크립트 완료.
endlocal
