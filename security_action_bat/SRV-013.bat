@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-013] Anonymous 계정의 FTP 서비스 접속 제한 미비 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: Anonymous FTP (익명 ftp) 접속을 차단한 경우 >> !TMP1!
echo [취약]: Anonymous FTP (익명 ftp) 접속을 차단하지 않는 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: 익명 FTP 접속 제한 설정 확인 (PowerShell 사용)
powershell -Command "& {
    $FtpSites = Get-WebSite | Where-Object { $_.bindings -match 'ftp' };
    foreach ($site in $FtpSites) {
        $siteName = $site.name;
        $FtpSettings = Get-WebConfigurationProperty -filter '/system.applicationHost/sites/site[@name='"'$siteName'"']/ftpServer/security/authorization' -PSPath 'MACHINE/WEBROOT/APPHOST' -name '.';
        $AnonymousAccess = $FtpSettings.Collection | Where-Object { $_.accessType -eq 'Allow' -and $_.users -eq 'anonymous' };
        if ($AnonymousAccess) {
            Add-Content !TMP1! ('WARN: ' + $siteName + ' FTP 사이트에서 Anonymous 접속이 허용됩니다.');
        } else {
            Add-Content !TMP1! ('OK: ' + $siteName + ' FTP 사이트에서 Anonymous 접속이 차단됩니다.');
        }
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
