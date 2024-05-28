@echo off
setlocal enabledelayedexpansion

REM Define the directory to store results and create if not exists
set "resultDir=%~dp0results"
if not exist "!resultDir!" mkdir "!resultDir!"

REM Define CSV file for password policy audit
set "csvFile=!resultDir!\Password_Policy_Audit.csv"
echo "Account,Password Required,Password Last Set,Password Expires,User May Change Password,Account Expires" > "!csvFile!"

REM Define security details for logging
set "category=계정 보안"
set "code=SRV-075"
set "riskLevel=중"
set "diagnosisItem=비밀번호 정책 감사"
set "diagnosisResult="
set "status="

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo 코드 [SRV-075] 예측 가능한 계정 비밀번호 존재 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: 강력한 비밀번호 정책이 적용됨 >> "!TMP1!"
echo [취약]: 약한 비밀번호 정책이 적용됨 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

REM Use PowerShell to check password policies and log results to CSV and log file
powershell -Command "& {
    $users = Get-LocalUser | Where-Object { $_.PasswordRequired -eq $true }
    foreach ($user in $users) {
        $details = $user | Select-Object Name,PasswordRequired,PasswordLastSet,PasswordExpires,UserMayChangePassword,AccountExpires
        $line = $details.Name + ',' + $details.PasswordRequired + ',' + $details.PasswordLastSet + ',' + $details.PasswordExpires + ',' + $details.UserMayChangePassword + ',' + $details.AccountExpires
        \"$line\" | Out-File -FilePath temp.txt;
        Add-Content -Path '!csvFile!' -Value $line
    }
}"
set /p diagnosisResult=<temp.txt
del temp.txt

REM Save results to CSV
echo "!category!","!code!","!riskLevel!","!diagnosisItem!","!service!","!diagnosisResult!","!status!" >> "!csvFile!"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.

endlocal
