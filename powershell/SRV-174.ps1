# DNS 서비스의 실행 상태를 확인합니다.
# 이 스크립트는 Windows 환경에서 DNS 서버 역할이 설치되어 있는지 확인합니다.

# DNS 서버 서비스의 상태를 가져옵니다.
$dnsServiceStatus = Get-Service -Name 'DNS' -ErrorAction SilentlyContinue

if ($null -ne $dnsServiceStatus) {
    # DNS 서비스의 상태를 확인합니다.
    if ($dnsServiceStatus.Status -eq 'Running') {
        Write-Host "DNS 서비스가 활성화되어 있습니다. - 취약"
    } else {
        Write-Host "DNS 서비스가 비활성화되어 있습니다. - 양호"
    }
} else {
    Write-Host "DNS 서비스가 이 시스템에 설치되어 있지 않습니다. - 정보"
}
