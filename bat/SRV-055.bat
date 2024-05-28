@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo 코드 [SRV-055] 웹 서비스 설정 파일 노출 >> "%TMP1%"
echo [양호]: 웹 서비스 설정 파일이 외부에서 접근 불가능함 >> "%TMP1%"
echo [취약]: 웹 서비스 설정 파일이 외부에서 접근 가능함 >> "%TMP1%"

:: IIS 웹.config 설정 파일의 예시 경로
set "IIS_CONFIG=%SystemRoot%\System32\inetsrv\config\applicationHost.config"

:: IIS 설정 파일 권한 확인
if exist "%IIS_CONFIG%" (
    icacls "%IIS_CONFIG%" | findstr /C:"Everyone:(N)" >nul
    if not errorlevel 1 (
        echo 경고: IIS 설정 파일 (%IIS_CONFIG%) 권한이 취약함. >> "%TMP1%"
    ) else (
        echo OK: IIS 설정 파일 (%IIS_CONFIG%)이 외부 접근으로부터 보호됨. >> "%TMP1%"
    )
) else (
    echo 정보: IIS 설정 파일 (%IIS_CONFIG%)이 존재하지 않음. >> "%TMP1%"
)

:: 결과 표시
type "%TMP1%"

echo.
echo 스크립트 완료.
