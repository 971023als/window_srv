@echo off
setlocal

set TMP1=%SCRIPTNAME%.log
type NUL > %TMP1%

echo ---------------------------------------- >> %TMP1%
echo CODE [SRV-142] 중복 사용자 이름이 부여된 계정 존재 >> %TMP1%
echo ---------------------------------------- >> %TMP1%

echo [양호]: 중복 사용자 이름이 부여된 계정이 존재하지 않는 경우 >> %TMP1%
echo [취약]: 중복 사용자 이름이 부여된 계정이 존재하는 경우 >> %TMP1%

echo ---------------------------------------- >> %TMP1%

:: PowerShell을 사용하여 중복 사용자 이름 확인
powershell -Command "& { $users = Get-WmiObject -Class Win32_UserAccount; $duplicates = $users | Group-Object -Property Name | Where-Object { $_.Count -gt 1 }; if ($duplicates) { 'WARN: 중복 사용자 이름이 존재합니다.' } else { 'OK: 중복 사용자 이름이 부여된 계정이 존재하지 않습니다.' } }" >> %TMP1%

type %TMP1%

echo.
echo.

endlocal
