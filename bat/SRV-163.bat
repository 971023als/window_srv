@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for system login warnings analysis
set "csvFile=!resultDir!\System_Login_Warnings_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 보안"
set "code=SRV-163"
set "riskLevel=중"
set "diagnosisItem=시스템 사용 주의사항 미출력"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-163] 시스템 사용 주의사항 미출력 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 시스템 로그온 시 사용 주의사항이 출력되는 경우 >> "!TMP1!"
echo [취약]: 시스템 로그온 시 사용 주의사항이 출력되지 않는 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: Check system login warning settings
for /F "tokens=2*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v LegalNoticeCaption') do set Caption=%%B
for /F "tokens=2*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v LegalNoticeText') do set Text=%%B

if not "!Caption!"=="" if not "!Text!"=="" (
    set "diagnosisResult=OK: 시스템 로그온 시 사용 주의사항이 출력됩니다."
) else (
    set "diagnosisResult=WARN: 시스템 로그온 시 사용 주의사항이 출력되지 않습니다."
)

echo "!diagnosisResult!" >> "!TMP1!"

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.

endlocal
