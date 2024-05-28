@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-022] 계정의 비밀번호 미설정, 빈 암호 사용 관리 미흡 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: 모든 계정에 비밀번호가 설정되어 있고 빈 비밀번호를 사용하는 계정이 없는 경우 >> !TMP1!
echo [취약]: 비밀번호가 설정되지 않거나 빈 비밀번호를 사용하는 계정이 있는 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: 계정의 비밀번호 설정 및 빈 비밀번호 사용 확인 (PowerShell 사용)
powershell -Command "& {
    $usersWithEmptyPassword = 0;
    $accounts = Get-LocalUser | Where-Object { $_.PasswordRequired -eq $false -and $_.Enabled -eq $true };
    foreach ($account in $accounts) {
        $usersWithEmptyPassword++;
        Add-Content !TMP1! ('WARN: 비밀번호가 설정되지 않은 계정: ' + $account.Name);
    }
    if ($usersWithEmptyPassword -eq 0) {
        Add-Content !TMP1! '[결과] 양호: 모든 계정에 비밀번호가 설정되어 있고 빈 비밀번호를 사용하는 계정이 없습니다.';
    } else {
        Add-Content !TMP1! '[결과] 취약: 비밀번호가 설정되지 않거나 빈 비밀번호를 사용하는 계정이 존재합니다.';
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
