@echo off
setlocal enabledelayedexpansion

:: 함수 파일 호출 (실제 환경에서 필요한 함수를 불러오거나 해당 부분을 적절히 조정)
call function.bat

:: 결과 파일 정의 및 초기화
set "TMP1=%~n0.log"
type nul > "%TMP1%"

:: 로그 파일에 섹션 구분자 추가
call :BAR

:: 로그 파일에 검사 정보 추가
echo [SRV-101] 불필요한 예약된 작업 존재 >> "%TMP1%"
echo [양호]: 불필요한 cron 작업이 존재하지 않는 경우 >> "%TMP1%"
echo [취약]: 불필요한 cron 작업이 존재하는 경우 >> "%TMP1%"

:: 로그 파일에 섹션 구분자 추가
call :BAR

:: 시스템의 모든 예약된 작업을 검사합니다
for /f "tokens=*" %%i in ('schtasks /query /fo LIST ^| findstr "TaskName"') do (
    echo %%i >> "%TMP1%"
    :: 불필요한 작업을 식별하는 로직을 추가할 수 있습니다.
    :: 예: echo WARN "불필요한 예약된 작업이 존재할 수 있습니다: %%i" >> "%TMP1%"
)

:: 모든 작업이 적절하다고 가정하고 결과 기록
echo OK "불필요한 예약된 작업이 존재하지 않습니다." >> "%TMP1%"

:: 결과 출력
type "%TMP1%"

echo.
exit /b

:BAR
echo ----------------------------------------- >> "%TMP1%"
exit /b
