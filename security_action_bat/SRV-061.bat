@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo 코드 [SRV-058] 웹 서비스의 불필요한 스크립트 매핑 >> "%TMP1%"
echo [양호]: 웹 서비스에 불필요한 스크립트 매핑이 존재하지 않음 >> "%TMP1%"
echo [취약]: 웹 서비스에 불필요한 스크립트 매핑이 존재함 >> "%TMP1%"

:: Windows에서 Apache와 Nginx 설정 파일 경로 설정
set "APACHE_CONFIG_FILE=C:\path\to\apache\conf\httpd.conf"
set "NGINX_CONFIG_FILE=C:\path\to\nginx\conf\nginx.conf"

:: Apache에서 스크립트 매핑 확인
findstr /R "AddHandler AddType" "%APACHE_CONFIG_FILE%" >nul
if not errorlevel 1 (
    echo 경고: Apache에서 불필요한 스크립트 매핑이 발견됨: %APACHE_CONFIG_FILE% >> "%TMP1%"
) else (
    echo OK: Apache에서 불필요한 스크립트 매핑이 발견되지 않음: %APACHE_CONFIG_FILE% >> "%TMP1%"
)

:: Nginx에서 스크립트 매핑 확인
findstr /R "location ~ \.php$" "%NGINX_CONFIG_FILE%" >nul
if not errorlevel 1 (
    echo 경고: Nginx에서 불필요한 PHP 스크립트 매핑이 발견됨: %NGINX_CONFIG_FILE% >> "%TMP1%"
) else (
    echo OK: Nginx에서 불필요한 PHP 스크립트 매핑이 발견되지 않음: %NGINX_CONFIG_FILE% >> "%TMP1%"
)

:: 결과 표시
type "%TMP1%"

echo.
echo 스크립트 완료.
