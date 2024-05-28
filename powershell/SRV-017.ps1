# 임시 로그 파일 생성
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

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

# SMTP 포트 상태 확인
$smtpPorts = 25
$netStat = Get-NetTCPConnection -State Listen | Where-Object { $_.LocalPort -eq $smtpPorts }
if ($netStat) {
    "SMTP 포트($smtpPorts)가 열려 있습니다. 릴레이 제한 설정을 확인하세요." | Out-File -FilePath $TMP1 -Append
} else {
    "SMTP 포트($smtpPorts)가 닫혀 있습니다. 서비스가 비활성화되었거나 릴레이 제한이 설정될 수 있습니다." | Out-File -FilePath $TMP1 -Append
}

# Windows 환경에서는 SMTP 릴레이 설정을 IIS를 통해 관리합니다.
# IIS SMTP 설정 점검 (예시)
# 이 부분은 환경에 따라 달라질 수 있으므로, 실제 구현시 IIS 관리 도구나 PowerShell cmdlet을 참조하세요.

BAR
Get-Content $TMP1
Write-Host `n
