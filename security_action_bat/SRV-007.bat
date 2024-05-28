@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-007] 취약한 버전의 SMTP 서비스 사용 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: SMTP 서비스 버전이 최신 버전일 경우 또는 취약점이 없는 버전을 사용하는 경우 >> !TMP1!
echo [취약]: SMTP 서비스 버전이 최신이 아니거나 알려진 취약점이 있는 버전을 사용하는 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: SMTP 서비스 버전 확인 (PowerShell 사용 예시)
powershell -Command "& {
    # 예시: Exchange 서버 버전 확인
    $ExchangeVersion = Get-ExchangeServer | Select -ExpandProperty AdminDisplayVersion;
    If ($ExchangeVersion -ne $null) {
        # 여기에 안전한 버전 정보 입력
        $SafeVersion = 'Version 15.1 (Build 1713.5)'; # 예시 버전, 실제 환경에 맞게 수정 필요
        
        If ($ExchangeVersion -ge $SafeVersion) {
            Add-Content !TMP1! 'Exchange 서버 버전이 안전합니다. 현재 버전: ' + $ExchangeVersion;
        } Else {
            Add-Content !TMP1! 'Exchange 서버 버전이 취약할 수 있습니다. 현재 버전: ' + $ExchangeVersion;
        }
    } Else {
        Add-Content !TMP1! 'Exchange 서버가 설치되어 있지 않습니다.';
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
