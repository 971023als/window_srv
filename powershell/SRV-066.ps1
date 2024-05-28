# function.ps1 내용 포함 (적절한 경로 지정 필요)
. .\function.ps1

$TMP1 = "$(SCRIPTNAME).log"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-066] DNS Zone Transfer 설정 미흡"

Add-Content -Path $TMP1 -Value "[양호]: DNS Zone Transfer가 안전하게 제한되어 있는 경우"
Add-Content -Path $TMP1 -Value "[취약]: DNS Zone Transfer가 적절하게 제한되지 않은 경우"

BAR

# PowerShell을 사용하여 'named' 프로세스의 수 확인
$ps_dns_count = (Get-Process -Name "named" -ErrorAction SilentlyContinue).Count
if ($ps_dns_count -gt 0) {
    if (Test-Path "/etc/named.conf") {
        # /etc/named.conf에서 'allow-transfer { any; }' 설정 검색
        $etc_namedconf_allowtransfer_count = (Select-String -Path "/etc/named.conf" -Pattern "allow-transfer.*any" -CaseSensitive -NotMatch "^#|^\\s#" | Measure-Object).Count
        if ($etc_namedconf_allowtransfer_count -gt 0) {
            Add-Content -Path $TMP1 -Value "WARN: /etc/named.conf 파일에 'allow-transfer { any; }' 설정이 있습니다."
        } else {
            Add-Content -Path $TMP1 -Value "※ U-34 결과 : 양호(Good)"
        }
    }
} else {
    Add-Content -Path $TMP1 -Value "※ U-34 결과 : 양호(Good)"
}

Get-Content -Path $TMP1

Write-Host "`n"
