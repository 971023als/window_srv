@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for unnecessary file existence check
set "csvFile=!resultDir!\Unnecessary_File_Check.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 관리"
set "code=SRV-144"
set "riskLevel=상"
set "diagnosisItem=dev 경로에 불필요한 파일 존재"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ---------------------------------------- >> "!TMP1!"
echo CODE [SRV-144] 불필요한 파일 존재 여부 확인 >> "!TMP1!"
echo ---------------------------------------- >> "!TMP1!"

echo [양호]: 지정된 경로에 불필요한 파일이 존재하지 않는 경우 >> "!TMP1!"
echo [취약]: 지정된 경로에 불필요한 파일이 존재하는 경우 >> "!TMP1!"
echo ---------------------------------------- >> "!TMP1!"

:: 파일 수 확인 (예: C:\Windows\Temp 내의 파일)
set "targetDir=C:\Windows\Temp"
set /a fileCount=0

for /f %%a in ('dir /a-d /b "%targetDir%" 2^>nul ^| find /c /v ""') do set /a fileCount=%%a

if %fileCount% gtr 0 (
    set diagnosisResult=WARN: %targetDir% 디렉터리에 %fileCount%개의 불필요한 파일이 존재합니다.
) else (
    set diagnosisResult=OK: %targetDir% 디렉터리에 불필요한 파일이 존재하지 않습니다.
)

echo %diagnosisResult% >> "!TMP1!"
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

type "!TMP1%"

echo.
echo.

endlocal
