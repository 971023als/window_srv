@echo off
setlocal

set TMP1=%SCRIPTNAME%.log
type NUL > %TMP1%

echo ---------------------------------------- >> %TMP1%
echo CODE [SRV-138] 백업 및 복구 권한 설정 미흡 >> %TMP1%
echo ---------------------------------------- >> %TMP1%

echo [양호]: 백업 및 복구 권한이 적절히 설정된 경우 >> %TMP1%
echo [취약]: 백업 및 복구 권한이 적절히 설정되지 않은 경우 >> %TMP1%

echo ---------------------------------------- >> %TMP1%

:: 백업 디렉토리 권한 확인
set "backupDir=C:\Backup"

:: 디렉토리 존재 여부 확인
if not exist "%backupDir%" (
    echo INFO: %backupDir% 디렉토리가 존재하지 않습니다. >> %TMP1%
    goto CheckDone
)

:: 권한 확인
icacls "%backupDir%" >> %TMP1%

:: 추가적인 권한 분석 및 판단 로직은 필요에 따라 구현
echo 권한 분석 결과는 %TMP1% 파일을 참조하세요. >> %TMP1%

:CheckDone
type %TMP1%

echo.
echo.

endlocal
