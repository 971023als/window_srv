@echo off
setlocal enabledelayedexpansion

:: 스크립트 이름에서 로그 파일 이름 설정
set "SCRIPTNAME=%~n0"
set "TMP1=%SCRIPTNAME%.log"

:: 로그 파일 초기화
type nul > %TMP1%

echo ------------------------------------------------ >> %TMP1%
echo CODE [SRV-104] 보안 채널 데이터 디지털 암호화 또는 서명 기능 비활성화 >> %TMP1%
echo ------------------------------------------------ >> %TMP1%
echo [양호]: 보안 채널 데이터의 디지털 암호화 및 서명 기능이 활성화되어 있는 경우 >> %TMP1%
echo [취약]: 보안 채널 데이터의 디지털 암호화 및 서명 기능이 비활성화되어 있는 경우 >> %TMP1%
echo ------------------------------------------------ >> %TMP1%

:: Windows 환경에서 레지스트리 설정을 통해 보안 채널 데이터의 디지털 암호화 및 서명 기능 활성화 여부 확인
:: 예제: SMB 서명 활성화 여부 확인을 위한 레지스트리 키 접근 방법
powershell -Command "& {
    $regPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters';
    $smbSigningEnabled = (Get-ItemProperty -Path $regPath -Name 'RequireSecuritySignature').RequireSecuritySignature;
    if ($smbSigningEnabled -eq 1) {
        echo OK: 보안 채널 데이터의 디지털 암호화 및 서명 기능이 활성화되어 있습니다. >> %TMP1%;
    } else {
        echo WARN: 보안 채널 데이터의 디지털 암호화 및 서명 기능이 비활성화되어 있습니다. >> %TMP1%;
    }
}"

:: 결과 출력
type %TMP1%

echo.
echo Script complete.

endlocal
