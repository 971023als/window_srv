@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-011] 시스템 관리자 계정의 FTP 사용 제한 미비 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: FTP 서비스에서 시스템 관리자 계정의 접근이 제한되는 경우 >> !TMP1!
echo [취약]: FTP 서비스에서 시스템 관리자 계정의 접근이 제한되지 않는 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: 시스템 관리자 계정의 FTP 접근 제한 여부 확인 (PowerShell 사용 예시)
powershell -Command "& {
    # IIS FTP 서비스 설정 확인 또는 Windows FTP 서비스 설정 확인
    # 예: IIS FTP 계정 접근 제한 설정 확인
    $FtpAccountRestrictions = Get-WebConfigurationProperty -filter '/system.ftpServer/security/authorization' -PSPath 'IIS:\Sites\YourFtpSiteName' -name '.collection';
    If ($FtpAccountRestrictions -match 'root') {
        Add-Content !TMP1! 'OK: FTP 서비스에서 root 계정의 접근이 제한됩니다.';
    } Else {
        Add-Content !TMP1! 'WARN: FTP 서비스에서 root 계정의 접근이 제한되지 않습니다.';
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
