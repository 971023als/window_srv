@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo 코드 [SRV-073] 관리자 그룹 내 불필요한 사용자 존재 >> "%TMP1%"
echo [양호]: 관리자 그룹에 불필요한 사용자가 없음 >> "%TMP1%"
echo [취약]: 관리자 그룹에 불필요한 사용자가 존재함 >> "%TMP1%"

:: 관리자 그룹의 멤버 나열
echo 관리자 그룹의 멤버를 나열합니다: >> "%TMP1%"
net localgroup 관리자 >> "%TMP1%"

:: 수동 검토에 대한 주의사항
echo 관리자 그룹의 멤버 중 불필요하거나 속하지 않아야 할 사용자가 있는지 수동으로 검토해주세요. >> "%TMP1%"

:: 결과 표시
type "%TMP1%"

echo.
echo 스크립트 완료.
