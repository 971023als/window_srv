@echo off
setlocal

set TMP1=%SCRIPTNAME%.log
type NUL > %TMP1%

echo ---------------------------------------- >> %TMP1%
echo CODE [SRV-139] 시스템 자원 소유권 변경 권한 설정 미흡 >> %TMP1%
echo ---------------------------------------- >> %TMP1%

echo [양호]: 중요 시스템 자원의 소유권 변경 권한이 제한되어 있는 경우 >> %TMP1%
echo [취약]: 중요 시스템 자원의 소유권 변경 권한이 제한되어 있지 않은 경우 >> %TMP1%

echo ---------------------------------------- >> %TMP1%

:: 파일 권한 확인 예제 (예: C:\Windows\System32 폴더)
set "targetPath=C:\Windows\System32"

icacls "%targetPath%" >> %TMP1%

:: 권한 분석 로직은 복잡하며, 이 예제에는 포함되지 않음
echo 파일 권한 분석 결과는 %TMP1% 파일을 참조하십시오. >> %TMP1%

type %TMP1%

echo.
echo.

endlocal
