@echo off
setlocal EnableDelayedExpansion

:: 필요한 외부 함수 호출 (function.bat이라고 가정)
call function.bat

:: 결과를 저장할 로그 파일 정의
set "TMP1=%SCRIPTNAME%.log"
:: 로그 파일 초기화
type NUL > "%TMP1%"

echo ---------------------------------------- >> "%TMP1%"
echo CODE [SRV-164] 구성원이 존재하지 않는 GID 존재 >> "%TMP1%"
echo ---------------------------------------- >> "%TMP1%"
echo [양호]: 시스템에 구성원이 존재하지 않는 그룹(GID)가 존재하지 않는 경우 >> "%TMP1%"
echo [취약]: 시스템에 구성원이 존재하지 않는 그룹(GID)이 존재하는 경우 >> "%TMP1%"
echo ---------------------------------------- >> "%TMP1%"

:: PowerShell을 사용하여 Windows의 모든 로컬 그룹 및 그룹 구성원 확인
powershell -Command "& {
    $groups = Get-LocalGroup
    foreach ($group in $groups) {
        $members = Get-LocalGroupMember -Group $group.Name
        if (-not $members) {
            Write-Output '구성원이 없는 그룹: ' + $group.Name
        }
    }
}" >> "%TMP1%"

echo 결과를 확인하세요. >> "%TMP1%"

:: 결과 표시
type "%TMP1%"

echo.
echo Script complete.
endlocal
