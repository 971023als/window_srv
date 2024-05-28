# 변수 설정
$LogFilePathSMTP = "$($MyInvocation.MyCommand.Name)_SMTP.json"
$SMTPServiceName = "SMTPSVC"

# SMTP 서비스의 로그 수준 설정 확인
function Get-SMTPLogLevelStatus {
    $smtpService = Get-Service -Name $SMTPServiceName -ErrorAction SilentlyContinue
    if ($smtpService -and $smtpService.Status -eq 'Running') {
        # SMTP 로그 수준 확인
        # 실제 로그 수준 확인 명령은 환경에 따라 조정 필요
        $logLevel = Get-TransportServer | Select-Object -ExpandProperty LogLevel
        
        @{
            Running = $true
            LogLevel = $logLevel
            Message = if ($logLevel -eq 'Medium' -or $logLevel -eq 'High') {
                            "SMTP 서비스의 로그 수준이 적절하게 설정됨."
                        } else {
                            "SMTP 서비스의 로그 수준이 낮게 설정됨 또는 설정이 확인되지 않음."
                        }
            DiagnosisResult = if ($logLevel -eq 'Medium' -or $logLevel -eq 'High') {
                            "양호"
                        } else {
                            "취약"
                        }
        }
    } else {
        @{
            Running = $false
            LogLevel = "Not Applicable"
            Message = "SMTP 서비스가 비활성화되어 있거나 실행 중이지 않습니다."
            DiagnosisResult = "양호"
        }
    }
}

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-006"
    위험도 = "중간"
    진단항목 = "SMTP 서비스 로그 수준 설정 미흡"
    현황 = (Get-SMTPLogLevelStatus)
    대응방안 = "SMTP 서비스의 로그 수준을 '중간' 또는 '높음'으로 설정"
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePathSMTP

# 결과 파일 출력
Get-Content $LogFilePathSMTP | Write-Output
