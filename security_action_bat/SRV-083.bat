@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo 코드 [SRV-083] 시스템 시작 스크립트 권한 설정 >> "%TMP1%"
echo [양호]: 시스템 시작 스크립트가 적절한 권한으로 설정됨 >> "%TMP1%"
echo [취약]: 시스템 시작 스크립트가 적절한 권한으로 설정되지 않음 >> "%TMP1%"

:: Windows 시작 스크립트 위치 (필요에 따라 조정)
set "STARTUP_DIR=%ProgramData%\Microsoft\Windows\Start Menu\Programs\Startup"

:: 시작 디렉터리의 실행 파일 나열
echo 시작 디렉터리의 스크립트 나열 중: >> "%TMP1%"
if exist "%STARTUP_DIR%" (
    for %%f in ("%STARTUP_DIR%\*.*") do (
        echo %%f >> "%TMP1%"
        :: 권한 검사를 위한 자리표시자 (실제 검사는 더 복잡한 스크립팅 또는 PowerShell이 필요)
        echo 정보: %%f의 권한을 수동으로 확인하거나 PowerShell을 사용하여 상세 분석하세요 >> "%TMP1%"
    )
) else (
    echo 정보: 시작 디렉터리가 존재하지 않음 >> "%TMP1%"
)

:: 결과 표시
type "%TMP1%"

echo.
echo 스크립트 완료.
