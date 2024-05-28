$TMP1 = "$(SCRIPTNAME).log"
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-090] 불필요한 원격 레지스트리 서비스 활성화"

Add-Content -Path $TMP1 -Value "[양호]: 원격 레지스트리 서비스가 비활성화되어 있는 경우"
Add-Content -Path $TMP1 -Value "[취약]: 원격 레지스트리 서비스가 활성화되어 있는 경우"

BAR

# 원격 레지스트리 서비스 상태 확인
$serviceStatus = Get-Service -Name "RemoteRegistry" -ErrorAction SilentlyContinue

if ($serviceStatus -and $serviceStatus.Status -eq "Running") {
    Add-Content -Path $TMP1 -Value "WARN: 원격 레지스트리 서비스가 활성화되어 있습니다."
} else {
    Add-Content -Path $TMP1 -Value "OK: 원격 레지스트리 서비스가 비활성화되어 있습니다."
}

Get-Content -Path $TMP1

Write-Host "`n"
