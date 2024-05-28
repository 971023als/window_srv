function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

$SCRIPTNAME = $MyInvocation.MyCommand.Name
$global:TMP1 = "$(Get-Location)\${SCRIPTNAME}_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[SRV-104] 보안 채널 데이터 디지털 암호화 또는 서명 기능 비활성화"

Add-Content -Path $global:TMP1 -Value "[양호]: 보안 채널 데이터의 디지털 암호화 및 서명 기능이 활성화되어 있는 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: 보안 채널 데이터의 디지털 암호화 및 서명 기능이 비활성화되어 있는 경우"

BAR

# SMB 서버 및 클라이언트 서명 설정 활성화
$smbServerPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
$smbClientPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters"

Set-ItemProperty -Path $smbServerPath -Name "RequireSecuritySignature" -Value 1
Set-ItemProperty -Path $smbClientPath -Name "RequireSecuritySignature" -Value 1

Add-Content -Path $global:TMP1 -Value "UPDATED: SMB 서버 및 클라이언트의 디지털 서명 기능이 활성화되었습니다."

Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n스크립트 완료."
