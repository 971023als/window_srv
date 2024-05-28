# Telnet 서비스 상태 확인
$telnetService = Get-Service -Name 'TlntSvr' -ErrorAction SilentlyContinue
if ($telnetService -ne $null -and $telnetService.Status -eq 'Running') {
    Write-Host "Telnet 서비스가 실행 중입니다. - 취약"
} else {
    Write-Host "Telnet 서비스가 비활성화되어 있습니다. - 양호"
}

# FTP 서비스 상태 확인 (Microsoft FTP Service 기준)
$ftpService = Get-Service -Name 'FTPSVC' -ErrorAction SilentlyContinue
if ($ftpService -ne $null -and $ftpService.Status -eq 'Running') {
    Write-Host "FTP 서비스가 실행 중입니다. - 취약"
} else {
    Write-Host "FTP 서비스가 비활성화되어 있습니다. - 양호"
}

# 추가적으로 실행중인 프로세스를 통해 FTP 서버 소프트웨어가 실행 중인지 확인할 수 있음
$runningFtpProcesses = Get-Process | Where-Object { $_.ProcessName -match 'ftp' }
if ($runningFtpProcesses) {
    Write-Host "FTP 관련 프로세스가 실행 중입니다. - 취약"
} else {
    Write-Host "FTP 관련 프로세스가 실행 중이지 않습니다. - 양호"
}
