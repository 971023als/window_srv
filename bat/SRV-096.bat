@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for user environment file permission analysis
set "csvFile=!resultDir!\User_Env_File_Permissions.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=사용자 환경 보안"
set "code=SRV-096"
set "riskLevel=중"
set "diagnosisItem=사용자 환경 파일 소유자 또는 권한 설정이 미흡함"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo 코드 [SRV-096] 사용자 환경 파일 소유자 또는 권한 설정이 미흡함 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 사용자 환경 파일의 소유자가 사용자 자신이며, 권한이 적절하게 설정됨 >> "!TMP1!"
echo [취약]: 사용자 환경 파일의 소유자가 사용자 자신이 아니거나, 권한이 불충분하게 설정됨 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: 사용자 홈 디렉토리 및 소유자 정보 추출
set "checkDir=C:\Users"

for /D %%D in ("%checkDir%\*") do (
    echo Checking permissions for user: %%~nxD >> "!TMP1!"
    icacls "%%D" | findstr /C:"%%~nxD" > nul
    if !errorlevel! equ 0 (
        echo OK: "%%~nxD owns their environment files correctly." >> "!TMP1!"
    ) else (
        echo WARNING: "%%~nxD does NOT own their environment files correctly." >> "!TMP1!"
    )
)

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
echo 스크립트 완료.
endlocal
