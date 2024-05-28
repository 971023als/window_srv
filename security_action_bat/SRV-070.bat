@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo 코드 [SRV-070] 비밀번호 관리 정책 설정 미흡 >> "%TMP1%"
echo [양호]: 서버의 비밀번호 관리 정책이 적절하게 설정됨 >> "%TMP1%"
echo [취약]: 서버의 비밀번호 관리 정책이 불충분하게 설정됨 >> "%TMP1%"

:: 로컬 비밀번호 정책 확인
echo 로컬 비밀번호 정책 확인 중: >> "%TMP1%"
net accounts >> "%TMP1%"

:: 보다 복잡한 정책 검사에 대한 주의사항
echo 보다 상세한 비밀번호 정책 검사나 수정을 위해서는 로컬 보안 정책 MMC 스냅인(secpol.msc) 또는 도메인 환경에서 그룹 정책 관리 콘솔(gpmc.msc) 사용을 고려하세요. >> "%TMP1%"
echo 추가적으로, PowerShell 스크립트는 비밀번호 정책의 상세 분석 및 관리 기능을 제공할 수 있습니다. >> "%TMP1%"

:: 결과 표시
type "%TMP1%"

echo.
echo 스크립트 완료.
