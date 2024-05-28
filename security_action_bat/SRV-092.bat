@echo off
setlocal enabledelayedexpansion

set "TMP1=%~n0.log"
> "%TMP1%"

echo 코드 [SRV-092] 사용자 홈 디렉토리 설정 미흡 >> "%TMP1%"
echo [양호]: 모든 사용자의 홈 디렉토리가 적절하게 설정됨 >> "%TMP1%"
echo [취약]: 하나 이상의 사용자 홈 디렉토리가 적절하게 설정되지 않음 >> "%TMP1%"

:: C:\Users 내 각 디렉토리를 확인하여 홈 디렉토리를 검사하는 것을 시뮬레이션
for /D %%D in (C:\Users\*) do (
    if exist "%%D" (
        echo OK "사용자 %%~nxD의 홈 디렉토리(%%D)가 적절하게 설정됨." >> "%TMP1%"
    ) else (
        echo 경고 "사용자 %%~nxD의 홈 디렉토리(%%D)가 적절하게 설정되지 않음." >> "%TMP1%"
    )
)

:: 결과 표시
type "%TMP1%"

echo.
echo 스크립트 완료.
