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
    # Exchange 서버의 메일 queue 처리 권한 설정 확인을 위한 실제 명령어 구현 필요
    # 예시 코드는 실제 명령어로 대체해야 합니다.
    $MailQueuePermissions = '가정된 설정 확인 결과'; # 실제로는 Get-Queue 등의 cmdlet을 사용하여 권한 설정을 확인
    If ('$MailQueuePermissions' -eq '적절한 설정') {
        Add-Content !TMP1! 'OK: SMTP 서비스의 메일 queue 처리 권한을 업무 관리자에게만 부여되도록 설정됨.';
    } Else {
        Add-Content !TMP1! 'WARN: SMTP 서비스의 메일 queue 처리 권한 설정이 미흡함.';
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
