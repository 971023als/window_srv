# 로그 파일 설정
$TMP1 = "$PSScriptRoot\{0}.log" -f $MyInvocation.MyCommand.Name
# 로그 파일 초기화
"" | Set-Content $TMP1

# 로그 파일에 정보 추가
@"
------------------------------------------------
CODE [SRV-004] 불필요한 SMTP 서비스 실행
------------------------------------------------
[양호]: SMTP 서비스가 비활성화되어 있거나 필요한 경우에만 실행되는 경우
[취약]: SMTP 서비스가 필요하지 않음에도 실행되고 있는 경우
------------------------------------------------
"@ | Out-File -FilePath $TMP1 -Append

# Windows에서 SMTP 서비스 실행 여부 확인 및 비활성화
$smtpService = Get-Service -Name 'SMTPSVC' -ErrorAction SilentlyContinue
if ($smtpService -and $smtpService.Status -eq 'Running') {
    "SMTP 서비스가 실행 중입니다. 서비스를 비활성화합니다." | Out-File -FilePath $TMP1 -Append
    # SMTP 서비스 비활성화
    Stop-Service -Name 'SMTPSVC' -Force
    Set-Service -Name 'SMTPSVC' -StartupType Disabled
} else {
    "SMTP 서비스가 이미 비활성화되어 있거나 실행 중이지 않습니다." | Out-File -FilePath $TMP1 -Append
}

# SMTP 포트 25를 사용하는 규칙 찾기 및 비활성화
$smtpPortRule = Get-NetFirewallRule -DisplayName '*SMTP*' -ErrorAction SilentlyContinue
if ($smtpPortRule) {
    "SMTP 포트(25) 관련 방화벽 규칙이 발견되었습니다. 규칙을 비활성화합니다." | Out-File -FilePath $TMP1 -Append
    # SMTP 관련 방화벽 규칙 비활성화
    foreach ($rule in $smtpPortRule) {
        Disable-NetFirewallRule -DisplayName $rule.DisplayName
    }
} else {
    "SMTP 포트(25) 관련 방화벽 규칙이 발견되지 않았습니다." | Out-File -FilePath $TMP1 -Append
}

"------------------------------------------------" | Out-File -FilePath $TMP1 -Append

# 결과 파일 출력
Get-Content $TMP1 | Write-Output
