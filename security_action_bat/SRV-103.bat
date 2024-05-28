@echo off
setlocal enabledelayedexpansion

:: 스크립트 이름에서 로그 파일 이름 설정
set "SCRIPTNAME=%~n0"
set "TMP1=%SCRIPTNAME%.log"

:: 로그 파일 초기화
type nul > "%TMP1%"

echo ---------------------------------------- >> "%TMP1%"
echo CODE [SRV-103] LAN Manager 인증 수준 미흡 >> "%TMP1%"
echo ---------------------------------------- >> "%TMP1%"
echo [양호]: LAN Manager 인증 수준이 적절하게 설정되어 있는 경우 >> "%TMP1%"
echo [취약]: LAN Manager 인증 수준이 미흡하게 설정되어 있는 경우 >> "%TMP1%"
echo ---------------------------------------- >> "%TMP1%"

:: LAN Manager 인증 수준을 확인하는 코드
:: Windows 환경에서 레지스트리 설정을 통해 LAN Manager 인증 수준의 설정 상태 확인
:: 예를 들어, 레지스트리 키 접근 방법을 사용
powershell -Command "& {
    $regPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa';
    $lmCompatibilityLevel = (Get-ItemProperty -Path $regPath -Name 'lmCompatibilityLevel').lmCompatibilityLevel;
    if ($lmCompatibilityLevel -ge 3) {
        echo OK: LAN Manager 인증 수준이 적절하게 설정되어 있습니다. >> "%TMP1%";
    } else {
        echo WARN: LAN Manager 인증 수준이 미흡하게 설정되어 있습니다. >> "%TMP1%";
    }
}"

:: 결과 출력
type "%TMP1%"

echo.
echo Script complete.

endlocal
