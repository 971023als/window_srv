@echo off
setlocal

:: 결과 파일 정의 및 초기화
set "TMP1=%SCRIPTNAME%.log"
type NUL > "%TMP1%"

:: 로그 파일에 헤더 정보 추가
echo ---------------------------------------- >> "%TMP1%"
echo CODE [SRV-158] 불필요한 Telnet 서비스 실행 >> "%TMP1%"
echo ---------------------------------------- >> "%TMP1%"

:: Telnet 서비스 상태 평가
echo [양호]: Telnet 서비스가 비활성화되어 있는 경우 >> "%TMP1%"
echo [취약]: Telnet 서비스가 활성화되어 있는 경우 >> "%TMP1%"
echo ---------------------------------------- >> "%TMP1%"

:: Telnet 서비스 상태 확인
sc query TlntSvr | findstr /C:"STATE" >> "%TMP1%"
if %ERRORLEVEL% == 0 (
    echo WARN: Telnet 서비스가 실행 중입니다. >> "%TMP1%"
) else (
    echo OK: Telnet 서비스가 비활성화되어 있습니다. >> "%TMP1%"
)

:: FTP 서비스 관련 파일 존재 여부 확인
:: 여기에 적절한 경로와 파일 이름을 지정
set "FTPConfigFile=C:\path\to\ftp\config\file.txt"
if exist "%FTPConfigFile%" (
    echo INFO: FTP 설정 파일이 존재합니다: %FTPConfigFile% >> "%TMP1%"
) else (
    echo INFO: FTP 설정 파일이 존재하지 않습니다: %FTPConfigFile% >> "%TMP1%"
)

:: 결과 출력
echo ---------------------------------------- >> "%TMP1%"
type "%TMP1%"

echo.
echo Script complete.
endlocal
