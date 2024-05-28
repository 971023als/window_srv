# 방화벽 규칙을 통해 원격 터미널 접속 가능한 사용자 그룹 제한 확인
$sshRule = Get-NetFirewallRule -DisplayName "SSH" -ErrorAction SilentlyContinue

if ($sshRule -ne $null) {
    $sshRuleEnabled = $sshRule | Get-NetFirewallPortFilter | Where-Object { $_.LocalPort -eq 22 -and $_.Protocol -eq "TCP" }
    if ($sshRuleEnabled -ne $null) {
        Write-Host "SSH 접속이 특정 그룹에게만 제한된 경우: 양호"
    } else {
        Write-Host "SSH 접속이 특정 그룹에게만 제한되지 않은 경우: 취약"
    }
} else {
    Write-Host "SSH 관련 방화벽 규칙이 설정되어 있지 않습니다."
}
