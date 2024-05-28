@echo off
call function.bat

set TMP1=SCRIPTNAME.log
type nul > %TMP1%

call :BAR

echo [SRV-097] FTP 서비스 디렉터리 접근권한 설정 미흡 >> %TMP1%

echo [양호]: FTP 서비스 디렉터리의 접근 권한이 적절하게 설정된 경우 >> %result%
echo [취약]: FTP 서비스 디렉터리의 접근 권한이 적절하지 않게 설정된 경우 >> %result%

call :BAR

:: FTP 서비스 실행 여부 확인
for /f "tokens=*" %%i in ('netstat -an ^| find "LISTENING" ^| find ":21 "') do (
    echo WARN: FTP 서비스가 실행 중입니다. >> %TMP1%
)

:: FTP 디렉터리 권한 확인 (예시 경로: C:\FTP)
icacls "C:\FTP" >> %TMP1%

:: 결과 파일 출력
type %result%
type %TMP1%

echo.
goto :eof

:BAR
echo -----------------------------------------
goto :eof
