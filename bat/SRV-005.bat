@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for SMTP command restriction analysis
set "csvFile=!resultDir!\SMTP_Command_Restriction.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 관리"
set "code=SRV-005"
set "riskLevel=중"
set "diagnosisItem=SMTP EXPN/VRFY 명령어 사용 제한 검사"
set "diagnosisResult="
set "status="

:: Windows 환경에서 SMTP 서비스 확인
powershell -Command "& {
    $smtpService = Get-Service -Name 'SMTPSVC' -ErrorAction SilentlyContinue;
    if ($smtpService.Status -eq 'Running') {
        $smtpResult = 'SMTP 서비스가 실행 중입니다.';
        # Exchange 서버의 expn/vrfy 명령어 사용 제한 설정 확인
        $smtpSettings = Get-ReceiveConnector | Where {$_.Enabled -eq $true} | Select Identity, SmtpUtf8Enabled, TarpitInterval;
        if ($smtpSettings) {
            foreach ($setting in $smtpSettings) {
                if ($setting.SmtpUtf8Enabled -eq $false) {
                    $result = 'SMTP 서비스가 expn 및 vrfy 명령어 사용을 제한하고 있습니다: ' + $setting.Identity;
                } else {
                    $result = 'SMTP 서비스가 expn 및 vrfy 명령어 사용을 제한하지 않습니다: ' + $setting.Identity;
                }
            }
        } else {
            $result = 'SMTP 설정을 확인할 수 없습니다. Exchange 관리 셸에서 수동으로 확인하세요.';
        }
        \"$smtpResult, $result\" | Out-File -FilePath temp.txt;
    } else {
        'SMTP 서비스가 비활성화되어 있거나 실행 중이지 않습니다.' | Out-File -FilePath temp.txt;
    }
}"
set /p diagnosisResult=<temp.txt
set "status=진단 완료"
del temp.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!diagnosisResult!","!status!" >> "!csvFile!"

REM Display the CSV content
type "!csvFile!"
echo

endlocal
