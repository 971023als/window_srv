# 결과 파일 정의
$TMP1 = "$(SCRIPTNAME).log"
Remove-Item -Path $TMP1 -ErrorAction Ignore
New-Item -Path $TMP1 -ItemType File

# 시작 정보 출력
@"
CODE [SRV-126] 자동 로그온 방지 설정 미흡

[양호]: 자동 로그온이 비활성화된 경우
[취약]: 자동 로그온이 활성화된 경우
"@ | Out-File -FilePath $TMP1

# 자동 로그온 설정 확인
$autoLogonKey = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$autoLogonStatus = Get-ItemProperty -Path $autoLogonKey -Name AutoAdminLogon

if ($autoLogonStatus.AutoAdminLogon -eq "1") {
    "WARN: 자동 로그온이 활성화되어 있습니다." | Out-File -FilePath $TMP1 -Append
} else {
    "OK: 자동 로그온이 비활성화되어 있습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1
