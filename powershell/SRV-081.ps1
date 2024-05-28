$TMP1 = "$(SCRIPTNAME).log"
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-081] 일반 사용자의 프린터 드라이버 설치 제한 미비"

Add-Content -Path $TMP1 -Value "[양호]: 스케줄러 작업의 권한 설정이 적절히 이루어진 경우"
Add-Content -Path $TMP1 -Value "[취약]: 스케줄러 작업의 권한 설정이 적절히 이루어지지 않은 경우"

BAR

# 스케줄러 작업 조회
$scheduledTasks = Get-ScheduledTask | Where-Object { $_.Principal.UserId -notlike "SYSTEM" -and $_.Principal.UserId -notlike "LOCAL SERVICE" -and $_.Principal.UserId -notlike "NETWORK SERVICE" }

if ($scheduledTasks) {
    foreach ($task in $scheduledTasks) {
        Add-Content -Path $TMP1 -Value "WARN: 사용자 권한으로 실행되는 스케줄러 작업이 있습니다: $($task.TaskName)"
    }
} else {
    Add-Content -Path $TMP1 -Value "OK: 모든 스케줄러 작업이 적절한 권한으로 설정되어 있습니다."
}

Get-Content -Path $TMP1

Write-Host "`n"
