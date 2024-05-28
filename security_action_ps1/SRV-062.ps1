# PowerShell 함수 파일 포함 (예: function.ps1)
. .\function.ps1

$TMP1 = "$(SCRIPTNAME).log"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-062] DNS 서비스 정보 노출"

$result = "결과 파일 경로를 지정해야 함"
# 결과 파일에 내용 추가
Add-Content -Path $result -Value "[양호]: DNS 서비스 정보가 안전하게 보호되고 있는 경우"
Add-Content -Path $result -Value "[취약]: DNS 서비스 정보가 노출되고 있는 경우"

BAR

# DNS 설정 파일 경로
$DNS_CONFIG_FILE = "/etc/bind/named.conf" # BIND 사용 예시, 실제 환경에 따라 달라질 수 있음

# 버전 정보 숨김 옵션 확인
If (Select-String -Path $DNS_CONFIG_FILE -Pattern "version `"none`"" -Quiet) {
    OK "DNS 서비스에서 버전 정보가 숨겨져 있습니다."
} Else {
    WARN "DNS 서비스에서 버전 정보가 노출될 수 있습니다."
}

# 불필요한 전송 허용 확인
If (Select-String -Path $DNS_CONFIG_FILE -Pattern "allow-transfer" -Quiet) {
    WARN "DNS 서비스에서 불필요한 Zone Transfer가 허용될 수 있습니다."
} Else {
    OK "DNS 서비스에서 불필요한 Zone Transfer가 제한됩니다."
}

Get-Content -Path $result

Write-Host "`n"
