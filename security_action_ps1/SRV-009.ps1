# 임시 로그 파일 생성
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Set-Content -Path $TMP1

# 메시지 구분자 함수
function BAR {
    "--------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

BAR
"CODE [SRV-009] SMTP 서비스 스팸 메일 릴레이 제한 미설정" | Out-File -FilePath $TMP1 -Append

@"
[양호]: SMTP 서비스를 사용하지 않거나 릴레이 제한이 설정되어 있는 경우
[취약]: SMTP 서비스를 사용하거나 릴레이 제한이 설정이 없는 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# SMTP 서비스의 릴레이 제한 설정 조정 (IIS SMTP 서버 예시)
try {
    Import-Module WebAdministration

    # 릴레이 설정을 확인하고 조정하는 코드
    $relayRestrictionList = @("127.0.0.1", "192.168.1.1") # 허용할 IP 주소 목록
    $smtpSite = "IIS:\SmtpSvc\1" # SMTP 사이트 경로, 실제 환경에서는 경로가 다를 수 있음

    # 현재 릴레이 제한 목록 설정
    Set-ItemProperty -Path $smtpSite -Name RelayIpList -Value $relayRestrictionList

    "SMTP 서비스에 대한 릴레이 제한이 적용되었습니다. 허용된 IP 목록: $($relayRestrictionList -join ', ')" | Out-File -FilePath $TMP1 -Append
} catch {
    "릴레이 제한 설정 중 오류가 발생했습니다: $_" | Out-File -FilePath $TMP1 -Append
}

BAR

# 결과 출력
Get-Content $TMP1 | Write-Output
