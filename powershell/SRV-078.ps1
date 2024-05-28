# function.ps1 내용 포함 (적절한 경로 지정 필요)
. .\function.ps1

$TMP1 = "$(SCRIPTNAME).log"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-078] 불필요한 Guest 계정 활성화"

$result = "결과 파일 경로를 지정해야 함"
Add-Content -Path $result -Value "[양호]: 불필요한 Guest 계정이 비활성화 되어 있는 경우"
Add-Content -Path $result -Value "[취약]: 불필요한 Guest 계정이 활성화 되어 있는 경우"

BAR

# Guest 계정의 활성화 상태 확인
try {
    $guestAccount = Get-LocalUser -Name "Guest"
    if ($guestAccount.Enabled) {
        Add-Content -Path $TMP1 -Value "WARN: 불필요한 Guest 계정이 활성화 되어 있습니다."
    } else {
        Add-Content -Path $TMP1 -Value "OK: 불필요한 Guest 계정이 비활성화 되어 있습니다."
    }
} catch {
    Add-Content -Path $TMP1 -Value "OK: Guest 계정이 시스템에 존재하지 않습니다."
}

Get-Content -Path $result

Write-Host "`n"
