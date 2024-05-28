@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for C compiler presence and permissions analysis
set "csvFile=!resultDir!\C_Compiler_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 보안"
set "code=SRV-087"
set "riskLevel=중"
set "diagnosisItem=C 컴파일러 존재 및 권한 설정"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo 코드 [SRV-087] C 컴파일러 존재 및 권한 설정 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: C 컴파일러가 존재하지 않거나 적절한 권한으로 설정됨 >> "!TMP1!"
echo [취약]: C 컴파일러가 존재하며 권한 설정이 부적절함 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: C 컴파일러(gcc) 존재 여부 확인
where gcc >nul 2>&1
if %errorlevel% equ 0 (
    set "diagnosisResult=WARN: 시스템에 C 컴파일러(gcc)가 설치되어 있습니다. 권한 설정 확인이 필요할 수 있습니다."
    echo !diagnosisResult! >> "!TMP1!"
) else (
    set "diagnosisResult=OK: 시스템에 C 컴파일러(gcc)가 설치되어 있지 않습니다."
    echo !diagnosisResult! >> "!TMP1!"
)

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
echo 스크립트 완료.
endlocal
