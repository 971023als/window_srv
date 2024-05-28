@echo off
setlocal EnableDelayedExpansion

:: 필요한 함수를 불러온다고 가정합니다. 실제로는 해당 함수의 구현이 필요합니다.
call function.bat

:: 스크립트 이름으로 로그 파일 이름 설정
set "SCRIPTNAME=%~n0"
set "TMP1=%SCRIPTNAME%.log"

:: 로그 파일 초기화
type NUL > "%TMP1%"

:: 구분선 함수 호출
call :BAR

:: 로그 파일에 코드와 기준 정보 기록
echo CODE [SRV-165] 불필요하게 Shell이 부여된 계정 존재 >> "%TMP1%"
echo [양호]: 불필요하게 Shell이 부여된 계정이 존재하지 않는 경우 >> "%TMP1%"
echo [취약]: 불필요하게 Shell이 부여된 계정이 존재하는 경우 >> "%TMP1%"
call :BAR

:: 모든 사용자 계정 나열
echo 모든 사용자 계정: >> "%TMP1%"
for /f "skip=4 delims=" %%i in ('net user') do (
    set "account=%%i"
    set "account=!account:  =!"
    if "!account!" NEQ "명령이 성공했습니다." (
        echo 계정: !account! >> "%TMP1%"
    )
)

:: 결과 확인 메시지
echo 결과를 확인하세요. >> "%TMP1%"

:: 결과 표시
type "%TMP1%"

echo.
goto :eof

:BAR
echo ---------------------------------------- >> "%TMP1%"
goto :eof
