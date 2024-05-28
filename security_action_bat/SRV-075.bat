@echo off
setlocal

set "TMP1=%SCRIPTNAME%.log"
> "%TMP1%"

echo 코드 [SRV-075] 예측 가능한 계정 비밀번호 존재 >> "%TMP1%"
echo [양호]: 강력한 비밀번호 정책이 적용됨 >> "%TMP1%"
echo [취약]: 약한 비밀번호 정책이 적용됨 >> "%TMP1%"

:: 관리자에게 수동 검사 또는 PowerShell을 사용한 자동화에 대한 주의사항
echo 상세한 비밀번호 정책 검사를 위해서는 로컬 보안 정책(secpol.msc)이나 도메인에 가입된 기계의 경우 그룹 정책 관리를 사용하는 것을 고려하세요. >> "%TMP1%"
echo 또한, PowerShell 명령어를 사용하여 비밀번호 정책을 조회하고 설정할 수 있습니다. >> "%TMP1%"
echo 비밀번호 정책을 확인하는 PowerShell cmdlet 예제: Get-LocalUser | Get-LocalUser | Select-Object Name,PasswordRequired,PasswordLastSet,PasswordExpires,UserMayChangePassword,AccountExpires >> "%TMP1%"

:: 게스트와 같이 일반적으로 비활성화되어야 하는 특정 계정의 존재 여부에 대한 기본 검사 예제
net user 게스트 | findstr /C:"계정 활성 상태" >> "%TMP1%"

:: 결과 표시
type "%TMP1%"

echo.
echo 스크립트 완료.
