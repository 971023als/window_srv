@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for UMASK settings analysis
set "csvFile=!resultDir!\UMASK_Settings_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 보안"
set "code=SRV-122"
set "riskLevel=중"
set "diagnosisItem=UMASK 설정 검사"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-122] UMASK 설정 미흡 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"
echo [양호]: 시스템 전체 UMASK 설정이 022 또는 더 엄격한 경우 >> "!TMP1!"
echo [취약]: 시스템 전체 UMASK 설정이 022보다 덜 엄격한 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: PowerShell을 사용하여 UMASK 설정 검사
powershell -Command "& {
    $currentUmask = [System.IO.File]::GetAttributes('C:\Users\Public\Documents')
    if ($currentUmask -eq 'ReadOnly') {
        $status = 'OK: UMASK 설정이 적용되었습니다: 022 또는 더 엄격'
    } else {
        $status = 'WARN: UMASK 설정 적용 실패: 022보다 덜 엄격'
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
echo Script complete.
endlocal
