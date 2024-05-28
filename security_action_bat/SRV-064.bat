# DNS 서버의 버전 확인
$dnsServer = Get-WmiObject -Namespace "root\MicrosoftDNS" -Class "MicrosoftDNS_Server"

if ($dnsServer) {
    $version = $dnsServer.Version
    Write-Host "DNS 서버 버전: $version"
    
    # 예시 버전 확인 로직 (실제 버전 번호에 따라 조정 필요)
    if ($version -ge "버전_번호") {
        Write-Host "양호: DNS 서비스가 최신 버전으로 업데이트되어 있습니다."
    } else {
        Write-Host "취약: DNS 서비스가 최신 버전으로 업데이트되어 있지 않습니다."
    }
} else {
    Write-Host "DNS 서비스 정보를 찾을 수 없습니다."
}
