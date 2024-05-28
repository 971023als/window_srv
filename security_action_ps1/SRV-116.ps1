function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

$SCRIPTNAME = $MyInvocation.MyCommand.Name
$global:TMP1 = "$(Get-Location)\${SCRIPTNAME}_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[SRV-116] “보안 감사를 수행할 수 없는 경우, 즉시 시스템 종료” 기능 설정 미흡"

Add-Content -Path $global:TMP1 -Value "[양호]: 보안 감사 실패 시 시스템이 즉시 종료되도록 설정된 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: 보안 감사 실패 시 시스템이 즉시 종료되지 않도록 설정된 경우"

BAR

# 보안 감사 정책 설정 확인 및 조정
$path = "HKLM:\System\CurrentControlSet\Control\Lsa"
$name = "CrashOnAuditFail"
$desiredState = 2 # 보안 감사 실패 시 시스템을 즉시 종료하도록 설정

try {
    $auditPolicy = Get-ItemProperty -Path $path -Name $name
    if ($auditPolicy.CrashOnAuditFail -ne $desiredState) {
        Set-ItemProperty -Path $path -Name $name -Value $desiredState
        Add-Content -Path $global:TMP1 -Value "UPDATED: 보안 감사 실패 시 시스템이 즉시 종료되도록 설정됨"
    } else {
        Add-Content -Path $global:TMP1 -Value "OK: 보안 감사 실패 시 시스템이 이미 즉시 종료되도록 설정됨"
    }
} catch {
    Add-Content -Path $global:TMP1 -Value "ERROR: 보안 감사 정책 설정을 조정하는데 실패함"
}

# 결과 파일 출력
Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n스크립트 실행 완료."
