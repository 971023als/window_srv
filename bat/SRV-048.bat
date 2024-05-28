@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for unnecessary web services audit
set "csvFile=!resultDir!\Unnecessary_Web_Services.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Status,Additional Info" > "!csvFile!"

REM Define security details
set "category=웹 보안"
set "code=SRV-048"
set "riskLevel=중"
set "diagnosisItem=불필요한 웹 서비스 실행 검사"
set "diagnosisResult="
set "status="

REM Setup log file
set "TMP1=%~dp0%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo 코드 [SRV-048] 불필요한 웹 서비스 실행 검사 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"
echo [양호]: 불필요한 웹 서비스가 실행되지 않음 >> "!TMP1!"
echo [취약]: 불필요한 웹 서비스가 실행됨 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: Check IIS web service status
powershell -Command "& {
    $service = Get-Service -Name 'W3SVC' -ErrorAction SilentlyContinue;
    if ($service -and $service.Status -eq 'Running') {
        $status = 'WARN: IIS 웹 서비스가 실행 중입니다.'
    } else {
        $status = 'OK: IIS 웹 서비스가 실행되지 않습니다.'
    }
    \"$status\" | Out-File -FilePath temp.txt;
}"
set /p status=<temp.txt
del temp.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!status!","!additionalInfo!" >> "!csvFile!"

:: Check for unnecessary default web sites or applications
powershell -Command "& {
    Import-Module WebAdministration; 
    $sites = Get-WebSite;
    $defaultSite = $sites | Where-Object { $_.Name -eq 'Default Web Site' };
    $additionalInfo = if ($defaultSite) { 'WARN: ''Default Web Site''가 실행 중이며 불필요할 수 있습니다.' } else { 'OK: 불필요한 기본 웹사이트가 실행되지 않습니다.' };
    \"$additionalInfo\" | Out-File -FilePath temp.txt;
}"
set /p additionalInfo=<temp.txt
del temp.txt

REM Append to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","Default Web Site","",$additionalInfo >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"
echo.
echo 스크립트 완료.

endlocal
