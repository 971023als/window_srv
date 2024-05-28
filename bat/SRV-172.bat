@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for checking system resource sharing
set "csvFile=!resultDir!\System_Resource_Sharing.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=네트워크 보안"
set "code=SRV-172"
set "riskLevel=중"
set "diagnosisItem=불필요한 시스템 자원 공유 존재"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-172] 불필요한 시스템 자원 공유 존재 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 불필요한 시스템 자원이 공유되지 않는 경우 >> "!TMP1!"
echo [취약]: 불필요한 시스템 자원이 공유되는 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: Windows 공유 상태 확인
set "sharesFound=false"
for /f "tokens=1,* delims= " %%i in ('net share') do (
    if "%%i"=="C$" or "%%i"=="D$" or "%%i"=="E$" (
        set "sharesFound=true"
        set "diagnosisResult=WARN: 불필요한 시스템 자원이 공유됩니다: %%i"
        echo !diagnosisResult! >> "!TMP1!"
    )
)

if "!sharesFound!"=="false" (
    set "diagnosisResult=OK: 불필요한 시스템 자원이 공유되지 않습니다."
    echo !diagnosisResult! >> "!TMP1!"
)

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.

endlocal
