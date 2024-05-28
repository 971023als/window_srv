@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for Antivirus Update Status
set "csvFile=!resultDir!\Antivirus_Update_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 보안"
set "code=SRV-119"
set "riskLevel=중"
set "diagnosisItem=백신 프로그램 업데이트 상태 검사"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-119] 백신 프로그램 업데이트 상태 검사 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 백신 프로그램이 최신 버전으로 업데이트 되어 있는 경우 >> "!TMP1!"
echo [취약]: 백신 프로그램이 최신 버전으로 업데이트 되어 있지 않은 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: Check the antivirus update status (Example with ClamAV)
powershell -Command "& {
    $currentVersion = (clamscan --version);
    $latestVersion = (Invoke-WebRequest -Uri 'https://www.clamav.net/downloads').Content | Select-String -Pattern 'ClamAV\s[0-9.]+' -AllMatches | ForEach-Object {$_.Matches} | ForEach-Object {$_.Value} | Select-Object -First 1;
    if ($currentVersion -eq $latestVersion) {
        echo OK: 백신 프로그램이 최신 버전입니다: $currentVersion > temp.txt;
        set 'diagnosisResult=최신 버전 적용됨'
    } else {
        echo WARN: 백신 프로그램이 최신 버전이 아닙니다. 현재 버전: $currentVersion, 최신 버전: $latestVersion > temp.txt;
        set 'diagnosisResult=최신 버전 미적용'
    }
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
