function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

$SCRIPTNAME = $MyInvocation.MyCommand.Name
$global:TMP1 = "$(Get-Location)\${SCRIPTNAME}_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[SRV-109] 시스템 주요 이벤트 로그 설정 미흡"

Add-Content -Path $global:TMP1 -Value "[양호]: 주요 이벤트 로그 설정이 적절하게 구성되어 있는 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: 주요 이벤트 로그 설정이 적절하게 구성되어 있지 않은 경우"

BAR

# 이벤트 로그 설정 확인 및 조정
$expectedLogs = @(
    "Application",
    "Security",
    "System"
)

foreach ($logName in $expectedLogs) {
    $log = Get-WinEvent -ListLog $logName -ErrorAction SilentlyContinue
    if ($null -eq $log) {
        Add-Content -Path $global:TMP1 -Value "WARN: $logName 로그가 존재하지 않습니다."
    } else {
        # 로그 설정 조정 예시: 최대 크기를 20MB로 설정
        $desiredMaxSizeBytes = 20MB
        if ($log.MaximumSizeInBytes -lt $desiredMaxSizeBytes) {
            $log.MaximumSizeInBytes = $desiredMaxSizeBytes
            $log.SaveChanges()
            Add-Content -Path $global:TMP1 -Value "UPDATED: $logName 로그의 최대 크기가 적절하게 조정되었습니다. (20MB)"
        } else {
            Add-Content -Path $global:TMP1 -Value "OK: $logName 로그의 최대 크기가 이미 적절합니다."
        }
    }
}

# 결과 파일 출력
Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n스크립트 완료."
