@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
type nul > !TMP1!

echo ------------------------------------------------ >> !TMP1!
echo CODE [SRV-041] 웹 서비스의 CGI 스크립트 관리 미흡 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

echo [양호]: CGI 스크립트 관리가 적절하게 설정된 경우 >> !TMP1!
echo [취약]: CGI 스크립트 관리가 미흡한 경우 >> !TMP1!
echo ------------------------------------------------ >> !TMP1!

:: CGI 스크립트 실행 설정 확인 (PowerShell 사용)
powershell -Command "& {
    Import-Module WebAdministration;
    $cgiSettings = Get-WebConfiguration -Filter '/system.webServer/handlers' -PSPath 'IIS:\';
    $cgiHandlers = $cgiSettings.Collection | Where-Object { $_.path -eq '*.cgi' -or $_.path -eq '*.pl' };
    if ($cgiHandlers) {
        foreach ($handler in $cgiHandlers) {
            Add-Content !TMP1! ('WARN: CGI 스크립트 (' + $handler.path + ') 실행이 허용되어 있습니다.');
        }
    } else {
        Add-Content !TMP1! 'OK: CGI 스크립트 실행이 적절하게 제한되어 있습니다.';
    }
}"

echo ------------------------------------------------ >> !TMP1!
type !TMP1!

echo.
