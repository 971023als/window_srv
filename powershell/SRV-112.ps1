$TMP1 = "$(SCRIPTNAME).log"
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-112] Cron 서비스 로깅 미설정"

Add-Content -Path $TMP1 -Value "[양호]: Cron 서비스 로깅이 적절하게 설정되어 있는 경우"
Add-Content -Path $TMP1 -Value "[취약]: Cron 서비스 로깅이 적절하게 설정되어 있지 않은 경우"

BAR

# 작업 스케줄러 로그 존재 여부 확인
$eventLog = Get-WinEvent -LogName "Microsoft-Windows-TaskScheduler/Operational" -ErrorAction SilentlyContinue | Select-Object -First 1

if ($null -eq $eventLog) {
    Add-Content -Path $TMP1 -Value "WARN: 작업 스케줄러의 작업 실행 로그가 존재하지 않습니다."
} else {
    Add-Content -Path $TMP1 -Value "OK: 작업 스케줄러의 작업 실행 로그가 적절하게 기록되고 있습니다."
}

# 결과 파일 출력
Get-Content -Path $TMP1

Write-Host "`n"
