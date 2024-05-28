# 변수 설정
$LogFilePath = "$($MyInvocation.MyCommand.Name).json"
$SshConfigFile = 'C:\ProgramData\ssh\sshd_config'
$EncryptionSettings = @('KexAlgorithms', 'Ciphers', 'MACs')

# SSH 암호화 설정 확인
function Get-SSHSecurityStatus {
    $ConfigExists = Test-Path $SshConfigFile
    if (-not $ConfigExists) {
        @{
            Exists = $false
            Message = "SSH 구성 파일이 존재하지 않습니다."
            DiagnosisResult = "취약"
        }
    } else {
        $securityStatus = Check-SSHEncryption
        @{
            Exists = $true
            Message = "SSH 구성 파일이 존재합니다."
            EncryptionStatus = $securityStatus
            DiagnosisResult = if ($securityStatus.Vulnerable) { "취약" } else { "양호" }
        }
    }
}

# SSH 암호화 설정 상세 검사
function Check-SSHEncryption {
    $ConfigContent = Get-Content $SshConfigFile
    $vulnerable = $false
    $notConfiguredSettings = @()

    foreach ($setting in $EncryptionSettings) {
        $SettingConfigured = $ConfigContent | Where-Object { $_ -match "^$setting" }
        if (-not $SettingConfigured) {
            $vulnerable = $true
            $notConfiguredSettings += $setting
        }
    }

    @{
        Configured = $notConfiguredSettings.Length -eq 0
        Vulnerable = $vulnerable
        NotConfiguredSettings = $notConfiguredSettings
    }
}

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-023"
    위험도 = "중간"
    진단항목 = "SSH 서비스 암호화 수준 설정"
    진단결과 = "(변수: 양호, 취약)"
    현황 = (Get-SSHSecurityStatus)
    대응방안 = "SSH 서비스의 암호화 수준을 강화하십시오."
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePath

# 결과 파일 출력
Get-Content $LogFilePath | Write-Output
