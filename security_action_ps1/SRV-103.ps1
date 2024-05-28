function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

$SCRIPTNAME = $MyInvocation.MyCommand.Name
$global:TMP1 = "$(Get-Location)\${SCRIPTNAME}_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[SRV-103] LAN Manager 인증 수준 미흡"

Add-Content -Path $global:TMP1 -Value "[양호]: LAN Manager 인증 수준이 적절하게 설정되어 있는 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: LAN Manager 인증 수준이 미흡하게 설정되어 있는 경우"

BAR

# LAN Manager 인증 수준 확인 및 조정
$path = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$name = "LmCompatibilityLevel"
$desiredLevel = 5 # 'LM 및 NTLM 응답 거부(NTLMv2 세션 보안만 사용)' 설정
$lmCompLevel = Get-ItemProperty -Path $path -Name $name -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $name

if ($lmCompLevel -lt $desiredLevel) {
    Set-ItemProperty -Path $path -Name $name -Value $desiredLevel
    Add-Content -Path $global:TMP1 -Value "UPDATED: LAN Manager 인증 수준이 안전한 설정($desiredLevel)으로 변경되었습니다."
} else {
    Add-Content -Path $global:TMP1 -Value "OK: LAN Manager 인증 수준이 이미 안전한 설정($lmCompLevel)으로 되어 있습니다."
}

Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n스크립트 완료."
