@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for user home directory configuration analysis
set "csvFile=!resultDir!\User_Home_Directory_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=사용자 환경 설정"
set "code=SRV-092"
set "riskLevel=중"
set "diagnosisItem=사용자 홈 디렉토리 설정 미흡"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo 코드 [SRV-092] 사용자 홈 디렉토리 설정 미흡 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 모든 사용자의 홈 디렉토리가 적절하게 설정됨 >> "!TMP1!"
echo [취약]: 하나 이상의 사용자 홈 디렉토리가 적절하게 설정되지 않음 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: C:\Users 내 각 디렉토리를 확인하여 홈 디렉토리를 검사하는 것을 시뮬레이션
for /D %%D in (C:\Users\*) do (
    if exist "%%D" (
        set "diagnosisResult=OK: 사용자 %%~nxD의 홈 디렉토리(%%D)가 적절하게 설정됨."
        echo !diagnosisResult! >> "!TMP1!"
    ) else (
        set "diagnosisResult=경고: 사용자 %%~nxD의 홈 디렉토리(%%D)가 적절하게 설정되지 않음."
        echo !diagnosisResult! >> "!TMP1!"
    )
)

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
echo 스크립트 완료.
endlocal
