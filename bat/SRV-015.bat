@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for NFS service status analysis
set "csvFile=!resultDir!\NFS_Service_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=네트워크 보안"
set "code=SRV-015"
set "riskLevel=중"
set "diagnosisItem=불필요한 NFS 서비스 실행 상태 검사"
set "diagnosisResult="
set "status="

:: NFS 서비스 실행 상태 확인 (PowerShell 사용)
powershell -Command "& {
    $NfsService = Get-Service -Name 'NfsService' -ErrorAction SilentlyContinue;
    if ($NfsService -and $NfsService.Status -eq 'Running') {
        $result = '불필요한 NFS 서비스 관련 데몬이 실행 중입니다.'
        $status = '취약'
    } else {
        $result = '불필요한 NFS 서비스 관련 데몬이 비활성화'
        $status = '양호'
    }
    \"$result, $status\" | Out-File -FilePath temp.txt;
}"
set /p diagnosisResult=<temp.txt
del temp.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!diagnosisResult!","!status!" >> "!csvFile!"

REM Display the CSV content
type "!csvFile!"
echo

endlocal
