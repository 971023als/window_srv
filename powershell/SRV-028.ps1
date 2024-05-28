# 변수 설정
$LogFilePath = "$($MyInvocation.MyCommand.Name).json"
$SshdConfigPath = 'C:\ProgramData\ssh\sshd_config'

# SSH 원격 터미널 접속 타임아웃 설정 검사
function Get-SSHTimeoutStatus {
    if (Test-Path $SshdConfigPath) {
        $ConfigContent = Get-Content $SshdConfigPath
        $ClientAliveInterval = $ConfigContent | Where-Object { $_ -match '^ClientAliveInterval' }
        $ClientAliveCountMax = $ConfigContent | Where-Object { $_ -match '^ClientAliveCountMax' }
        if ($ClientAliveInterval -and $ClientAliveCountMax) {
            @{
                TimeoutConfigured = $true
                Message = "SSH 원격 터미널 타임아웃 설정이 적절하게 구성되어 있습니다."
                DiagnosisResult = "양호"
            }
        } else {
            @{
                TimeoutConfigured = $false
                Message = "SSH 원격 터미널 타임아웃 설정이 미비합니다."
                DiagnosisResult = "취약"
            }
        }
    } else {
        @{
            ConfigFileExists = $false
            Message = "OpenSSH 구성 파일(sshd_config)이 존재하지 않습니다."
            DiagnosisResult = "취약"
        }
    }
}

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-028"
    위험도 = "중간"
    진단항목 = "SSH 원격 터미널 접속 타임아웃 설정"
    진단결과 = "(변수: 양호, 취약)"
    현황 = (Get-SSHTimeoutStatus)
    대응방안 = "SSH 원격 터미널 접속 타임아웃을 적절하게 설정하십시오."
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePath

# 결과 파일 출력
Get-Content $LogFilePath | Write-Output
