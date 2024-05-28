@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for screensaver status analysis
set "csvFile=!resultDir!\Screensaver_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=사용자 인터페이스 보안"
set "code=SRV-125"
set "riskLevel=낮"
set "diagnosisItem=화면보호기 설정 검사"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-125] 화면보호기 미설정 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 화면보호기가 설정되어 있는 경우 >> "!TMP1!"
echo [취약]: 화면보호기가 설정되어 있지 않은 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: PowerShell을 사용하여 화면보호기 설정 확인
powershell -Command "& {
    $screenSaverActive = Get-ItemProperty 'HKCU:\Control Panel\Desktop\' -Name ScreenSaveActive;
    if ($screenSaverActive.ScreenSaveActive -eq '1') {
        $status = 'OK: 화면보호기가 설정되어 있습니다.'
    } else {
        $status = 'WARN: 화면보호기가 설정되어 있지 않습니다.'
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
