# 변수 설정
$LogFilePath = "$($MyInvocation.MyCommand.Name).json"
$SshdConfigPath = 'C:\ProgramData\ssh\sshd_config'
$HostsEquivPath = '/etc/hosts.equiv'
$RhostsPath = '~/.rhosts'
$SecureSettings = @('PermitEmptyPasswords no', 'PasswordAuthentication yes')

# SSH 및 .rhosts, hosts.equiv 파일 검사
function Get-SSHAndHostsStatus {
    $sshConfigExists = Test-Path $SshdConfigPath
    $hostsEquivExists = Test-Path $HostsEquivPath
    $rhostsExists = Test-Path $RhostsPath

    $sshStatus = if ($sshConfigExists) { Check-SSHConfig } else { "SSH 구성 파일이 존재하지 않습니다." }
    $hostsStatus = Check-HostsFiles $hostsEquivExists $HostsEquivPath
    $rhostsStatus = Check-HostsFiles $rhostsExists $RhostsPath

    @{
        SSHStatus = $sshStatus
        HostsEquivStatus = $hostsStatus
        RhostsStatus = $rhostsStatus
    }
}

# SSH 보안 설정 검사
function Check-SSHConfig {
    $ConfigContent = Get-Content $SshdConfigPath
    $insecureSettingsFound = $SecureSettings | Where-Object { -not $ConfigContent -contains $_ }

    if ($insecureSettingsFound) {
        @{
            Secure = $false
            InsecureSettings = $insecureSettingsFound
        }
    } else {
        @{
            Secure = $true
            Message = "SSH 서비스의 보안 설정이 적절하게 구성되어 있습니다."
        }
    }
}

# Hosts 파일 안전성 검사
function Check-HostsFiles($exists, $path) {
    if (-not $exists) {
        @{
            Exists = $false
            Message = "$path 파일이 존재하지 않습니다."
        }
    } else {
        # 파일 존재 시 보안 검사 로직 추가 가능
        @{
            Exists = $true
            Message = "$path 파일이 존재하며, 추가 검사가 필요할 수 있습니다."
        }
    }
}

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-025"
    위험도 = "중간"
    진단항목 = "SSH 서비스 및 hosts 파일 설정"
    진단결과 = "(변수: 양호, 취약)"
    현황 = (Get-SSHAndHostsStatus)
    대응방안 = "SSH 설정을 강화하고, 불필요한 hosts 파일은 삭제하거나 보안을 강화하십시오."
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePath

# 결과 파일 출력
Get-Content $LogFilePath | Write-Output
