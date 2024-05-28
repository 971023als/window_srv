@echo off
setlocal

set TMP1=%SCRIPTNAME%.log
type NUL > %TMP1%

echo ---------------------------------------- >> %TMP1%
echo CODE [SRV-134] 스택 영역 실행 방지 미설정 >> %TMP1%
echo ---------------------------------------- >> %TMP1%

echo [양호]: 스택 영역 실행 방지가 활성화된 경우 >> %TMP1%
echo [취약]: 스택 영역 실행 방지가 비활성화된 경우 >> %TMP1%

echo ---------------------------------------- >> %TMP1%

:: PowerShell을 사용하여 DEP 및 ASLR 설정 확인
powershell -Command "& {
    $depStatus = Get-ProcessMitigation -System | Select-Object -ExpandProperty Dep
    $aslrStatus = Get-ProcessMitigation -System | Select-Object -ExpandProperty Aslr

    if ($depStatus.Enable -eq 'ON' -and $aslrStatus.ForceRelocateImages -eq 'ON') {
        echo 'OK: 스택 영역 실행 방지가 활성화되어 있습니다.' >> '%TMP1%'
    } else {
        echo 'WARN: 스택 영역 실행 방지가 비활성화되어 있습니다.' >> '%TMP1%'
    }
}" >> %TMP1%

type %TMP1%

echo.
echo.

endlocal
