@echo off
setlocal

set TMP1=%SCRIPTNAME%.log
type NUL > %TMP1%

echo ---------------------------------------- >> %TMP1%
echo CODE [SRV-152] 원격터미널 접속 가능한 사용자 그룹 제한 미비 >> %TMP1%
echo ---------------------------------------- >> %TMP1%

echo [양호]: SSH 접속이 특정 그룹에게만 제한된 경우 >> %TMP1%
echo [취약]: SSH 접속이 특정 그룹에게만 제한되지 않은 경우 >> %TMP1%

echo ---------------------------------------- >> %TMP1%

:: OpenSSH 서비스 상태 확인
sc query sshd | findstr /C:"STATE" >> %TMP1%
if %ERRORLEVEL% == 0 (
    echo OK: SSH 서비스가 설치되어 있습니다. >> %TMP1%
) else (
    echo WARN: SSH 서비스가 설치되어 있지 않거나 비활성화되어 있습니다. >> %TMP1%
)

:: sshd_config 파일 확인
set "config_path=C:\ProgramData\ssh\sshd_config"
if exist "%config_path%" (
    echo sshd_config 파일이 존재합니다. >> %TMP1%
    :: 여기서 추가적인 확인 로직을 구현할 수 있음
) else (
    echo WARN: sshd_config 파일이 존재하지 않습니다. >> %TMP1%
)

type %TMP1%

echo.
echo.

endlocal
