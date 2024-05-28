# 변수 설정
$LogFilePathSMTP = "$($MyInvocation.MyCommand.Name)_SMTP.json"
$SMTPServiceName = "SMTPSVC"

# SMTP 서비스 상태 확인 및 expn/vrfy 명령어 제한 상태 검사
function Get-SMTPExpnVrfyStatus {
    $smtpService = Get-Service -Name $SMTPServiceName -ErrorAction SilentlyContinue
    if ($smtpService -and $smtpService.Status -eq 'Running') {
        @{
            Running = $true
            Message = "SMTP 서비스가 실행 중입니다."
            ExpnVrfyRestrictionStatus = Check-SMTPExpnVrfyRestriction
        }
    } else {
        @{
            Running = $false
            Message = "SMTP 서비스가 비활성화되어 있거나 실행 중이지 않습니다."
            ExpnVrfyRestrictionStatus = @{
                Checked = $false
                Message = "SMTP 서비스가 비활성화되어 확인할 수 없습니다."
            }
        }
    }
}

# SMTP expn/vrfy 명령어 사용 제한 검사 (실제 구현 필요)
function Check-SMTPExpnVrfyRestriction {
    # PowerShell 코드로 Exchange 관리 셸을 사용하여 설정을 확인해야 함
    # 아래는 예시 메시지
    @{
        Checked = $true
        Restricted = $false
        Message = "SMTP 설정을 확인할 수 없습니다. Exchange 관리 셸에서 수동으로 확인하세요."
    }
}

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-005"
    위험도 = "중간"
    진단항목 = "SMTP 서비스의 expn/vrfy 명령어 실행 제한 미비"
    현황 = (Get-SMTPExpnVrfyStatus)
    대응방안 = "expn 및 vrfy 명령어 사용을 제한"
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePathSMTP

# 결과 파일 출력
Get-Content $LogFilePathSMTP | Write-Output
