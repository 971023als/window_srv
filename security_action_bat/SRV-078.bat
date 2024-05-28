@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo 코드 [SRV-078] 불필요한 게스트 계정 활성화 >> "%TMP1%"
echo [양호]: 불필요한 게스트 계정이 비활성화됨 >> "%TMP1%"
echo [취약]: 불필요한 게스트 계정이 활성화됨 >> "%TMP1%"

:: 게스트 계정의 상태 확인
net user 게스트 | findstr /C:"계정 활성" >> "%TMP1%"

:: 관리자 그룹 내 불필요한 계정에 대한 수동 검사 제안
echo 관리자 그룹 내 불필요한 계정을 확인하려면, 'net localgroup 관리자'의 출력을 수동으로 검토하세요 >> "%TMP1%"

:: 결과 표시
type "%TMP1%"

echo.
echo 스크립트 완료.
