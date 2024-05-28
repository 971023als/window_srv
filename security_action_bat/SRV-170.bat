@echo off

call function.bat

set TMP1=%SCRIPTNAME%.log
type NUL > %TMP1%

call :BAR

echo CODE [SRV-170] SMTP 서비스 정보 노출

(
echo [양호]: SMTP 서비스에서 버전 정보 및 기타 세부 정보가 노출되지 않는 경우
echo [취약]: SMTP 서비스에서 버전 정보 및 기타 세부 정보가 노출되는 경우
) >> %result%

call :BAR

:: SMTP 서버 설정 확인 (예: Postfix, Sendmail 등)

:: Postfix 예시
set postfix_config=/etc/postfix/main.cf
if exist "%postfix_config%" (
    findstr /c:"^smtpd_banner = $myhostname" "%postfix_config%" > NUL
    if errorlevel 1 (
        call :WARN "Postfix에서 버전 정보가 노출됩니다."
    ) else (
        call :OK "Postfix에서 버전 정보 노출이 제한됩니다."
    )
) else (
    call :INFO "Postfix 서버 설정 파일이 존재하지 않습니다."
)

:: Sendmail 예시
set sendmail_config=/etc/mail/sendmail.cf
if exist "%sendmail_config%" (
    findstr /c:"O SmtpGreetingMessage=$j" "%sendmail_config%" > NUL
    if errorlevel 1 (
        call :WARN "Sendmail에서 버전 정보가 노출됩니다."
    ) else (
        call :OK "Sendmail에서 버전 정보 노출이 제한됩니다."
    )
) else (
    call :INFO "Sendmail 서버 설정 파일이 존재하지 않습니다."
)

type %result%

echo.
echo.

goto :eof

:BAR
echo ----------------------------------------
goto :eof

:OK
echo %~1
goto :eof

:WARN
echo %~1
goto :eof

:INFO
echo %~1
goto :eof
