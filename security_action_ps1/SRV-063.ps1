# PowerShell 함수 파일 포함 (예: function.ps1)
. .\function.ps1

$TMP1 = "SRV-063_log.txt"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-063] DNS Recursive Query 설정 조치"
Add-Content -Path $TMP1 -Value $CODE

BAR

# Windows DNS 서버에서 재귀적 쿼리 설정 변경
Import-Module DNSServer

# 재귀 설정 변경
Set-DnsServerSetting -RecursionScope "OnlySecure" -Confirm:$false

# 변경 후 설정 확인
$recursionSetting = Get-DnsServerSetting | Select-Object -ExpandProperty RecursionScope

Switch ($recursionSetting) {
    "OnlySecure" { OK "DNS 서버에서 재귀적 쿼리가 안전하게 제한됨: $recursionSetting" }
    Default { WARN "DNS 서버에서 재귀적 쿼리 설정 변경 시도 실패: $recursionSetting" }
}

Get-Content -Path $TMP1 | Out-Host

Write-Host "`n스크립트 완료. DNS 서버의 재귀적 쿼리 설정이 변경되었습니다."
