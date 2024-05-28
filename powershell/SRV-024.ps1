# 변수 설정
$LogFilePath = "$($MyInvocation.MyCommand.Name).json"
$TelnetServiceName = "TlntSvr"

# Telnet 서비스 상태 확인
function Get-TelnetStatus {
    $service = Get-Service -Name $TelnetServiceName -ErrorAction SilentlyContinue
    if ($service -eq $null -or $service.Status -ne 'Running') {
        @{
            Running = $false
            Message = "Telnet 서비스가 비활성화되어 있습니다."
            DiagnosisResult = "양호"
        }
    } else {
        $securityStatus = Check-TelnetSecurity
        @{
            Running = $true
            Message = "Telnet 서비스가 활성화되어 있습니다."
            SecurityStatus = $securityStatus
            DiagnosisResult = if ($securityStatus.Secure) { "양호" } else { "취약" }
        }
    }
}

# Telnet 보안 인증 방식 확인
function Check-TelnetSecurity {
    # 가정된 보안 설정 확인 결과 (실제 환경에서는 해당 설정을 직접 확인하는 명령어로 대체)
    $TelnetSecurity = '가정된 보안 설정 확인 결과'
    if ($TelnetSecurity -eq '보안 인증 방식 사용') {
        @{
            Secure = $true
            Message = "보안 인증 방식을 사용하고 있습니다."
        }
    } else {
        @{
            Secure = $false
            Message = "보안 인증 방식을 사용하지 않고 있습니다."
        }
    }
}

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-024"
    위험도 = "중간"
    진단항목 = "Telnet 서비스 보안 인증 방식 사용 여부"
    진단결과 = "(변수: 양호, 취약)"
    현황 = (Get-TelnetStatus)
    대응방안 = "Telnet 서비스를 비활성화하거나 보안 인증 방식을 사용해야 합니다."
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePath

# 결과 파일 출력
Get-Content $LogFilePath | Write-Output
