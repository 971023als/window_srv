@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for Hidden Files and Directories Audit
set "csvFile=!resultDir!\Hidden_Files_Audit.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 보안"
set "code=SRV-166"
set "riskLevel=낮음"
set "diagnosisItem=불필요한 숨김 파일 또는 디렉터리 존재"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-166] 불필요한 숨김 파일 또는 디렉터리 존재 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 불필요한 숨김 파일 또는 디렉터리가 존재하지 않는 경우 >> "!TMP1!"
echo [취약]: 불필요한 숨김 파일 또는 디렉터리가 존재하는 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: Hidden Files and Directories Check
powershell -Command "& {
    $hiddenItems = Get-ChildItem -Path C:\ -Recurse -Hidden -ErrorAction SilentlyContinue | Where-Object { $_.Attributes -match 'Hidden' }
    if ($hiddenItems) {
        $status = 'WARN: 다음의 숨김 파일 또는 디렉터리가 존재합니다: ' + ($hiddenItems -join ', ')
    } else {
        $status = 'OK: 불필요한 숨김 파일 또는 디렉터리가 존재하지 않습니다.'
    }
    \"$status\" | Out-File -FilePath temp.txt;
}"
set /p diagnosisResult=<temp.txt
del temp.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.

endlocal
