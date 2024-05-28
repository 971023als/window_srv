@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for RPC service status analysis
set "csvFile=!resultDir!\RPC_Service_Status.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 보안"
set "code=SRV-016"
set "riskLevel=높음"
set "diagnosisItem=불필요한 RPC 서비스 활성화 상태 검사"
set "diagnosisResult="
set "status="

:: 불필요한 RPC 서비스 활성화 상태 확인 (PowerShell 사용)
powershell -Command "& {
    $RpcServices = @('RpcSs', 'DcomLaunch'); # 예시 RPC 서비스 이름
    $result = '';
    foreach ($service in $RpcServices) {
        $ServiceStatus = Get-Service -Name $service -ErrorAction SilentlyContinue;
        if ($ServiceStatus -and $ServiceStatus.Status -eq 'Running') {
            $result += '불필요한 RPC 서비스 (' + $service + ') 가 활성화 되어 있습니다; '
        } else {
            $result += '불필요한 RPC 서비스 (' + $service + ') 가 비활성화 되어 있습니다; '
        }
    }
    if ($result -eq '') {
        $result = 'No specified RPC services found or checked.'
    }
    \"$result\" | Out-File -FilePath temp.txt;
}"
set /p diagnosisResult=<temp.txt
del temp.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!diagnosisResult!","!status!" >> "!csvFile!"

REM Display the CSV content
type "!csvFile!"
echo

endlocal
