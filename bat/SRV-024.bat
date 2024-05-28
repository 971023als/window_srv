@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for Telnet service authentication method analysis
set "csvFile=!resultDir!\Telnet_Authentication.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=네트워크 보안"
set "code=SRV-024"
set "riskLevel=높음"
set "diagnosisItem=Telnet 인증 방식 검사"
set "diagnosisResult="
set "status="

:: Telnet 서비스 상태 확인 (PowerShell 사용)
powershell -Command "& {
    $TelnetService = Get-Service -Name 'TlntSvr' -ErrorAction SilentlyContinue;
    $result = '';
    if ($TelnetService -and $TelnetService.Status -eq 'Running') {
        $result = 'WARN: Telnet 서비스가 활성화되어 있습니다. 추가 보안 설정 확인이 필요할 수 있습니다.';
        # Telnet 보안 인증 방식 확인 로직 (가정)
        # 여기에 Telnet 서비스의 보안 인증 방식을 확인하는 PowerShell 스크립트 추가
        # 실제 환경에서는 해당 설정을 직접 확인하는 명령어로 대체
        $TelnetSecurity = '가정된 보안 설정 확인 결과'; # Placeholder
        if ('$TelnetSecurity' -eq '보안 인증 방식 사용') {
            $result += 'OK: Telnet 서비스가 보안 인증 방식을 사용하고 있습니다;'
        } else {
            $result += 'WARN: Telnet 서비스가 보안 인증 방식을 사용하지 않고 있습니다;'
        }
    } else {
        $result = 'OK: Telnet 서비스가 비활성화되어 있습니다;'
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
