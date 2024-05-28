function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

$SCRIPTNAME = $MyInvocation.MyCommand.Name
$global:TMP1 = "$(Get-Location)\${SCRIPTNAME}_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[SRV-118] 주기적인 보안패치 및 벤더 권고사항 미적용"

Add-Content -Path $global:TMP1 -Value "[양호]: 최신 보안패치 및 업데이트가 적용된 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: 최신 보안패치 및 업데이트가 적용되지 않은 경우"

BAR

# 시스템 업데이트 상태 확인 및 업데이트 수행
try {
    Import-Module PSWindowsUpdate
    $updateStatus = Get-WUList -MicrosoftUpdate -ErrorAction Stop
    if ($updateStatus.Count -eq 0) {
        Add-Content -Path $global:TMP1 -Value "OK: 모든 패키지가 최신 상태입니다."
    } else {
        Get-WUInstall -MicrosoftUpdate -AcceptAll -AutoReboot | Out-Null
        $installedUpdates = $updateStatus | Select-Object -ExpandProperty Title
        Add-Content -Path $global:TMP1 -Value "UPDATED: 다음 패키지가 업데이트되었습니다: $($installedUpdates -join ', ')"
    }
} catch {
    Add-Content -Path $global:TMP1 -Value "ERROR: 업데이트 상태 확인 또는 업데이트 수행 중 오류가 발생했습니다. PSWindowsUpdate 모듈이 설치되어 있는지 확인하고, 권한이 충분한지 검토하세요."
}

# 결과 파일 출력
Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n스크립트 실행 완료."
