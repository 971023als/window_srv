@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0security_diagnostics"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for SSH and related settings analysis
set "csvFile=!resultDir!\SSH_and_Hosts_Configuration.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 보안"
set "code=SRV-025"
set "riskLevel=높음"
set "diagnosisItem=hosts.equiv 및 .rhosts 파일 보안 검사"
set "diagnosisResult="
set "status="

:: Check for insecure settings in SSH-related files (PowerShell usage)
powershell -Command "& {
    $HostsFiles = @('C:\etc\hosts.equiv', 'C:\Users\$env:USERNAME\.rhosts');
    $findings = '';
    foreach ($file in $HostsFiles) {
        if (Test-Path $file) {
            $Content = Get-Content $file;
            if ($Content -like '*+*') {
                $findings += 'WARN: 취약한 설정이 ' + $file + ' 파일에 존재합니다.; '
            } else {
                $findings += 'OK: ' + $file + ' 파일 설정이 안전하게 구성되어 있습니다.; '
            }
        } else {
            $findings += 'INFO: ' + $file + ' 파일이 존재하지 않습니다.; '
        }
    }
    if ($findings -eq '') {
        $findings = 'No hosts.equiv or .rhosts files found or checked.'
    }
    \"$findings\" | Out-File -FilePath temp.txt;
}"
set /p diagnosisResult=<temp.txt
del temp.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!diagnosisResult!","!status!" >> "!csvFile!"

REM Display the CSV content
type "!csvFile!"
echo

endlocal
