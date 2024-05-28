@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for SMTP version analysis
set "csvFile=!resultDir!\SMTP_Version_Analysis.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 관리"
set "code=SRV-007"
set "riskLevel=높음"
set "diagnosisItem=SMTP 서비스 버전 검사"
set "diagnosisResult="
set "status="

:: SMTP 서비스 버전 확인 (PowerShell 사용 예시)
powershell -Command "& {
    # 예시: Exchange 서버 버전 확인
    $ExchangeVersion = Get-ExchangeServer | Select -ExpandProperty AdminDisplayVersion;
    If ($ExchangeVersion -ne $null) {
        # 여기에 안전한 버전 정보 입력
        $SafeVersion = 'Version 15.1 (Build 1713.5)'; # 예시 버전, 실제 환경에 맞게 수정 필요
        
        If ($ExchangeVersion -ge $SafeVersion) {
            $result = 'Exchange 서버 버전이 안전합니다. 현재 버전: ' + $ExchangeVersion;
            $status = '양호';
        } Else {
            $result = 'Exchange 서버 버전이 취약할 수 있습니다. 현재 버전: ' + $ExchangeVersion;
            $status = '취약';
        }
    } Else {
        $result = 'Exchange 서버가 설치되어 있지 않습니다.';
        $status = '정보 없음';
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
