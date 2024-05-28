@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo 코드 [SRV-084] 시스템 핵심 파일 권한 설정 >> "%TMP1%"
echo [양호]: 시스템 핵심 파일이 적절한 권한으로 설정됨 >> "%TMP1%"
echo [취약]: 시스템 핵심 파일이 적절한 권한으로 설정되지 않음 >> "%TMP1%"

:: PATH 환경 변수에서 잠재적으로 안전하지 않은 항목 검사
echo PATH에서 안전하지 않은 항목 검사 중 >> "%TMP1%"
set "insecure=0"

for %%A in (%PATH:;= %) do (
    if "%%A"=="." (
        set /a insecure+=1
        echo 경고: PATH에 "."이 포함되어 있어 안전하지 않을 수 있음 >> "%TMP1%"
    )
)

if %insecure% equ 0 (
    echo OK: PATH에 안전하지 않은 항목이 포함되지 않음 >> "%TMP1%"
) else (
    echo 경고: PATH에 안전하지 않은 항목이 포함됨 >> "%TMP1%"
)

:: 결과 표시
type "%TMP1%"

echo.
echo 스크립트 완료.
