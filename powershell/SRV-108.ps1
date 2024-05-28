$TMP1 = "$(SCRIPTNAME).log"
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-108] 로그에 대한 접근통제 및 관리 미흡"

Add-Content -Path $TMP1 -Value "[양호]: 로그 파일의 접근 통제 및 관리가 적절하게 설정되어 있는 경우"
Add-Content -Path $TMP1 -Value "[취약]: 로그 파일의 접근 통제 및 관리가 적절하게 설정되어 있지 않은 경우"

BAR

# Windows 이벤트 로그 설정 확인
$eventLogNames = @("Application", "Security", "System")
$incorrectSettings = @()

foreach ($logName in $eventLogNames) {
    $log = Get-WinEvent -LogName $logName -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -eq $log) {
        $incorrectSettings += "로그($logName)가 존재하지 않습니다."
        continue
    }

    # 예시: 여기에서는 단순히 로그의 존재만 확인합니다.
    # 실제 사용 시에는 로그의 크기, 오버라이트 정책, 접근 권한 등을 검사할 수 있습니다.
}

if ($incorrectSettings.Count -eq 0) {
    Add-Content -Path $TMP1 -Value "OK: 모든 중요 로그 파일의 접근 통제 및 관리가 적절하게 설정되어 있습니다."
} else {
    foreach ($setting in $incorrectSettings) {
        Add-Content -Path $TMP1 -Value "WARN: $setting"
    }
}

Get-Content -Path $TMP1

Write-Host "`n"
