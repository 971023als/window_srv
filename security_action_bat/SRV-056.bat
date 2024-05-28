@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo 코드 [SRV-046] 웹 서비스 경로 설정 미흡 >> "%TMP1%"
echo [양호]: 웹 서비스의 경로 설정이 안전하게 구성됨 >> "%TMP1%"
echo [취약]: 웹 서비스의 경로 설정이 안전하지 않게 구성됨 >> "%TMP1%"

:: Windows에서 Apache 및 Nginx 설정 파일 경로 설정
set "APACHE_CONFIG_FILE=C:\Apache24\conf\apache2.conf"
set "NGINX_CONFIG_FILE=C:\nginx\conf\nginx.conf"

:: Apache 설정에서 안전한 경로 설정 확인
if exist "%APACHE_CONFIG_FILE%" (
    findstr /R /C:"^ *<Directory" /C:"Options -Indexes" "%APACHE_CONFIG_FILE%" >nul
    if not errorlevel 1 (
        echo OK: Apache 설정에서 안전한 경로 설정이 확인됨: "%APACHE_CONFIG_FILE%" >> "%TMP1%"
    ) else (
        echo WARN: Apache 설정에서 안전하지 않은 경로 설정이 확인됨: "%APACHE_CONFIG_FILE%" >> "%TMP1%"
    )
) else (
    echo INFO: Apache 설정 파일이 존재하지 않음: "%APACHE_CONFIG_FILE%" >> "%TMP1%"
)

:: Nginx 설정에서 안전한 경로 설정 확인
if exist "%NGINX_CONFIG_FILE%" (
    findstr /R /C:"^ *location" "%NGINX_CONFIG_FILE%" >nul
    if not errorlevel 1 (
        echo OK: Nginx 설정에서 안전한 경로 설정이 확인됨: "%NGINX_CONFIG_FILE%" >> "%TMP1%"
    ) else (
        echo WARN: Nginx 설정에서 안전하지 않은 경로 설정이 확인됨: "%NGINX_CONFIG_FILE%" >> "%TMP1%"
    )
) else (
    echo INFO: Nginx 설정 파일이 존재하지 않음: "%NGINX_CONFIG_FILE%" >> "%TMP1%"
)

:: 결과 표시
type "%TMP1%"

echo.
echo 스크립트 완료.
