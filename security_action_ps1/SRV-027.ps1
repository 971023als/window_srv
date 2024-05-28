# 임시 로그 파일 생성
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Set-Content -FilePath $TMP1

# 메시지 구분자
function BAR {
    "------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

BAR
"CODE [SRV-027] 서비스 접근 IP 및 포트 제한 미비" | Out-File -FilePath $TMP1 -Append
@"
[양호]: 서비스에 대한 IP 및 포트 접근 제한이 적절하게 설정된 경우
[취약]: 서비스에 대한 IP 및 포트 접근 제한이 설정되지 않은 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# 방화벽 규칙 확인
$FirewallRules = Get-NetFirewallRule -Enabled True -Direction Inbound | Where-Object { $_.Action -eq 'Block' }
if ($FirewallRules.Count -gt 0) {
    foreach ($rule in $FirewallRules) {
        $ruleName = $rule.DisplayName
        "OK: 방화벽 규칙 '$ruleName'가 접근을 차단하도록 설정되어 있습니다." | Out-File -FilePath $TMP1 -Append
    }
} else {
    "WARN: 서비스에 대한 IP 및 포트 접근 제한을 설정하는 방화벽 규칙이 없습니다." | Out-File -FilePath $TMP1 -Append
}

BAR

# 결과 출력
Get-Content $TMP1 | Write-Host
