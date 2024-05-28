# 결과 파일 정의 및 초기화
$ScriptName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
$TMP1 = "$ScriptName.log"
"" | Set-Content -Path $TMP1

# 로그 파일에 헤더 정보 추가
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-158] 불필요한 Telnet 서비스 실행" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append

# Telnet 서비스 상태 평가
"[양호]: Telnet 서비스가 비활성화되어 있는 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: Telnet 서비스가 활성화되어 있는 경우" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append

# Telnet 서비스 상태 확인
$telnetService = Get-Service -Name TlntSvr -ErrorAction SilentlyContinue
if ($null -ne $telnetService -and $telnetService.Status -eq 'Running') {
    "WARN: Telnet 서비스가 실행 중입니다." | Out-File -FilePath $TMP1 -Append
} else {
    "OK: Telnet 서비스가 비활성화되어 있습니다." | Out-File -FilePath $TMP1 -Append
}

# FTP 서비스 관련 파일 존재 여부 확인
# 여기에 적절한 경로와 파일 이름을 지정
$FTPConfigFile = "C:\path\to\ftp\config\file.txt"
if (Test-Path -Path $FTPConfigFile) {
    "INFO: FTP 설정 파일이 존재합니다: $FTPConfigFile" | Out-File -FilePath $TMP1 -Append
} else {
    "INFO: FTP 설정 파일이 존재하지 않습니다: $FTPConfigFile" | Out-File -FilePath $TMP1 -Append
}

# 결과 출력
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
Get-Content -Path $TMP1 | Write-Output

Write-Host "`nScript complete."
