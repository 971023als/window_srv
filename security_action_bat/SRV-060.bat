@echo off
setlocal

set "TMP1=%SCRIPTNAME%.log"
> "%TMP1%"

echo 코드 [SRV-060] 웹 서비스의 기본 계정(아이디 또는 비밀번호) 미변경 >> "%TMP1%"
echo [양호]: 웹 서비스의 기본 계정(아이디 또는 비밀번호)이 변경됨 >> "%TMP1%"
echo [취약]: 웹 서비스의 기본 계정(아이디 또는 비밀번호)이 변경되지 않음 >> "%TMP1%"

:: 웹 서비스 설정 파일의 예시 경로 (필요에 따라 경로 조정)
set "CONFIG_FILE=C:\path\to\web_service\config.txt"

:: 기본 계정 확인 (예시: 'admin' 또는 'password')
findstr /R "username=admin password=password" "%CONFIG_FILE%" >nul

if errorlevel 1 (
    echo OK: 웹 서비스의 기본 계정(아이디 또는 비밀번호)이 변경됨 >> "%TMP1%"
) else (
    echo 경고: 웹 서비스의 기본 계정(아이디 또는 비밀번호)이 변경되지 않음 >> "%TMP1%"
)

:: 결과 표시
type "%TMP1%"

echo.
echo 스크립트 완료.
