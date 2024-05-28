function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

$SCRIPTNAME = $MyInvocation.MyCommand.Name
$global:TMP1 = "$(Get-Location)\${SCRIPTNAME}_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[SRV-112] Cron 서비스 로깅 미설정"

Add-Content -Path $global:TMP1 -Value "[양호]: Cron 서비스 로깅이 적절하게 설정되어 있는 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: Cron 서비스 로깅이 적절하게 설정되어 있지 않은 경우"

BAR

# 작업 스케줄러 로그 존재 여부 및 활성화 상태 확인
$logName = "Microsoft-Windows-TaskScheduler/Operational"
$eventLogStatus = wevtutil get-log $logName

if ($eventLogStatus -match "enabled: false") {
    # 로그가 비활성화된 경우, 활성화
    wevtutil set-log $logName /enabled:true
    Add-Content -Path $global:TMP1 -Value "UPDATED: $logName 로그가 활성화되었습니다."
} elseif ($eventLogStatus -match "enabled: true") {
    Add-Content -Path $global:TMP1 -Value "OK: $logName 로그가 이미 활성화되어 있으며 적절하게 기록되고 있습니다."
} else {
    Add-Content -Path $global:TMP1 -Value "WARN: $logName 로그의 상태를 확인할 수 없습니다."
}

# 결과 파일 출력
Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n스크립트 완료."
