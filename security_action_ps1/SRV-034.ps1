# 임시 로그 파일 생성
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

# 메시지 구분자 함수
function BAR {
    "------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

BAR
"CODE [SRV-034] 불필요한 서비스 활성화" | Out-File -FilePath $TMP1 -Append

@"
[양호]: 불필요한 서비스가 비활성화된 경우
[취약]: 불필요한 서비스가 활성화된 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# 불필요한 서비스 목록
$services = @('Telnet', 'RemoteRegistry')

# 서비스 상태 확인 및 비활성화
foreach ($service in $services) {
    $serviceStatus = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($serviceStatus -and $serviceStatus.Status -eq 'Running') {
        Stop-Service -Name $service -Force
        Set-Service -Name $service -StartupType Disabled
        "CHANGE: 불필요한 서비스 '$service'가 비활성화되었습니다." | Out-File -FilePath $TMP1 -Append
    } else {
        "OK: 서비스 '$service'가 비활성화되어 있거나, 시스템에 설치되지 않았습니다." | Out-File -FilePath $TMP1 -Append
    }
}

BAR

# 결과 출력 및 로그 파일 삭제
Get-Content -Path $TMP1 | Write-Host
Remove-Item $TMP1 -Force
