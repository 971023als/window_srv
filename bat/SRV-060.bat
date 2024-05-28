@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for default web service account audit
set "csvFile=!resultDir!\Web_Service_Default_Accounts.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Result,Details" > "!csvFile!"

REM Define security details
set "category=웹 보안"
set "code=SRV-060"
set "riskLevel=중"
set "diagnosisItem=기본 계정(아이디 또는 비밀번호) 미변경 검사"
set "diagnosisResult="
set "status="

REM Setup log file
set "TMP1=!resultDir!\%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo 코드 [SRV-060] 웹 서비스의 기본 계정(아이디 또는 비밀번호) 미변경 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"
echo [양호]: 웹 서비스의 기본 계정(아이디 또는 비밀번호)이 변경됨 >> "!TMP1!"
echo [취약]: 웹 서비스의 기본 계정(아이디 또는 비밀번호)이 변경되지 않음 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: Web service configuration file path adjustment as needed
set "CONFIG_FILE=C:\path\to\web_service\config.txt"

:: Check for default account settings (e.g., 'admin' or 'password')
findstr /R "username=admin password=password" "%CONFIG_FILE%" >nul

if errorlevel 1 (
    echo OK: 웹 서비스의 기본 계정(아이디 또는 비밀번호)이 변경됨 >> "!TMP1!"
    set "result=Changed"
    set "details=Default account changed."
    echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!result!","!details!" >> "!csvFile!"
) else (
    echo WARN: 웹 서비스의 기본 계정(아이디 또는 비밀번호)이 변경되지 않음 >> "!TMP1!"
    set "result=Not Changed"
    set "details=Default account not changed."
    echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!result!","!details!" >> "!csvFile!"
)

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
echo 스크립트 완료.

endlocal
