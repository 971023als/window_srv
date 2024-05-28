@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > "!TMP1!"

echo ------------------------------------------------ >> "!TMP1!"
echo CODE [SRV-005] SMTP 서비스의 expn/vrfy 명령어 실행 제한 미비 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

echo [양호]: SMTP 서비스가 expn 및 vrfy 명령어 사용을 제한하고 있는 경우 >> "!TMP1!"
echo [취약]: SMTP 서비스가 expn 및 vrfy 명령어 사용을 제한하지 않는 경우 >> "!TMP1!"
echo ------------------------------------------------ >> "!TMP1!"

:: Windows 환경에서 SMTP 서비스 확인
powershell -Command "& {
    $smtpService = Get-Service -Name 'SMTPSVC' -ErrorAction SilentlyContinue;
    if ($smtpService.Status -eq 'Running') {
        echo 'SMTP 서비스가 실행 중입니다.' >> '!TMP1!';
        # Exchange 서버의 expn/vrfy 명령어 사용 제한 설정 확인
        $smtpSettings = Get-ReceiveConnector | Where {$_.Enabled -eq $true} | Select Identity, SmtpUtf8Enabled, TarpitInterval;
        if ($smtpSettings) {
            foreach ($setting in $smtpSettings) {
                if ($setting.SmtpUtf8Enabled -eq $false) {
                    echo 'SMTP 서비스가 expn 및 vrfy 명령어 사용을 제한하고 있습니다: ' + $setting.Identity >> '!TMP1!';
                } else {
                    echo 'SMTP 서비스가 expn 및 vrfy 명령어 사용을 제한하지 않습니다: ' + $setting.Identity >> '!TMP1!';
                }
            }
        } else {
            echo 'SMTP 설정을 확인할 수 없습니다. Exchange 관리 셸에서 수동으로 확인하세요.' >> '!TMP1!';
        }
    } else {
        echo 'SMTP 서비스가 비활성화되어 있거나 실행 중이지 않습니다.' >> '!TMP1!';
    }
}"

echo ------------------------------------------------ >> "!TMP1!"
type "!TMP1!"

echo.
