# 로그 파일 경로 및 초기화
$TMP1 = "$env:SCRIPTNAME.log"
"" | Out-File -FilePath $TMP1

# 로그 파일에 내용 추가
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-133] Cron 서비스 사용 계정 제한 미비" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"[양호]: Cron 서비스 사용이 특정 계정으로 제한되어 있는 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: Cron 서비스 사용이 제한되지 않은 경우" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append

# 권장되는 실행 계정 목록 정의 (예시)
$recommendedAccounts = @("SYSTEM", "LOCAL SERVICE", "NETWORK SERVICE")

# 작업 스케줄러의 작업과 실행 계정 확인
$scheduledTasks = Get-ScheduledTask | Where-Object { $_.State -eq 'Ready' }
foreach ($task in $scheduledTasks) {
    $taskName = $task.TaskName
    $taskPath = $task.TaskPath
    $principal = $task.Principal.UserId
    if (-not $recommendedAccounts -contains $principal) {
        "$taskPath$taskName 실행 계정: $principal - 제한되지 않은 계정으로 실행되고 있습니다." | Out-File -FilePath $TMP1 -Append
    } else {
        "$taskPath$taskName 실행 계정: $principal" | Out-File -FilePath $TMP1 -Append
    }
}

# 결과 파일 출력
Get-Content -Path $TMP1 | Out-Host
