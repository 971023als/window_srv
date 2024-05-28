# 변수 설정
$LogFilePath = "$($MyInvocation.MyCommand.Name).json"
$SMBRegPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters'

# SMB 세션 중단 시간 설정 검사
function Get-SMBSessionTimeoutStatus {
    $deadtime = Get-ItemPropertyValue -Path $SMBRegPath -Name 'autodisconnect' -ErrorAction SilentlyContinue
    if ($null -ne $deadtime) {
        if ($deadtime -gt 0) {
            @{
                Configured = $true
                Message = "SMB 세션 중단 시간(autodisconnect)이 적절하게 설정되어 있습니다: $deadtime 분"
                DiagnosisResult = "양호"
            }
        } else {
            @{
                Configured = $false
                Message = "SMB 세션 중단 시간(autodisconnect) 설정이 미비합니다."
                DiagnosisResult = "취약"
            }
        }
    } else {
        @{
            Configured = $false
            Message = "SMB 세션 중단 시간(autodisconnect) 설정이 레지스트리에 존재하지 않습니다."
            DiagnosisResult = "취약"
        }
    }
}

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-029"
    위험도 = "중간"
    진단항목 = "SMB 서비스 세션 중단 시간 설정"
    진단결과 = "(변수: 양호, 취약)"
    현황 = (Get-SMBSessionTimeoutStatus)
    대응방안 = "SMB 서비스의 세션 중단 시간을 적절하게 설정하십시오."
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePath

# 결과 파일 출력
Get-Content $LogFilePath | Write-Output
