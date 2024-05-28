# 변수 설정
$LogFilePathSMTPVersion = "$($MyInvocation.MyCommand.Name)_SMTPVersion.json"

# SMTP 서비스 버전 확인
function Get-SMTPServiceVersionStatus {
    $ExchangeVersion = Get-ExchangeServer | Select-Object -ExpandProperty AdminDisplayVersion
    if ($ExchangeVersion -ne $null) {
        # 안전한 버전 정보 설정 (실제 환경에 맞게 수정 필요)
        $SafeVersion = 'Version 15.1 (Build 1713.5)' # 예시 버전
        @{
            Installed = $true
            CurrentVersion = $ExchangeVersion
            Message = if ($ExchangeVersion -ge $SafeVersion) {
                            "Exchange 서버 버전이 안전합니다. 현재 버전: $ExchangeVersion"
                        } else {
                            "Exchange 서버 버전이 취약할 수 있습니다. 현재 버전: $ExchangeVersion"
                        }
            DiagnosisResult = if ($ExchangeVersion -ge $SafeVersion) {
                            "양호"
                        } else {
                            "취약"
                        }
        }
    } else {
        @{
            Installed = $false
            CurrentVersion = "Not Applicable"
            Message = "Exchange 서버가 설치되어 있지 않습니다."
            DiagnosisResult = "N/A"
        }
    }
}

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-007"
    위험도 = "중간"
    진단항목 = "취약한 버전의 SMTP 서비스 사용"
    현황 = (Get-SMTPServiceVersionStatus)
    대응방안 = "SMTP 서비스를 최신 버전으로 업데이트"
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePathSMTPVersion

# 결과 파일 출력
Get-Content $LogFilePathSMTPVersion | Write-Output
