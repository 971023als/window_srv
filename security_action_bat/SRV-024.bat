@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-024] 취약한 Telnet 인증 방식 사용 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: Telnet 서비스가 비활성화되어 있거나 보안 인증 방식을 사용하는 경우 >> !TMP1!
echo [취약]: Telnet 서비스가 활성화되어 있고 보안 인증 방식을 사용하지 않는 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: Telnet 서비스 상태 확인 (PowerShell 사용)
powershell -Command "& {
    $TelnetService = Get-Service -Name 'TlntSvr' -ErrorAction SilentlyContinue;
    if ($TelnetService -and $TelnetService.Status -eq 'Running') {
        Add-Content !TMP1! 'WARN: Telnet 서비스가 활성화되어 있습니다. 추가 보안 설정 확인이 필요할 수 있습니다.';
        # Telnet 보안 인증 방식 확인 로직 (가정)
        # 여기에 Telnet 서비스의 보안 인증 방식을 확인하는 PowerShell 스크립트 추가
        # 실제 환경에서는 해당 설정을 직접 확인하는 명령어로 대체
        $TelnetSecurity = '가정된 보안 설정 확인 결과';
        If ('$TelnetSecurity' -eq '보안 인증 방식 사용') {
            Add-Content !TMP1! 'OK: Telnet 서비스가 보안 인증 방식을 사용하고 있습니다.';
        } Else {
            Add-Content !TMP1! 'WARN: Telnet 서비스가 보안 인증 방식을 사용하지 않고 있습니다.';
        }
    } else {
        Add-Content !TMP1! 'OK: Telnet 서비스가 비활성화되어 있습니다.';
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
