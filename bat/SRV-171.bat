@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for FTP Service Information Exposure
set "csvFile=!resultDir!\FTP_Service_Info_Exposure.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=네트워크 보안"
set "code=SRV-171"
set "riskLevel=중"
set "diagnosisItem=FTP 서비스 정보 노출"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-171] FTP 서비스 정보 노출 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: FTP 서버에서 버전 정보 및 기타 세부 정보가 노출되지 않는 경우 >> "!TMP1!"
echo [취약]: FTP 서버에서 버전 정보 및 기타 세부 정보가 노출되는 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: FTP 서비스 상태 확인 (PowerShell 사용)
powershell -Command "& {
    $service = Get-Service -Name 'FTPSvc' -ErrorAction SilentlyContinue;
    if ($service -and $service.Status -eq 'Running') {
        $status = 'WARN: FTP 서비스가 활성화되어 있으며 정보가 노출될 수 있습니다.'
    } else {
        $status = 'OK: FTP 서비스가 비활성화되어 있거나 정보가 노출되지 않습니다.'
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
