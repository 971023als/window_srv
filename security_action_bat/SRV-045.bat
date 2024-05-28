@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo 코드 [SRV-045] 웹 서비스 프로세스 권한 제한 미비 >> "%TMP1%"
echo [양호]: 웹 서비스 프로세스가 과도한 권한으로 실행되지 않음 >> "%TMP1%"
echo [취약]: 웹 서비스 프로세스가 과도한 권한으로 실행됨 >> "%TMP1%"

:: 여기에 웹 서버의 서비스 이름을 지정하세요 (예: Apache2.4 또는 IIS의 경우 W3SVC)
set "SERVICE_NAME=Apache2.4"

:: 서비스가 어떤 계정 아래에서 실행되고 있는지 확인
sc qc "%SERVICE_NAME%" | findstr /C:"SERVICE_START_NAME" >> "%TMP1%"

:: 주의: 계정이 과도한 권한을 가지고 있는지 결정하기 위해 수동 검토가 필요합니다.
echo 주의: 서비스 계정이 과도한 권한을 가지고 있지 않은지 수동으로 검토해 주세요. >> "%TMP1%"

:: 결과 표시
type "%TMP1%"

echo.
echo 스크립트 완료.
