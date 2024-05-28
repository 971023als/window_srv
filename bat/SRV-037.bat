@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for FTP service status analysis
set "csvFile=!resultDir!\FTP_Service_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Service,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=네트워크 보안"
set "code=SRV-037"
set "riskLevel=중"
set "diagnosisItem=FTP 서비스 실행 상태 검사"
set "service=FTP"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-037] 취약한 FTP 서비스 실행 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: FTP 서비스가 비활성화 되어 있는 경우 >> "!TMP1!"
echo [취약]: FTP 서비스가 활성화 되어 있는 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: FTP 서비스 상태 확인 (PowerShell 사용)
powershell -Command "& {
    $service = Get-Service -Name 'FTPSvc' -ErrorAction SilentlyContinue;
    if ($service -and $service.Status -eq 'Running') {
        $status = 'WARN: FTP 서비스가 활성화되어 있습니다.'
    } else {
        $status = 'OK: FTP 서비스가 비활성화되어 있습니다.'
    }

    $port21Listening = Test-NetConnection -ComputerName localhost -Port 21 -InformationLevel Quiet;
    if ($port21Listening) {
        $status += ' WARN: 시스템에서 포트 21이(가) 열려 있습니다. FTP 서비스가 활성화되어 있을 수 있습니다.'
    } else {
        $status += ' OK: 시스템에서 포트 21이(가) 닫혀 있습니다. FTP 서비스가 비활성화되어 있습니다.'
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
