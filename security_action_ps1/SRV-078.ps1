# function.ps1 내용 포함 (적절한 경로 지정 필요)
. .\function.ps1

$TMP1 = "$(Get-Location)\$(SCRIPTNAME)_log.txt"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-078] 불필요한 Guest 계정 활성화 조치"
Add-Content -Path $TMP1 -Value $CODE

BAR

# Guest 계정 비활성화
try {
    $guestAccount = Get-LocalUser -Name "Guest"
    if ($guestAccount.Enabled) {
        Disable-LocalUser -Name "Guest"
        if (!(Get-LocalUser -Name "Guest").Enabled) {
            OK "불필요한 Guest 계정이 비활성화 되었습니다."
        } else {
            WARN "불필요한 Guest 계정을 비활성화하는 데 실패했습니다."
        }
    } else {
        OK "불필요한 Guest 계정이 이미 비활성화 되어 있습니다."
    }
} catch {
    WARN "Guest 계정이 시스템에 존재하지 않거나, 다른 문제가 발생했습니다."
}

Get-Content -Path $TMP1 | Out-Host

Write-Host "`n스크립트 완료. Guest 계정의 상태가 확인 및 조정되었습니다."
