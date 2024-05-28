@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for system resource ownership analysis
set "csvFile=!resultDir!\System_Resource_Ownership_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 보안"
set "code=SRV-139"
set "riskLevel=높음"
set "diagnosisItem=시스템 자원 소유권 변경 권한 설정"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-139] 시스템 자원 소유권 변경 권한 설정 미흡 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 중요 시스템 자원의 소유권 변경 권한이 제한되어 있는 경우 >> "!TMP1!"
echo [취약]: 중요 시스템 자원의 소유권 변경 권한이 제한되어 있지 않은 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: 파일 권한 확인 (예: C:\Windows\System32)
set "targetPath=C:\Windows\System32"

icacls "%targetPath%" > "permissions.txt"
set /p diagnosisResult=<permissions.txt
del permissions.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.

endlocal
