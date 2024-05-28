@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo 코드 [SRV-082] 시스템 주요 디렉터리 권한 설정 >> "%TMP1%"
echo [양호]: 시스템 주요 디렉터리가 적절한 권한으로 설정됨 >> "%TMP1%"
echo [취약]: 시스템 주요 디렉터리가 적절한 권한으로 설정되지 않음 >> "%TMP1%"

:: PATH 환경 변수에서 안전하지 않은 항목 검사
echo PATH에서 안전하지 않은 항목 검사 중 >> "%TMP1%"
set "insecure=0"
for %%A in (%PATH:;= %) do (
    if "%%A"=="." (
        set /a insecure+=1
        echo 경고: PATH에 "."가 포함되어 있어 안전하지 않을 수 있음 >> "%TMP1%"
    )
)

if %insecure% equ 0 (
    echo 양호: PATH에 안전하지 않은 항목이 포함되어 있지 않음 >> "%TMP1%"
) else (
    echo 주의: PATH에 안전하지 않은 항목이 포함되어 있음 >> "%TMP1%"
)

:: 시스템 시작 스크립트 또는 디렉터리 검사를 위한 자리표시자
:: 예: Windows 시작 폴더의 파일 나열 (필요에 따라 경로 조정)
echo 일반적인 시작 위치의 파일 나열 중: >> "%TMP1%"
for %%D in ("%AppData%\Microsoft\Windows\Start Menu\Programs\Startup", "%ProgramData%\Microsoft\Windows\Start Menu\Programs\StartUp") do (
    if exist "%%~D" (
        echo %%~D 내의 파일: >> "%TMP1%"
        dir "%%~D" /b >> "%TMP1%"
    ) else (
        echo 정보: %%~D 존재하지 않음 >> "%TMP1%"
    )
)

:: 실제 권한 검사는 더 복잡한 스크립팅이나 PowerShell이 필요함

:: 결과 표시
type "%TMP1%"

echo.
echo 스크립트 완료.
