@echo off
setlocal

set "TMP1=%~n0.log"
> "%TMP1%"

echo 코드 [SRV-062] DNS 서비스 정보 노출 >> "%TMP1%"
echo [양호]: DNS 서비스 정보가 안전하게 보호됨 >> "%TMP1%"
echo [취약]: DNS 서비스 정보가 노출됨 >> "%TMP1%"

:: DNS 버전 숨김 및 불필요한 존 전송 사용 여부를 PowerShell을 사용하여 확인
echo DNS 서비스 구성에서 정보 노출 및 존 전송 설정을 확인 중입니다: >> "%TMP1%"
powershell -Command "& {
    $dnsServers = Get-DnsServer
    foreach ($server in $dnsServers) {
        $zoneTransfers = Get-DnsServerZoneTransfer -ComputerName $server.Name
        $hideVersion = Get-DnsServerSetting -ComputerName $server.Name | Select-Object -ExpandProperty DisableVersionQuery

        if ($hideVersion -eq $true) {
            Write-Output 'DNS 버전 정보가 숨겨져 있습니다.'
        } else {
            Write-Output 'DNS 버전 정보가 노출될 수 있습니다.'
        }

        foreach ($transfer in $zoneTransfers) {
            if ($transfer.AllowZoneTransfer -eq 'None') {
                Write-Output '불필요한 존 전송이 제한됩니다.'
            } else {
                Write-Output '불필요한 존 전송이 허용될 수 있습니다.'
            }
        }
    }
}" >> "%TMP1%"

:: 결과 표시
type "%TMP1%"

echo.
echo 스크립트 완료.
