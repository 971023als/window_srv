$TMP1 = "$(SCRIPTNAME).log"
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-116] “보안 감사를 수행할 수 없는 경우, 즉시 시스템 종료” 기능 설정 미흡"

Add-Content -Path $TMP1 -Value "[양호]: 보안 감사 실패 시 시스템이 즉시 종료되도록 설정된 경우"
Add-Content -Path $TMP1 -Value "[취약]: 보안 감사 실패 시 시스템이 즉시 종료되지 않도록 설정된 경우"

BAR

# 보안 감사 정책 설정 확인
try {
    $auditPolicy = Get-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Lsa" -Name "CrashOnAuditFail"
    if ($auditPolicy.CrashOnAuditFail -eq 2) {
        Add-Content -Path $TMP1 -Value "OK: 보안 감사 실패 시 시스템이 즉시 종료되도록 설정됨"
    } else {
        Add-Content -Path $TMP1 -Value "WARN: 보안 감사 실패 시 시스템이 즉시 종료되지 않도록 설정됨"
    }
} catch {
    Add-Content -Path $TMP1 -Value "WARN: 보안 감사 정책 설정을 검사하는데 실패함"
}

# 결과 파일 출력
Get-Content -Path $TMP1

Write-Host "`n"
