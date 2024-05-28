# 임시 로그 파일 생성
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

# 메시지 구분자 함수
function BAR {
    "------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

BAR
"CODE [SRV-037] 취약한 FTP 서비스 실행" | Out-File -FilePath $TMP1 -Append

@"
[양호]: FTP 서비스가 비활성화 되어 있는 경우
[취약]: FTP 서비스가 활성화 되어 있는 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# FTP 서비스 상태 확인
$service = Get-Service -Name 'FTPSvc' -ErrorAction SilentlyContinue
if ($service -and $service.Status -eq 'Running') {
    "WARN: FTP 서비스가 활성화되어 있습니다." | Out-File -FilePath $TMP1 -Append
} else {
    "OK: FTP 서비스가 비활성화되어 있습니다." | Out-File -FilePath $TMP1 -Append
}

# 포트 21 상태 확인
$port21Listening = Test-NetConnection -ComputerName localhost -Port 21 -InformationLevel Quiet
if ($port21Listening) {
    "WARN: 시스템에서 포트 21이(가) 열려 있습니다. FTP 서비스가 활성화되어 있을 수 있습니다." | Out-File -FilePath $TMP1 -Append
} else {
    "OK: 시스템에서 포트 21이(가) 닫혀 있습니다. FTP 서비스가 비활성화되어 있습니다." | Out-File -FilePath $TMP1 -Append
}

BAR

# 결과 출력
Get-Content -Path $TMP1 | Write-Host
