@echo off
setlocal

set TMP1=%SCRIPTNAME%.log
type NUL > %TMP1%

echo ---------------------------------------- >> %TMP1%
echo CODE [SRV-163] 시스템 사용 주의사항 미출력 >> %TMP1%
echo ---------------------------------------- >> %TMP1%

(
echo [양호]: 시스템 로그온 시 사용 주의사항이 출력되는 경우
echo [취약]: 시스템 로그온 시 사용 주의사항이 출력되지 않는 경우
) >> %TMP1%

echo ---------------------------------------- >> %TMP1%

:: /etc/motd 또는 /etc/issue 파일에 해당하는 Windows 설정 확인
for /F "tokens=2*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v LegalNoticeCaption') do set Caption=%%B
for /F "tokens=2*" %%A in ('reg query "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v LegalNoticeText') do set Text=%%B

if not "%Caption%"=="" if not "%Text%"=="" (
    echo /etc/motd 파일에 해당: LegalNoticeCaption 및 LegalNoticeText가 설정되어 있습니다. >> %TMP1%
    echo %Caption% >> %TMP1%
    echo %Text% >> %TMP1%
    call :OK "시스템 로그온 시 사용 주의사항이 출력됩니다." >> %TMP1%
) else (
    call :WARN "시스템 로그온 시 사용 주의사항이 출력되지 않습니다." >> %TMP1%
)

type %TMP1%

echo.
echo.

endlocal
goto :eof

:OK
echo %~1
goto :eof

:WARN
echo %~1
goto :eof

