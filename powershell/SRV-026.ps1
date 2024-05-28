# 변수 설정
$LogFilePath = "$($MyInvocation.MyCommand.Name).json"
$SshdConfigPath = 'C:\ProgramData\ssh\sshd_config'

# SSH 서비스의 root 계정 원격 접속 제한 검사
function Get-SSHRootLoginStatus {
    if (Test-Path $SshdConfigPath) {
        $ConfigContent = Get-Content $SshdConfigPath
        $PermitRootLogin = $ConfigContent | Where-Object { $_ -match 'PermitRootLogin' }
        if ($PermitRootLogin -match 'no') {
            @{
                PermitRootLoginRestricted = $true
                Message = "SSH를 통한 Administrator 계정의 원격 접속이 제한되어 있습니다."
                DiagnosisResult = "양호"
            }
        } else {
            @{
                PermitRootLoginRestricted = $false
                Message = "SSH를 통한 Administrator 계정의 원격 접속 제한 설정이 미흡합니다."
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
    코드 = "SRV-026"
    위험도 = "중간"
    진단항목 = "SSH 서비스의 root 계정 원격 접속 제한"
    진단결과 = "(변수: 양호, 취약)"
    현황 = (Get-SSHRootLoginStatus)
    대응방안 = "SSH를 통한 Administrator 계정의 원격 접속을 'no'로 제한하십시오."
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePath

# 결과 파일 출력
Get-Content $LogFilePath | Write-Output
