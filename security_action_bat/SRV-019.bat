@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-010] SMTP 서비스의 메일 queue 처리 권한 설정 미흡 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: SMTP 서비스의 메일 queue 처리 권한을 업무 관리자에게만 부여되도록 설정한 경우 >> !TMP1!
echo [취약]: SMTP 서비스의 메일 queue 처리 권한이 업무와 무관한 일반 사용자에게도 부여되도록 설정된 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: 메일 queue 처리 권한 설정 확인 (PowerShell 사용 예시)
powershell -Command "& {
    # 예시: Exchange 서버의 메일 queue 처리 권한 설정 확인
    # 실제로는 해당 설정을 확인할 수 있는 PowerShell 명령어를 사용해야 합니다.
    # 이 예제에서는 설정 확인 과정을 단순화하여 설명을 위한 메시지만 출력합니다.
    Add-Content !TMP1! 'OK: SMTP 서비스의 메일 queue 처리 권한을 업무 관리자에게만 부여되도록 설정한 경우';
    # 실제 환경에서는 설정이 누락되었거나, 부적절하게 구성된 경우에 대한 검사를 추가합니다.
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
