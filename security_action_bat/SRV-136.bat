@echo off
setlocal

set TMP1=%SCRIPTNAME%.log
type NUL > %TMP1%

echo ---------------------------------------- >> %TMP1%
echo CODE [SRV-136] 시스템 종료 권한 설정 미흡 >> %TMP1%
echo ---------------------------------------- >> %TMP1%

echo [양호]: 시스템 종료 권한이 적절히 제한된 경우 >> %TMP1%
echo [취약]: 시스템 종료 권한이 제한되지 않은 경우 >> %TMP1%

echo ---------------------------------------- >> %TMP1%

:: PowerShell을 사용하여 시스템 종료 권한 정책 검사
powershell -Command "& { $policy = Get-LocalSecurityPolicy -Policy 'Shut down the system'; if ($policy -ne 'Administrators') { echo 'WARN: 시스템 종료 권한이 적절히 제한되지 않았습니다.' >> '%TMP1%' } else { echo 'OK: 시스템 종료 권한이 적절히 제한되었습니다.' >> '%TMP1%' } }"

type %TMP1%

echo.
echo.

endlocal
