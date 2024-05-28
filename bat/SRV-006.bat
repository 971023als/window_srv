@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for SMTP log level analysis
set "csvFile=!resultDir!\SMTP_Log_Level.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 관리"
set "code=SRV-006"
set "riskLevel=중"
set "diagnosisItem=SMTP 서비스 로그 수준 설정 검사"
set "diagnosisResult="
set "status="

:: SMTP 로그 설정 확인 (PowerShell 사용 예시)
powershell -Command "& {
    # SMTP 서비스 로그 설정을 확인하는 PowerShell 코드
    # 예시로는 Get-TransportServer 또는 Get-SendConnector cmdlet 사용을 가정
    # 실제 환경에 맞게 조정 필요
    $logLevel = Get-TransportServer | Select-Object -ExpandProperty LogLevel;
    
    if ($logLevel -eq 'Medium' -or $logLevel -eq 'High') {
        $result = 'SMTP 서비스의 로그 수준이 적절하게 설정됨.'
        $status = '양호'
    } else {
        $result = 'SMTP 서비스의 로그 수준이 낮게 설정됨 또는 설정이 확인되지 않음.'
        $status = '취약'
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
