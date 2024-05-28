# function.ps1 내용 포함
. .\function.ps1

$TMP1 = "$(SCRIPTNAME).log"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-064] 취약한 버전의 DNS 서비스 사용"

Add-Content -Path $TMP1 -Value "[양호]: DNS 서비스가 최신 버전으로 업데이트되어 있는 경우"
Add-Content -Path $TMP1 -Value "[취약]: DNS 서비스가 최신 버전으로 업데이트되어 있지 않은 경우"

BAR

# PowerShell을 사용하여 프로세스 확인
$ps_dns_count = (Get-Process -Name "named" -ErrorAction SilentlyContinue).Count
if ($ps_dns_count -gt 0) {
    try {
        # 예시: 버전 확인을 위한 PowerShell 명령어 (실제 환경에 맞게 조정)
        $bindVersion = (Get-Package -Name "bind*" -ErrorAction Stop).Version.ToString()
        if ($bindVersion -notmatch "9\.18\.[7-9]|9\.18\.1[0-6]") {
            Add-Content -Path $TMP1 -Value "WARN: BIND 버전이 최신 버전(9.18.7 이상)이 아닙니다."
        }
        else {
            Add-Content -Path $TMP1 -Value "※ U-33 결과 : 양호(Good)"
        }
    } catch {
        Add-Content -Path $TMP1 -Value "WARN: BIND 버전을 확인할 수 없습니다."
    }
}
else {
    Add-Content -Path $TMP1 -Value "OK: DNS 서비스가 실행되지 않고 있습니다."
}

Get-Content -Path $TMP1

Write-Host "`n"
