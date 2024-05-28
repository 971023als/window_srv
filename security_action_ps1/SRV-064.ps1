# function.ps1 내용 포함
. .\function.ps1

$TMP1 = "$(Get-Location)\SRV-064_log.txt"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-064] 취약한 버전의 DNS 서비스 사용"
Add-Content -Path $TMP1 -Value $CODE

BAR

# Windows DNS 서비스의 실행 상태 확인
$dnsServiceStatus = Get-Service -Name "DNS" -ErrorAction SilentlyContinue

if ($dnsServiceStatus -ne $null -and $dnsServiceStatus.Status -eq "Running") {
    # 시스템 업데이트 상태 확인을 위한 대안적 접근 (예시: 시스템 정보 확인)
    $osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
    $lastBootUpTime = $osInfo.LastBootUpTime
    $currentTime = Get-Date
    $uptime = $currentTime - $lastBootUpTime

    # DNS 서버 업데이트를 위한 권장 절차 안내
    if ($uptime.Days -gt 30) {
        WARN "시스템이 최근 30일 이내에 재부팅되지 않았습니다. 최신 업데이트를 확인하고 적용하세요."
    } else {
        OK "시스템이 최근에 재부팅되었습니다. 업데이트가 적용되었을 수 있습니다. 추가 확인이 필요합니다."
    }
} else {
    OK "DNS 서비스가 실행되지 않고 있습니다."
}

Get-Content -Path $TMP1 | Out-Host

Write-Host "`n스크립트 완료."
