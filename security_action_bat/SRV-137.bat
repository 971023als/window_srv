@echo off
setlocal

set TMP1=%SCRIPTNAME%.log
type NUL > %TMP1%

echo ---------------------------------------- >> %TMP1%
echo CODE [SRV-137] 네트워크 서비스의 접근 제한 설정 미흡 >> %TMP1%
echo ---------------------------------------- >> %TMP1%

echo [양호]: 네트워크 서비스의 접근 제한이 적절히 설정된 경우 >> %TMP1%
echo [취약]: 네트워크 서비스의 접근 제한이 설정되지 않은 경우 >> %TMP1%

echo ---------------------------------------- >> %TMP1%

:: PowerShell을 사용하여 Windows 방화벽 규칙 검사
powershell -Command "& { Get-NetFirewallRule | Where-Object { $_.Enabled -eq 'True' -and $_.Action -eq 'Allow' } | Format-Table Name, Action, Direction, Enabled -AutoSize }" >> %TMP1%

:: 추가적인 분석 및 판단 로직 필요
echo 추가적인 분석 및 판단 로직이 필요합니다. 결과는 %TMP1% 파일을 참조하세요. >> %TMP1%

type %TMP1%

echo.
echo.

endlocal
