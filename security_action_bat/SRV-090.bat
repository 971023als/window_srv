@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo 코드 [SRV-090] 불필요한 원격 레지스트리 서비스 활성화 >> "%TMP1%"
echo [양호]: 원격 레지스트리 서비스가 비활성화됨 >> "%TMP1%"
echo [취약]: 원격 레지스트리 서비스가 활성화됨 >> "%TMP1%"

:: 원격 레지스트리 서비스의 상태 확인
sc query RemoteRegistry | findstr /C:"STATE" > temp_status.txt
findstr /C:"RUNNING" temp_status.txt > nul

if %errorlevel% equ 0 (
    echo WARN "원격 레지스트리 서비스가 활성화되어 있습니다." >> "%TMP1%"
) else (
    echo OK "원격 레지스트리 서비스가 비활성화되어 있습니다." >> "%TMP1%"
)

del temp_status.txt

:: 결과 표시
type "%TMP1%"

echo.
echo 스크립트 완료.
