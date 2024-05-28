# 로그온 시 사용 주의사항(법적 고지) 제목과 메시지를 확인
$legalNoticeCaption = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "legalnoticecaption"
$legalNoticeText = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "legalnoticetext"

# 제목 확인
if ($legalNoticeCaption.legalnoticecaption) {
    Write-Host "시스템 로그온 시 사용 주의사항 제목이 설정되어 있습니다: $($legalNoticeCaption.legalnoticecaption)"
} else {
    Write-Host "시스템 로그온 시 사용 주의사항 제목이 설정되어 있지 않습니다."
}

# 메시지 확인
if ($legalNoticeText.legalnoticetext) {
    Write-Host "시스템 로그온 시 사용 주의사항 메시지가 설정되어 있습니다: $($legalNoticeText.legalnoticetext)"
} else {
    Write-Host "시스템 로그온 시 사용 주의사항 메시지가 설정되어 있지 않습니다."
}
