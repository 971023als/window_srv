$TMP1 = "$(SCRIPTNAME).log"
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-109] 시스템 주요 이벤트 로그 설정 미흡"

Add-Content -Path $TMP1 -Value "[양호]: 주요 이벤트 로그 설정이 적절하게 구성되어 있는 경우"
Add-Content -Path $TMP1 -Value "[취약]: 주요 이벤트 로그 설정이 적절하게 구성되어 있지 않은 경우"

BAR

# 이벤트 로그 설정 확인
$eventLogs = Get-WinEvent -ListLog * -ErrorAction SilentlyContinue | Where-Object { $_.RecordCount -gt 0 }

$expectedLogs = @(
    "Application",
    "Security",
    "System"
)

foreach ($log in $expectedLogs) {
    $currentLog = $eventLogs | Where-Object { $_.LogName -eq $log }
    if ($null -eq $currentLog) {
        Add-Content -Path $TMP1 -Value "WARN: $log 로그가 존재하지 않습니다."
    } else {
        # 여기에 추가적인 설정 검사 로직을 구현할 수 있습니다.
        # 예: 로그의 최대 크기, 오버라이트 정책 등
        Add-Content -Path $TMP1 -Value "OK: $log 로그의 기본 설정이 존재합니다."
    }
}

# 결과 파일 출력
Get-Content -Path $TMP1

Write-Host "`n"
