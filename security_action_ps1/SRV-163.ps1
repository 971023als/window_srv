# 결과 파일 정의 및 초기화
$TMP1 = "$env:SCRIPTNAME.log"
"" | Set-Content -Path $TMP1

# 헤더 정보 출력
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-163] 시스템 사용 주의사항 미출력" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append

# 상태 메시지 출력
@"
[양호]: 시스템 로그온 시 사용 주의사항이 출력되는 경우
[취약]: 시스템 로그온 시 사용 주의사항이 출력되지 않는 경우
"@
"----------------------------------------" | Out-File -FilePath $TMP1 -Append

# Windows 설정 확인
$Caption = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name LegalNoticeCaption).LegalNoticeCaption
$Text = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name LegalNoticeText).LegalNoticeText

if ($Caption -and $Text) {
    "/etc/motd 파일에 해당: LegalNoticeCaption 및 LegalNoticeText가 설정되어 있습니다." | Out-File -FilePath $TMP1 -Append
    $Caption | Out-File -FilePath $TMP1 -Append
    $Text | Out-File -FilePath $TMP1 -Append
    "OK: 시스템 로그온 시 사용 주의사항이 출력됩니다." | Out-File -FilePath $TMP1 -Append
} else {
    "WARN: 시스템 로그온 시 사용 주의사항이 출력되지 않습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1 | Write-Output

Write-Host "`nScript complete."
