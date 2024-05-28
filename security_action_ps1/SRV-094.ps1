function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

$SCRIPTNAME = $MyInvocation.MyCommand.Name
$global:TMP1 = "$(Get-Location)\${SCRIPTNAME}_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[SRV-094] 이벤트 로그 설정 검토 및 조정"

Add-Content -Path $global:TMP1 -Value "[양호]: 모든 이벤트 로그의 설정이 정책에 따라 적절하게 수립되어 있는 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: 하나 이상의 이벤트 로그 설정이 정책에 따라 적절하게 수립되어 있지 않은 경우"

BAR

# 이벤트 로그 종류를 배열로 정의합니다.
$logTypes = @("Application", "Security", "System")

foreach ($logType in $logTypes) {
    # 각 로그 종류의 설정을 확인 및 조정합니다.
    $logConfig = Get-EventLog -LogName $logType -ErrorAction SilentlyContinue
    if ($null -ne $logConfig) {
        # 정책에 따른 설정 조정 예시
        # 예를 들어, 로그의 최대 크기를 20MB로 설정하고자 하는 경우
        $desiredMaxSizeKB = 20 * 1024 # 20MB를 KB로 변환
        if ($logConfig.MaximumKilobytes -lt $desiredMaxSizeKB) {
            $logConfig.MaximumKilobytes = $desiredMaxSizeKB
            $logConfig.SaveChanges()
            Add-Content -Path $global:TMP1 -Value "UPDATED: $logType 로그의 최대 크기를 $($desiredMaxSizeKB)KB로 조정하였습니다."
        } else {
            Add-Content -Path $global:TMP1 -Value "OK: $logType 로그의 최대 크기가 적절합니다. 현재 크기: $($logConfig.MaximumKilobytes)KB"
        }
    } else {
        Add-Content -Path $global:TMP1 -Value "WARN: $logType 로그는 시스템에 존재하지 않거나, 접근할 수 없습니다."
    }
}

Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n스크립트 완료."
