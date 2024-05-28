@echo off
setlocal

set "SCRIPTNAME=%~n0"
set "TMP1=%SCRIPTNAME%.log"

:: 로그 파일 초기화
type NUL > "%TMP1%"

echo BAR >> "%TMP1%"
echo CODE [SRV-174] 불필요한 DNS 서비스 실행 >> "%TMP1%"
echo [양호]: DNS 서비스가 비활성화되어 있는 경우 >> "%TMP1%"
echo [취약]: DNS 서비스가 활성화되어 있는 경우 >> "%TMP1%"
echo BAR >> "%TMP1%"

:: DNS 서비스 상태 확인 (여기서는 "Dnscache" 서비스를 예로 들었습니다. 실제 서비스 이름에 맞게 조정해야 합니다.)
sc query "Dnscache" | find "RUNNING"
if %ERRORLEVEL% == 0 (
    echo WARN "DNS 서비스(Dnscache)가 활성화되어 있습니다." >> "%TMP1%"
) else (
    echo OK "DNS 서비스(Dnscache)가 비활성화되어 있습니다." >> "%TMP1%"
)

type "%TMP1%"

endlocal
