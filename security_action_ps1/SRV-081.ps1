# 로그 파일 초기화 및 기본 정보 기록
$SCRIPTNAME = $MyInvocation.MyCommand.Name
$TMP1 = "$(Get-Location)\${SCRIPTNAME}_log.txt"
Clear-Content -Path $TMP1

# 구분선 추가 함수
function BAR {
    Add-Content -Path $TMP1 -Value ("-" * 50)
}

BAR

$CODE = "[SRV-081] 일반 사용자의 프린터 드라이버 설치 제한 미비"

Add-Content -Path $TMP1 -Value "[양호]: 스케줄러 작업의 권한 설정이 적절히 이루어진 경우"
Add-Content -Path $TMP1 -Value "[취약]: 스케줄러 작업의 권한 설정이 적절히 이루어지지 않은 경우"

BAR

# 스케줄러 작업 조회 및 권한 검사
$scheduledTasks = Get-ScheduledTask | Where-Object {
    $_.Principal.UserId -notmatch '^(NT AUTHORITY\\SYSTEM|NT AUTHORITY\\LOCAL SERVICE|NT AUTHORITY\\NETWORK SERVICE)$'
}

if ($scheduledTasks) {
    foreach ($task in $scheduledTasks) {
        $taskName = $task.TaskName
        $userId = $task.Principal.UserId
        # 권한 수정을 위한 조치
        try {
            $newUserId = 'NT AUTHORITY\SYSTEM' # 또는 다른 적절한 시스템 계정
            Set-ScheduledTask -TaskName $taskName -User $newUserId
            Add-Content -Path $TMP1 -Value "FIXED: TaskName: $taskName, UserId: 변경됨($userId -> $newUserId)"
        } catch {
            Add-Content -Path $TMP1 -Value "ERROR: TaskName: $taskName, 권한 수정 실패"
        }
    }
} else {
    Add-Content -Path $TMP1 -Value "OK: 모든 스케줄러 작업이 적절한 권한으로 설정되어 있습니다."
}

BAR

# 로그 파일의 내용을 출력
Get-Content -Path $TMP1 | Out-Host

Write-Host "`n스크립트 완료."
