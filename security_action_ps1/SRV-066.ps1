# function.ps1 내용 포함 (적절한 경로 지정 필요)
. .\function.ps1

$TMP1 = "$(Get-Location)\SRV-066_log.txt"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-066] DNS Zone Transfer 설정 미흡"

Add-Content -Path $TMP1 -Value $CODE

BAR

# Windows DNS 서버에서 모든 DNS Zone의 Zone Transfer 설정 확인 및 조정
Import-Module DNSServer

$dnsZones = Get-DnsServerZone
foreach ($zone in $dnsZones) {
    $zoneName = $zone.ZoneName
    $zoneTransferSetting = Get-DnsServerZoneTransfer -Name $zoneName

    # Zone Transfer 설정이 None이거나, 특정 IP로 제한되어 있는지 확인
    if ($zoneTransferSetting -and ($zoneTransferSetting.AllowTransfer -eq "None" -or $zoneTransferSetting.AllowTransfer -match "^(\d{1,3}\.){3}\d{1,3}$")) {
        OK "DNS Zone '$zoneName'의 Zone Transfer가 안전하게 제한됩니다."
    } else {
        # Zone Transfer를 특정 IP로 제한 (예: 192.168.1.100)
        # 실제 환경에서는 적절한 IP 주소로 변경해야 합니다.
        $allowedTransferIP = "192.168.1.100"
        Set-DnsServerZoneTransfer -Name $zoneName -TransferType SpecificIPs -IPAddresses $allowedTransferIP
        WARN "DNS Zone '$zoneName'의 Zone Transfer 설정이 '$allowedTransferIP'로 조정되었습니다."
    }
}

Get-Content -Path $TMP1 | Out-Host

Write-Host "`n스크립트 완료. DNS Zone Transfer 설정이 조정되었습니다."
