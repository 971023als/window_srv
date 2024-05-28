@echo off
setlocal enabledelayedexpansion

set "TMP1=%SCRIPTNAME%.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-021] FTP 서비스 접근 제어 설정 미비 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: ftpusers 파일의 소유자가 root이고, 권한이 640 이하인 경우 >> !TMP1!
echo [취약]: ftpusers 파일의 소유자가 root가 아니고, 권한이 640 이상인 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: FTP 서비스 사용자 접근 제어 설정 확인 (PowerShell 사용)
powershell -Command "& {
    $FtpSites = Get-WebSite | Where-Object { $_.bindings -match 'ftp' };
    foreach ($site in $FtpSites) {
        $siteName = $site.name;
        $FtpAuthorizationRules = Get-WebConfigurationProperty -filter '/system.ftpServer/security/authorization' -PSPath 'IIS:\Sites\'$siteName -name '.collection';
        If ($FtpAuthorizationRules) {
            foreach ($rule in $FtpAuthorizationRules) {
                If ($rule.Permissions -match 'Read, Write' -and $rule.Users -match 'anonymous') {
                    Add-Content !TMP1! ('WARN: ' + $siteName + ' FTP 사이트에서 anonymous 사용자에게 읽기/쓰기 권한이 부여됨');
                } Else {
                    Add-Content !TMP1! ('OK: ' + $siteName + ' FTP 사이트에서 접근 제어가 적절함');
                }
            }
        } Else {
            Add-Content !TMP1! 'INFO: ' + $siteName + ' FTP 사이트에 설정된 권한 규칙이 없습니다.';
        }
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
