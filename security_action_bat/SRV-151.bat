@echo off
setlocal

set TMP1=%SCRIPTNAME%.log
type NUL > %TMP1%

echo ---------------------------------------- >> %TMP1%
echo CODE [SRV-151] 익명 SID/이름 변환 허용 >> %TMP1%
echo ---------------------------------------- >> %TMP1%

echo [양호]: 익명 SID/이름 변환을 허용하지 않는 경우 >> %TMP1%
echo [취약]: 익명 SID/이름 변환을 허용하는 경우 >> %TMP1%

echo ---------------------------------------- >> %TMP1%

:: 보안 정책 내보내기
secedit /export /cfg secpol.cfg

:: 익명 SID/이름 변환 정책 확인
findstr "SeDenyNetworkLogonRight" secpol.cfg > nul
if %ERRORLEVEL% == 0 (
    findstr /C:"S-1-1-0" secpol.cfg > nul
    if %ERRORLEVEL% == 0 (
        echo OK: 익명 SID/이름 변환을 허용하지 않습니다. >> %TMP1%
    ) else (
        echo WARN: 익명 SID/이름 변환을 허용합니다. >> %TMP1%
    )
) else (
    echo WARN: 보안 정책 파일에서 관련 설정을 찾을 수 없습니다. >> %TMP1%
)

:: 임시 파일 정리
del secpol.cfg

type %TMP1%

echo.
echo.

endlocal
