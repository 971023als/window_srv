# 변수 설정
$LogFilePathSMTP = "$($MyInvocation.MyCommand.Name)_SMTP.json"
$SMTPServiceName = "SMTPSVC"

# Windows에서 SMTP 서비스 실행 여부 확인
function Get-SMTPStatus {
    $smtpService = Get-Service -Name $SMTPServiceName -ErrorAction SilentlyContinue
    if ($smtpService -and $smtpService.Status -eq 'Running') {
        @{
            Running = $true
            Message = "SMTP 서비스가 실행 중입니다."
            DiagnosisResult = "취약"
        }
    } else {
        @{
            Running = $false
            Message = "SMTP 서비스가 비활성화되어 있거나 실행 중이지 않습니다."
            DiagnosisResult = "양호"
        }
    }
}

# SMTP 포트 25 상태 확인
function Check-SMTPPort {
    $smtpPort = Get-NetTCPConnection -LocalPort 25 -ErrorAction SilentlyContinue
    if ($smtpPort) {
        @{
            PortOpen = $true
            PortMessage = "SMTP 포트(25)가 열려 있습니다. 불필요한 서비스가 실행 중일 수 있습니다."
        }
    } else {
        @{
            PortOpen = $false
            PortMessage = "SMTP 포트(25)는 닫혀 있습니다."
        }
    }
}

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-004"
    위험도 = "중간"
    진단항목 = "불필요한 SMTP 서비스 실행"
    현황 = @{
        ServiceStatus = (Get-SMTPStatus)
        PortStatus = (Check-SMTPPort)
    }
    대응방안 = "필요하지 않은 경우 SMTP 서비스를 비활성화하고 포트를 닫음"
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePathSMTP

# 결과 파일 출력
Get-Content $LogFilePathSMTP | Write-Output
