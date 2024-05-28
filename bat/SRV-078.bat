@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for guest account status analysis
set "csvFile=!resultDir!\Guest_Account_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=계정 보안"
set "code=SRV-078"
set "riskLevel=낮"
set "diagnosisItem=게스트 계정 활성화 상태 검사"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo 코드 [SRV-078] 불필요한 게스트 계정 활성화 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 불필요한 게스트 계정이 비활성화됨 >> "!TMP1!"
echo [취약]: 불필요한 게스트 계정이 활성화됨 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: 게스트 계정의 상태 확인
net user 게스트 | findstr /C:"계정 활성 상태" > temp.txt
set /p diagnosisResult=<temp.txt
del temp.txt

echo 관리자 그룹 내 불필요한 계정을 확인하려면, 'net localgroup 관리자'의 출력을 수동으로 검토하세요 >> "!TMP1!"

:: Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.

endlocal
