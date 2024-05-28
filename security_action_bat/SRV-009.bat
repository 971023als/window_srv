@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-009] SMTP 서비스의 스팸 메일 릴레이 제한 미설정 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: SMTP 서비스를 사용하지 않거나 릴레이 제한이 설정되어 있는 경우 >> !TMP1!
echo [취약]: SMTP 서비스를 사용하거나 릴레이 제한 설정이 없는 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: SMTP 릴레이 설정 확인 (PowerShell 사용 예시)
powershell -Command "& {
    # PowerShell 스크립트로 Exchange 서버 릴레이 설정 확인
    # 이 부분은 실제 환경에 맞게 수정해야 합니다.
    $RelayRestrictions = '릴레이 설정 예시'; # 가정된 변수, 실제로는 Get-ReceiveConnector 등의 cmdlet 사용
    If ('$RelayRestrictions' -eq 'None') {
        echo WARN: SMTP 서비스의 릴레이 제한이 설정되어 있지 않습니다. >> !TMP1!
    } Else {
        echo OK: SMTP 서비스를 사용하지 않거나 릴레이 제한이 설정되어 있습니다. >> !TMP1!
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
