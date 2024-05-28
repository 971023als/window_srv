# 결과 파일 경로 설정
$ScriptName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
$TMP1 = "$ScriptName.log"

# 로그 파일 초기화
"" | Set-Content -Path $TMP1

# 로그 파일에 헤더 정보 추가
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-152] 원격터미널 접속 가능한 사용자 그룹 제한 미비" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"[양호]: SSH 접속이 특정 그룹에게만 제한된 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: SSH 접속이 특정 그룹에게만 제한되지 않은 경우" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append

# OpenSSH 서비스 상태 확인
$sshService = Get-Service -Name sshd -ErrorAction SilentlyContinue
if ($null -ne $sshService) {
    "OK: SSH 서비스가 설치되어 있습니다." | Out-File -FilePath $TMP1 -Append
} else {
    "WARN: SSH 서비스가 설치되어 있지 않거나 비활성화되어 있습니다." | Out-File -FilePath $TMP1 -Append
}

# sshd_config 파일 확인
$configPath = "C:\ProgramData\ssh\sshd_config"
if (Test-Path -Path $configPath) {
    "sshd_config 파일이 존재합니다." | Out-File -FilePath $TMP1 -Append
    # 여기서 추가적인 확인 로직을 구현할 수 있음
} else {
    "WARN: sshd_config 파일이 존재하지 않습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1 | Write-Output

Write-Host "`nScript complete."
