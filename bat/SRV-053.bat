@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo 코드 [SRV-046] 웹 서비스 경로 설정 미흡 >> "%TMP1%"
echo [양호]: 웹 서비스의 경로 설정이 안전하게 구성됨 >> "%TMP1%"
echo [취약]: 웹 서비스의 경로 설정이 안전하지 않게 구성됨 >> "%TMP1%"

:: IIS 웹.config 설정 파일의 예시 경로
set "IIS_CONFIG=%SystemRoot%\System32\inetsrv\config\applicationHost.config"

:: IIS 설정 파일에서 안전한 경로 설정 확인
if exist "%IIS_CONFIG%" (
    findstr /R /C:"<location path" /C:"allowOverride=\"true\"" "%IIS_CONFIG%" >nul
    if errorlevel 1 (
        echo OK: IIS 설정에서 안전한 경로 설정이 확인됨: "%IIS_CONFIG%" >> "%TMP1%"
    ) else (
        echo WARN: IIS 설정에서 안전하지 않은 경로 설정이 확인됨: "%IIS_CONFIG%" >> "%TMP1%"
    )
) else (
    echo INFO: IIS 설정 파일이 존재하지 않음: "%IIS_CONFIG%" >> "%TMP1%"
)

:: 결과 표시
type "%TMP1%"

echo.
echo 스크립트 완료.
