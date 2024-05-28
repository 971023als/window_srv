# 결과 파일 초기화
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Set-Content $TMP1

Function BAR {
    "--------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

BAR

"CODE [SRV-011] 시스템 관리자 계정의 FTP 사용 제한 미비" | Out-File -FilePath $TMP1 -Append

@"
[양호]: FTP 서비스에서 시스템 관리자 계정의 접근이 제한되는 경우
[취약]: FTP 서비스에서 시스템 관리자 계정의 접근이 제한되지 않는 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# FTP 사용자 제한 설정 변경 (IIS 기반)
try {
    $FTPUsersFile = "C:\Windows\System32\inetsrv\config\applicationHost.config" # 실제 경로

    # applicationHost.config 파일 백업
    $backupFile = "$FTPUsersFile.bak"
    Copy-Item $FTPUsersFile $backupFile -Force

    # 관리자 계정 접근 제한 설정 추가
    $newRule = '<add accessType="Deny" users="Administrator" permissions="Read, Write" />'
    $configPath = '/system.applicationHost/sites/site[@name="Default Web Site"]/ftpServer/security/authorization'
    Add-WebConfigurationProperty -Filter $configPath -Name "." -Value $newRule -PSPath "IIS:\"

    "FTP 서비스에서 관리자 계정의 접근이 성공적으로 제한되었습니다." | Out-File -FilePath $TMP1 -Append
} catch {
    "FTP 서비스 관리자 계정 접근 제한 설정 중 오류가 발생했습니다: $_" | Out-File -FilePath $TMP1 -Append
}

BAR

Get-Content $TMP1 | Write-Output
