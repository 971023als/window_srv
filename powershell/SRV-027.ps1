# 변수 설정
$LogFilePath = "$($MyInvocation.MyCommand.Name).json"
$FirewallRules = Get-NetFirewallRule -Enabled True -Direction Inbound | Where-Object { $_.Action -eq 'Block' }

# 방화벽 규칙에 따른 서비스 접근 IP 및 포트 제한 상태 확인
function Get-FirewallStatus {
    if ($FirewallRules.Count -gt 0) {
        $configuredRules = @()
        foreach ($rule in $FirewallRules) {
            $configuredRules += $rule.DisplayName
        }
        @{
            Configured = $true
            Message = "방화벽 규칙이 서비스 접근을 적절하게 제한하도록 설정되어 있습니다."
            ConfiguredRules = $configuredRules
            DiagnosisResult = "양호"
        }
    } else {
        @{
            Configured = $false
            Message = "서비스에 대한 IP 및 포트 접근 제한을 설정하는 방화벽 규칙이 없습니다."
            DiagnosisResult = "취약"
        }
    }
}

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-027"
    위험도 = "중간"
    진단항목 = "서비스 접근 IP 및 포트 제한"
    진단결과 = "(변수: 양호, 취약)"
    현황 = (Get-FirewallStatus)
    대응방안 = "서비스 접근에 대한 IP 및 포트 제한을 설정하십시오."
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePath

# 결과 파일 출력
Get-Content $LogFilePath | Write-Output
