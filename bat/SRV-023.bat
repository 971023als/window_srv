@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for SSH encryption level analysis
set "csvFile=!resultDir!\SSH_Encryption_Level.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 보안"
set "code=SRV-023"
set "riskLevel=높음"
set "diagnosisItem=SSH 암호화 수준 설정 검사"
set "diagnosisResult="
set "status="

REM Check SSH encryption settings (PowerShell usage)
powershell -Command "& {
    $SshConfigFile = 'C:\ProgramData\ssh\sshd_config';
    $EncryptionSettings = @('KexAlgorithms', 'Ciphers', 'MACs');
    $ConfigExists = Test-Path $SshConfigFile;
    $result = '';
    if (-not $ConfigExists) {
        $result = 'WARN: SSH configuration file does not exist;'
    } else {
        foreach ($setting in $EncryptionSettings) {
            $ConfigContent = Get-Content $SshConfigFile;
            $SettingConfigured = $ConfigContent | Where-Object { $_ -match """"^$setting"""" };
            if ($SettingConfigured) {
                $result += 'OK: ' + $SshConfigFile + ' file has appropriate ' + $setting + ' settings configured; '
            } else {
                $result += 'WARN: ' + $SshConfigFile + ' file has inadequate ' + $setting + ' settings; '
            }
        }
    }
    if ($result -eq '') {
        $result = 'No specific settings found or checked.'
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
