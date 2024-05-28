function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

$SCRIPTNAME = $MyInvocation.MyCommand.Name
$global:TMP1 = "$(Get-Location)\${SCRIPTNAME}_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[SRV-101] 불필요한 예약된 작업 존재"

Add-Content -Path $global:TMP1 -Value "[양호]: 불필요한 cron 작업이 존재하지 않는 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: 불필요한 cron 작업이 존재하는 경우"

BAR

# 예약된 작업 검사 및 삭제
$scheduledTasks = Get-ScheduledTask | Where-Object { $_.State -eq 'Ready' }

$unnecessaryTaskCriteria = "TaskNameToBeDeleted" # 예시: 삭제할 작업 이름 기준
$deletedTasks = @()

foreach ($task in $scheduledTasks) {
    # 불필요한 작업 식별 로직 (여기서는 작업 이름을 기준으로 함)
    if ($task.TaskName -like "*$unnecessaryTaskCriteria*") {
        # 작업 삭제
        Unregister-ScheduledTask -TaskName $task.TaskName -Confirm:$false
        $deletedTasks += $task.TaskName
    }
}

if ($deletedTasks.Count -gt 0) {
    foreach ($deletedTask in $deletedTasks) {
        Add-Content -Path $global:TMP1 -Value "DELETED: 불필요한 예약된 작업이 삭제되었습니다: $deletedTask"
    }
} else {
    Add-Content -Path $global:TMP1 -Value "불필요한 예약된 작업이 존재하지 않거나, 이미 삭제되었습니다."
}

Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n스크립트 완료."
