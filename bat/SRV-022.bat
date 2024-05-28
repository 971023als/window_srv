@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for account password policy analysis
set "csvFile=!resultDir!\Account_Password_Policy.csv"
echo "Category,Code,Risk Level,Diagnosis Item,Diagnosis Result,Status" > "!csvFile!"

REM Define security details
set "category=시스템 보안"
set "code=SRV-022"
set "riskLevel=높음"
set "diagnosisItem=계정 비밀번호 설정 및 빈 비밀번호 사용 검사"
set "diagnosisResult="
set "status="

:: 계정의 비밀번호 설정 및 빈 비밀번호 사용 확인 (PowerShell 사용)
powershell -Command "& {
    $usersWithEmptyPassword = 0;
    $accounts = Get-LocalUser | Where-Object { $_.PasswordRequired -eq $false -and $_.Enabled -eq $true };
    $result = '';
    foreach ($account in $accounts) {
        $usersWithEmptyPassword++;
        $result += 'WARN: 비밀번호가 설정되지 않은 계정: ' + $account.Name + '; '
    }
    if ($usersWithEmptyPassword -eq 0) {
        $result = '[결과] 양호: 모든 계정에 비밀번호가 설정되어 있고 빈 비밀번호를 사용하는 계정이 없습니다.'
        $status = '양호'
    } else {
        $result = '[결과] 취약: 비밀번호가 설정되지 않거나 빈 비밀번호를 사용하는 계정이 존재합니다.'
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
