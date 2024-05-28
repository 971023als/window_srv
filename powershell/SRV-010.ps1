# 변수 설정
$LogFilePathSMTPQueue = "$($MyInvocation.MyCommand.Name)_SMTPQueue.json"

# 메일 큐 처리 권한 설정 점검
function Get-SMTPQueueSettingsStatus {
    # 이 부분은 실제 환경에 따라 구현 필요. 아래 코드는 예시입니다.
    # Exchange 관리 콘솔이나 PowerShell cmdlet을 사용하여 메일 큐 권한을 점검
    # 예시 코드
    $queuePermissions = "AdminsOnly" # 가정된 값, 실제 환경에 맞게 수정 필요
    if ($queuePermissions -eq "AdminsOnly") {
        @{
            QueuePermissionsCorrect = $true
            Message = "SMTP 서비스의 메일 queue 처리 권한을 업무 관리자에게만 부여되도록 설정한 경우"
            DiagnosisResult = "양호"
        }
    } else {
        @{
            QueuePermissionsCorrect = $false
            Message = "SMTP 서비스의 메일 queue 처리 권한이 업무와 무관한 일반 사용자에게도 부여되도록 설정된 경우"
            DiagnosisResult = "취약"
        }
    }
}

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-010"
    위험도 = "중간"
    진단항목 = "SMTP 서비스의 메일 queue 처리 권한 설정 미흡"
    현황 = (Get-SMTPQueueSettingsStatus)
    대응방안 = "SMTP 서비스의 메일 queue 처리 권한을 업무 관리자에게만 부여"
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePathSMTPQueue

# 결과 파일 출력
Get-Content $LogFilePathSMTPQueue | Write-Output
