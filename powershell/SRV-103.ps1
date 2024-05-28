$TMP1 = "$(SCRIPTNAME).log"
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-103] LAN Manager 인증 수준 미흡"

Add-Content -Path $TMP1 -Value "[양호]: LAN Manager 인증 수준이 적절하게 설정되어 있는 경우"
Add-Content -Path $TMP1 -Value "[취약]: LAN Manager 인증 수준이 미흡하게 설정되어 있는 경우"

BAR

# LAN Manager 인증 수준 확인
$path = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$name = "LmCompatibilityLevel"
$lmCompLevel = Get-ItemProperty -Path $path -Name $name -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $name

# LAN Manager 인증 수준 평가
switch ($lmCompLevel) {
    0 { Add-Content -Path $TMP1 -Value "WARN: LAN Manager 인증 수준이 'LM 및 NTLM 응답 보내기(보안성이 낮음)'로 설정되어 있습니다." }
    1 { Add-Content -Path $TMP1 -Value "WARN: LAN Manager 인증 수준이 'LM 응답 보내기'로 설정되어 있습니다." }
    2 { Add-Content -Path $TMP1 -Value "OK: LAN Manager 인증 수준이 'NTLM 응답만 보내기'로 설정되어 있습니다." }
    3 { Add-Content -Path $TMP1 -Value "OK: LAN Manager 인증 수준이 'NTLMv2 응답만 보내기\refuse LM'로 설정되어 있습니다." }
    4 { Add-Content -Path $TMP1 -Value "OK: LAN Manager 인증 수준이 'NTLMv2 응답만 보내기\refuse LM 및 NTLM'로 설정되어 있습니다." }
    5 { Add-Content -Path $TMP1 -Value "OK: LAN Manager 인증 수준이 'LM 및 NTLM 응답 거부(NTLMv2 세션 보안만 사용)'로 설정되어 있습니다." }
    Default { Add-Content -Path $TMP1 -Value "INFO: LAN Manager 인증 수준이 설정되지 않았거나 알 수 없는 값입니다." }
}

Get-Content -Path $TMP1

Write-Host "`n"
