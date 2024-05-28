@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for globally writable files status analysis
set "csvFile=!resultDir!\Globally_Writable_Files_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=파일 시스템 보안"
set "code=SRV-093"
set "riskLevel=높음"
set "diagnosisItem=불필요한 세계 쓰기 가능 파일 존재"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo 코드 [SRV-093] 불필요한 세계 쓰기 가능 파일 존재 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 시스템에 불필요한 세계 쓰기 가능 파일이 없음 >> "!TMP1!"
echo [취약]: 시스템에 불필요한 세계 쓰기 가능 파일이 존재함 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: 검사할 디렉토리 지정 - 필요에 따라 조정해야 함
set "checkDir=C:\Path\To\Check"

:: icacls를 사용하여 권한을 확인. "Everyone:(F)"가 있는지 확인하여 전체 제어를 나타냄.
icacls "%checkDir%\*.*" /T | findstr "Everyone:(F)" > nul

if !errorlevel! equ 1 (
    set "diagnosisResult=OK: 시스템에 과도하게 허용적인 파일을 찾지 못함."
    echo !diagnosisResult! >> "!TMP1!"
) else (
    set "diagnosisResult=경고: 과도하게 허용적인 파일이 발견됨."
    echo !diagnosisResult! >> "!TMP1!"
)

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
echo 스크립트 완료.
endlocal
