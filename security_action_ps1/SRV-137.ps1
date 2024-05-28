# 로그 파일 경로 설정 및 초기화
$TMP1 = "$env:SCRIPTNAME.log"
"" | Out-File -FilePath $TMP1

# 로그 파일에 내용 추가
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-137] 네트워크 서비스의 접근 제한 설정 미흡" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"[양호]: 네트워크 서비스의 접근 제한이 적절히 설정된 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: 네트워크 서비스의 접근 제한이 설정되지 않은 경우" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append

# 필요한 경우, 방화벽 규칙 생성 또는 수정 로직 추가
# 예시: 특정 포트에 대한 인바운드 접근을 제한하는 규칙 생성
$portToRestrict = 1433 # SQL Server 기본 포트 예시
$ruleName = "RestrictSQLServerInbound"
$existingRule = Get-NetFirewallRule -Name $ruleName -ErrorAction SilentlyContinue
if (-not $existingRule) {
    New-NetFirewallRule -DisplayName $ruleName -Direction Inbound -LocalPort $portToRestrict -Protocol TCP -Action Block
    "새로운 방화벽 규칙이 생성되었습니다: $ruleName" | Out-File -FilePath $TMP1 -Append
} else {
    "방화벽 규칙이 이미 존재합니다: $ruleName" | Out-File -FilePath $TMP1 -Append
}

# Windows 방화벽 규칙 검사 및 결과 로깅
$firewallRules = Get-NetFirewallRule | Where-Object { $_.Enabled -eq $true -and $_.Action -eq 'Allow' }
if ($firewallRules.Count -gt 0) {
    $firewallRules | Format-Table Name, Action, Direction, Enabled -AutoSize | Out-File -FilePath $TMP1 -Append
    "추가적인 분석 및 판단 로직이 필요합니다. 결과는 $TMP1 파일을 참조하세요." | Out-File -FilePath $TMP1 -Append
} else {
    "적절한 네트워크 서비스 접근 제한 규칙이 설정되어 있지 않습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1 | Out-Host
