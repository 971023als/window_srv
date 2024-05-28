@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for SMTP relay restriction analysis
set "csvFile=!resultDir!\SMTP_Relay_Restriction.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 관리"
set "code=SRV-009"
set "riskLevel=중"
set "diagnosisItem=SMTP 스팸 메일 릴레이 제한 설정 검사"
set "diagnosisResult="
set "status="

:: SMTP 릴레이 설정 확인 (PowerShell 사용 예시)
powershell -Command "& {
    # PowerShell 스크립트로 Exchange 서버 릴레이 설정 확인
    # 이 부분은 실제 환경에 맞게 수정해야 합니다.
    $RelayRestrictions = Get-ReceiveConnector | Select-Object -ExpandProperty RelayRestrictions
    If ($RelayRestrictions -eq 'None') {
        $result = 'SMTP 서비스의 릴레이 제한이 설정되어 있지 않습니다.'
        $status = '취약'
    } Else {
        $result = 'SMTP 서비스를 사용하지 않거나 릴레이 제한이 설정되어 있습니다.'
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
