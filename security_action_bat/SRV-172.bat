@echo off
SetLocal EnableDelayedExpansion

set "SCRIPTNAME=%~n0"
set "TMP1=%SCRIPTNAME%.log"

:: 로그 파일 초기화
type NUL > "%TMP1%"

echo BAR >> "%TMP1%"
echo CODE [SRV-172] 불필요한 시스템 자원 공유 존재 >> "%TMP1%"
echo [양호]: 불필요한 시스템 자원이 공유되지 않는 경우 >> "%TMP1%"
echo [취약]: 불필요한 시스템 자원이 공유되는 경우 >> "%TMP1%"
echo BAR >> "%TMP1%"

:: Windows 공유 상태 확인
for /f "tokens=1" %%i in ('net share ^| findstr /R /C:"^C " /C:"^D " /C:"^E "') do (
    set "share=%%i"
    if not "!share!"=="" (
        echo WARN 불필요한 시스템 자원이 공유됩니다: !share! >> "%TMP1%"
        set "sharesFound=true"
    )
)

if not defined sharesFound (
    echo OK 불필요한 시스템 자원이 공유되지 않습니다. >> "%TMP1%"
)

type "%TMP1%"

EndLocal
