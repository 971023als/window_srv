function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

$SCRIPTNAME = $MyInvocation.MyCommand.Name
$global:TMP1 = "$(Get-Location)\${SCRIPTNAME}_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[SRV-090] 불필요한 원격 레지스트리 서비스 활성화"

Add-Content -Path $global:TMP1 -Value "[양호]: 원격 레지스트리 서비스가 비활성화되어 있는 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: 원격 레지스트리 서비스가 활성화되어 있는 경우"

BAR

# 원격 레지스트리 서비스 상태 확인 및 비활성화 조치
$serviceStatus = Get-Service -Name "RemoteRegistry" -ErrorAction SilentlyContinue

if ($serviceStatus -and $serviceStatus.Status -eq "Running") {
    # 서비스 비활성화
    Set-Service -Name "RemoteRegistry" -StartupType Disabled
    Stop-Service -Name "RemoteRegistry"
    Add-Content -Path $global:TMP1 -Value "FIXED: 원격 레지스트리 서비스가 비활성화되었습니다."
} else {
    Add-Content -Path $global:TMP1 -Value "OK: 원격 레지스트리 서비스가 이미 비활성화되어 있습니다."
}

Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n스크립트 완료."
