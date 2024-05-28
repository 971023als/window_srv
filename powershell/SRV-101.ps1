$TMP1 = "$(SCRIPTNAME).log"
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-101] 불필요한 예약된 작업 존재"

Add-Content -Path $TMP1 -Value "[양호]: 불필요한 cron 작업이 존재하지 않는 경우"
Add-Content -Path $TMP1 -Value "[취약]: 불필요한 cron 작업이 존재하는 경우"

BAR

# 예약된 작업 검사
$scheduledTasks = Get-ScheduledTask | Where-Object { $_.State -eq 'Ready' }

if ($scheduledTasks) {
    foreach ($task in $scheduledTasks) {
        # 여기서는 모든 예약된 작업을 나열합니다.
        # 특정 조건을 기반으로 불필요한 작업을 필터링하기 위한 로직을 추가할 수 있습니다.
        Add-Content -Path $TMP1 -Value "불필요한 예약된 작업이 존재할 수 있습니다: $($task.TaskName) (경로: $($task.TaskPath))"
    }
} else {
    Add-Content -Path $TMP1 -Value "불필요한 예약된 작업이 존재하지 않습니다."
}

Get-Content -Path $TMP1

Write-Host "`n"
