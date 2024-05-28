$TMP1 = "$(SCRIPTNAME).log"
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-094] crontab 참조파일 권한 설정 미흡"

Add-Content -Path $TMP1 -Value "[양호]: 로그 기록 정책이 정책에 따라 설정되어 수립되어 있는 경우"
Add-Content -Path $TMP1 -Value "[취약]: 로그 기록 정책이 정책에 따라 설정되어 수립되어 있지 않은 경우"

BAR

# 이벤트 로그 정책 설정을 확인하는 PowerShell 스크립트 예시입니다.
# Windows에서는 이벤트 로그와 관련된 정책을 Group Policy를 통해 관리합니다.
# 이 스크립트는 시스템에 구성된 이벤트 로그 크기와 보존 정책을 확인합니다.

# 이벤트 로그 종류를 배열로 정의합니다.
$logTypes = @("Application", "Security", "System")

foreach ($logType in $logTypes) {
    $log = Get-EventLog -LogName $logType -ErrorAction SilentlyContinue
    if ($null -ne $log) {
        $logPolicy = Get-WinEvent -LogName $logType -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($null -ne $logPolicy) {
            Add-Content -Path $TMP1 -Value "OK: $logType 로그가 존재하며, 정책이 설정되어 있습니다."
        } else {
            Add-Content -Path $TMP1 -Value "WARN: $logType 로그는 존재하지만, 정책이 설정되어 있지 않습니다."
        }
    } else {
        Add-Content -Path $TMP1 -Value "WARN: $logType 로그가 시스템에 존재하지 않습니다."
    }
}

Get-Content -Path $TMP1

Write-Host "`n"
