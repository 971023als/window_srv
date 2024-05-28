@echo off
call function.bat

set TMP1=%SCRIPTNAME%.log
type NUL > %TMP1%

call :BAR

echo CODE [SRV-166] 불필요한 숨김 파일 또는 디렉터리 존재

(
echo [양호]: 불필요한 숨김 파일 또는 디렉터리가 존재하지 않는 경우
echo [취약]: 불필요한 숨김 파일 또는 디렉터리가 존재하는 경우
) >> %result%

call :BAR

:: 시스템에서 숨김 파일 및 디렉터리 검색
setlocal EnableDelayedExpansion
set hidden_files=
set hidden_dirs=

for /r %%i in (.*.*) do (
    if exist %%i (
        if "%%~ai"=="H" (
            set hidden_files=!hidden_files! %%i
        )
    )
)

for /d /r %%i in (.*.) do (
    if exist %%i (
        if "%%~ai"=="H" (
            set hidden_dirs=!hidden_dirs! %%i
        )
    )
)

if "%hidden_files%"=="" if "%hidden_dirs%"=="" (
    call :OK "불필요한 숨김 파일 또는 디렉터리가 존재하지 않습니다."
) else (
    call :WARN "다음의 불필요한 숨김 파일 또는 디렉터리가 존재합니다: %hidden_files% %hidden_dirs%"
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

