@echo off
setlocal

set TMP1=%SCRIPTNAME%.log
type NUL > %TMP1%

echo ---------------------------------------- >> %TMP1%
echo CODE [SRV-144] 불필요한 파일 존재 여부 확인 >> %TMP1%
echo ---------------------------------------- >> %TMP1%

echo [양호]: 지정된 경로에 불필요한 파일이 존재하지 않는 경우 >> %TMP1%
echo [취약]: 지정된 경로에 불필요한 파일이 존재하는 경우 >> %TMP1%

echo ---------------------------------------- >> %TMP1%

:: 파일 수 확인 (예: C:\Windows\Temp 내의 파일)
set "targetDir=C:\Windows\Temp"
set /a fileCount=0

for /f %%a in ('dir /a-d /b "%targetDir%" 2^>nul ^| find /c /v ""') do set /a fileCount=%%a

if %fileCount% gtr 0 (
    echo WARN: %targetDir% 디렉터리에 %fileCount%개의 불필요한 파일이 존재합니다. >> %TMP1%
) else (
    echo OK: %targetDir% 디렉터리에 불필요한 파일이 존재하지 않습니다. >> %TMP1%
)

type %TMP1%

echo.
echo.

endlocal
