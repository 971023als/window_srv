@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-006] SMTP 서비스 로그 수준 설정 미흡 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: SMTP 서비스의 로그 수준이 적절하게 설정되어 있는 경우 >> !TMP1!
echo [취약]: SMTP 서비스의 로그 수준이 낮거나, 로그가 충분히 수집되지 않는 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: SMTP 로그 설정 확인 (PowerShell 사용 예시)
powershell -Command "& {
    # SMTP 서비스 로그 설정을 확인하는 PowerShell 코드
    # 예시로는 Get-TransportServer 또는 Get-SendConnector cmdlet 사용을 가정
    # 실제 환경에 맞게 조정 필요
    $logLevel = Get-TransportServer | Select-Object -ExpandProperty LogLevel;
    
    if ($logLevel -eq 'Medium' -or $logLevel -eq 'High') {
        Add-Content !TMP1! 'SMTP 서비스의 로그 수준이 적절하게 설정됨.'
    } else {
        Add-Content !TMP1! 'SMTP 서비스의 로그 수준이 낮게 설정됨 또는 설정이 확인되지 않음.'
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
