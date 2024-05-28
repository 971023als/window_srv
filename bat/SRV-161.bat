@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for ftpusers file permission analysis
set "csvFile=!resultDir!\FTPUsers_Permission_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,File,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=네트워크 보안"
set "code=SRV-161"
set "riskLevel=중"
set "diagnosisItem=ftpusers 파일의 소유자 및 권한 설정 미흡"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-161] ftpusers 파일의 소유자 및 권한 설정 미흡 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: ftpusers 파일의 소유자가 root이고, 권한이 644 이하인 경우 >> "!TMP1!"
echo [취약]: ftpusers 파일의 소유자가 root가 아니거나, 권한이 644 이상인 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: 파일 경로 설정 - 실제 경로로 변경 필요
set "file_path=C:\path\to\your\ftpusers"

:: 파일 존재 여부 및 권한 확인
if not exist "%file_path%" (
    set "diagnosisResult=WARN: ftpusers 파일이 존재하지 않습니다."
) else (
    icacls "%file_path%" | find "BUILTIN\Administrators:(F)" >nul
    if !ERRORLEVEL! equ 0 (
        set "diagnosisResult=OK: 파일 소유자 및 권한 설정이 적절합니다."
    ) else (
        set "diagnosisResult=WARN: 파일 소유자 및 권한 설정이 적절하지 않습니다."
    )
)

echo "!diagnosisResult!" >> "!TMP1!"

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
endlocal
