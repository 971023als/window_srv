# 결과 파일 초기화
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Set-Content $TMP1

# 메시지 구분자 함수
Function BAR {
    "--------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

BAR

"CODE [SRV-010] SMTP 서비스의 메일 queue 처리 권한 설정 미흡" | Out-File -FilePath $TMP1 -Append

@"
[양호]: SMTP 서비스의 메일 queue 처리 권한을 업무 관리자에게만 부여되도록 설정한 경우
[취약]: SMTP 서비스의 메일 queue 처리 권한이 업무와 무관한 일반 사용자에게도 부여되도록 설정된 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# 메일 queue 처리 권한 설정 조정
$MailQueueAdmins = @("AdminAccount1", "AdminAccount2") # 업무 관리자 계정으로 대체해야 함

# 업무 관리자에게 메일 queue 처리 권한 부여 (가상의 cmdlet 예시)
foreach ($admin in $MailQueueAdmins) {
    # 실제 환경에 맞는 cmdlet 또는 관리 도구를 사용하여 권한 부여
    "메일 queue 처리 권한이 [$admin]에게 부여되었습니다. (실제 적용 필요)" | Out-File -FilePath $TMP1 -Append
}

# 일반 사용자의 메일 queue 처리 권한 제거 (가상의 cmdlet 예시)
$GeneralUsers = @("UserAccount1", "UserAccount2") # 일반 사용자 계정으로 대체해야 함
foreach ($user in $GeneralUsers) {
    # 실제 환경에 맞는 cmdlet 또는 관리 도구를 사용하여 권한 제거
    "[$user]의 메일 queue 처리 권한이 제거되었습니다. (실제 적용 필요)" | Out-File -FilePath $TMP1 -Append
}

BAR

# 결과 출력
Get-Content $TMP1 | Write-Output
