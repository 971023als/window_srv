@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo 코드 [SRV-081] Crontab 설정 파일 권한 설정 >> "%TMP1%"
echo [양호]: Crontab 설정 파일의 권한이 적절하게 설정됨 >> "%TMP1%"
echo [취약]: Crontab 설정 파일의 권한이 적절하게 설정되지 않음 >> "%TMP1%"

:: 스케줄된 작업 확인 (Linux에서 crontab을 확인하는 것과 동등)
echo 모든 스케줄된 작업 나열: >> "%TMP1%"
schtasks /query >> "%TMP1%" 2>&1

:: 중요 시스템 디렉터리의 권한 확인을 위한 자리표시자 (수동 검사 권장)
echo 권한 확인을 위해 PowerShell이나 Windows 보안 탭을 사용하여 중요 디렉터리 및 파일의 ACL을 수동으로 검토하세요. >> "%TMP1%"

:: 확인해야 할 예시 디렉터리/파일 (필요에 따라 경로 조정)
echo 다음의 권한을 확인하세요: C:\Windows\System32, C:\Windows\SysWOW64 및 기타 중요 경로. >> "%TMP1%"

:: 결과 표시
type "%TMP1%"

echo.
echo 스크립트 완료.
