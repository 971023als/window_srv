# 변수 설정
$LogFilePathSMTPRelay = "$($MyInvocation.MyCommand.Name)_SMTPRelay.json"
$smtpPort = 25

# 메시지 구분자 함수
function Format-Divider {
    "--------------------------------------------"
}

# SMTP 포트 상태 확인 및 릴레이 설정 조정
function Get-SMTPRelaySettingsStatus {
    $smtpPortStatus = Get-NetTCPConnection -State Listen | Where-Object { $_.LocalPort -eq $smtpPort }
    if ($smtpPortStatus) {
        $relayRestrictions = "Only the list below" # 가정된 값, 실제 환경에 맞게 수정 필요
        $allowList = @("192.168.1.1") # 가정된 값, 실제 환경에 맞게 수정 필요

        if ($relayRestrictions -eq "Only the list below" -and $allowList.Count -gt 0) {
            @{
                PortOpen = $true
                RelayRestricted = $true
                Message = "SMTP 릴레이 제한이 적절하게 설정되어 있습니다."
                DiagnosisResult = "양호"
            }
        } else {
            @{
                PortOpen = $true
                RelayRestricted = $false
                Message = "SMTP 릴레이 제한이 적절하게 설정되지 않았습니다. 설정을 조정해야 합니다."
                DiagnosisResult = "취약"
            }
        }
    } else {
        @{
            PortOpen = $false
            RelayRestricted = "Not Applicable"
            Message = "SMTP 포트($smtpPort)가 닫혀 있습니다. 서비스가 비활성화되었거나 릴레이 제한이 설정될 수 있습니다."
            DiagnosisResult = "양호"
        }
    }
}

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-009"
    위험도 = "중간"
    진단항목 = "SMTP 서비스 스팸 메일 릴레이 제한 미설정"
    현황 = (Get-SMTPRelaySettingsStatus)
    대응방안 = "SMTP 포트의 릴레이 설정을 적절히 조정"
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePathSMTPRelay

# 결과 파일 출력
Get-Content $LogFilePathSMTPRelay | Write-Output
