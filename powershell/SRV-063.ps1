# PowerShell 함수 파일 포함 (예: function.ps1)
. .\function.ps1

$TMP1 = "$(SCRIPTNAME).log"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-063] DNS Recursive Query 설정 미흡"

$result = "결과 파일 경로를 지정해야 함"
# 결과 파일에 내용 추가
Add-Content -Path $result -Value "[양호]: DNS 서버에서 재귀적 쿼리가 제한적으로 설정된 경우"
Add-Content -Path $result -Value "[취약]: DNS 서버에서 재귀적 쿼리가 적절하게 제한되지 않은 경우"

BAR

# DNS 설정 파일 경로
$DNS_CONFIG_FILE = "/etc/bind/named.conf.options" # BIND 예시, 실제 파일 경로는 다를 수 있음

# 재귀 쿼리 설정 확인
$recursion_setting = Select-String -Path $DNS_CONFIG_FILE -Pattern "allow-recursion" -AllMatches
if ($recursion_setting.Matches.Count -gt 0) {
    $isLimited = $false
    foreach ($match in $recursion_setting.Matches) {
        if ($match.Value -match "\{ localhost; \};" -or $match.Value -match "\{ localnets; \};") {
            $isLimited = $true
            break
        }
    }
    if ($isLimited) {
        OK "DNS 서버에서 재귀적 쿼리가 안전하게 제한됨: $($recursion_setting.Matches.Value)"
    } else {
        WARN "DNS 서버에서 재귀적 쿼리 제한이 미흡함: $($recursion_setting.Matches.Value)"
    }
} else {
    OK "DNS 서버에서 재귀적 쿼리가 기본적으로 제한됨"
}

Get-Content -Path $result

Write-Host "`n"
