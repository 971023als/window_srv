@echo off
SetLocal EnableDelayedExpansion

set "SCRIPTNAME=%~n0"
set "TMP1=%SCRIPTNAME%.log"

:: 로그 파일 초기화
type NUL > "%TMP1%"

echo BAR >> "%TMP1%"
echo CODE [SRV-173] DNS 서비스의 취약한 동적 업데이트 설정 >> "%TMP1%"
echo [양호]: DNS 동적 업데이트가 안전하게 구성된 경우 >> "%TMP1%"
echo [취약]: DNS 동적 업데이트가 취약하게 구성된 경우 >> "%TMP1%"
echo BAR >> "%TMP1%"

:: DNS 설정 확인 (PowerShell을 사용)
PowerShell -Command "& {
    $dnsZones = Get-DnsServerZone;
    $vulnerableZones = $dnsZones | Where-Object { $_.IsDsIntegrated -eq $false -and $_.DynamicUpdate -ne 'None' };
    if ($vulnerableZones) {
        'WARN DNS 동적 업데이트 설정이 취약합니다: ' + $vulnerableZones.ZoneName
    } else {
        'OK DNS 동적 업데이트가 안전하게 구성되어 있습니다.'
    }
}" >> "%TMP1%"

type "%TMP1%"

EndLocal
