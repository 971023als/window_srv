@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for FTP directory permissions analysis
set "csvFile=!resultDir!\FTP_Directory_Permissions.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=네트워크 보안"
set "code=SRV-097"
set "riskLevel=중"
set "diagnosisItem=FTP 서비스 디렉터리 접근권한 설정 미흡"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo 코드 [SRV-097] FTP 서비스 디렉터리 접근권한 설정 미흡 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: FTP 서비스 디렉터리의 접근 권한이 적절하게 설정된 경우 >> "!TMP1!"
echo [취약]: FTP 서비스 디렉터리의 접근 권한이 적절하지 않게 설정된 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: FTP 서비스 실행 여부 확인
for /f "tokens=*" %%i in ('netstat -an ^| find "LISTENING" ^| find ":21 "') do (
    echo WARN: FTP 서비스가 실행 중입니다. >> "!TMP1!"
)

:: FTP 디렉터리 권한 확인 (예시 경로: C:\FTP)
icacls "C:\FTP" >> "!TMP1%"

REM Save results to CSV
set "diagnosisResult=Check the log for details"
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1%"

echo.
echo 스크립트 완료.
endlocal
