# 스크립트 이름과 로그 파일 설정
$SCRIPTNAME = $MyInvocation.MyCommand.Name.Replace(".ps1", "")
$TMP1 = "$SCRIPTNAME.log"

# 로그 파일 초기화
"" | Set-Content -Path $TMP1

# 로그 파일에 헤더 및 정보 추가
"BAR" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-173] DNS 서비스의 취약한 동적 업데이트 설정" | Out-File -FilePath $TMP1 -Append
"[양호]: DNS 동적 업데이트가 안전하게 구성된 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: DNS 동적 업데이트가 취약하게 구성된 경우" | Out-File -FilePath $TMP1 -Append
"BAR" | Out-File -FilePath $TMP1 -Append

# DNS 설정 확인
$dnsZones = Get-DnsServerZone
$vulnerableZones = $dnsZones | Where-Object { $_.IsDsIntegrated -eq $false -and $_.DynamicUpdate -ne 'None' }

if ($vulnerableZones) {
    foreach ($zone in $vulnerableZones) {
        "WARN DNS 동적 업데이트 설정이 취약합니다: $($zone.ZoneName)" | Out-File -FilePath $TMP1 -Append
    }
} else {
    "OK DNS 동적 업데이트가 안전하게 구성되어 있습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1 | Write-Output
