# 변수 설정
$LogFilePath = "$($MyInvocation.MyCommand.Name).json"
$services = @('Telnet', 'RemoteRegistry') # 불필요한 서비스 목록

# 불필요한 서비스 활성화 상태 확인
function Check-UnnecessaryServices {
    $serviceDetails = @()
    foreach ($service in $services) {
        $serviceStatus = Get-Service -Name $service -ErrorAction SilentlyContinue
        if ($serviceStatus -and $serviceStatus.Status -eq 'Running') {
            $serviceDetails += @{
                ServiceName = $service
                Status = "Running"
                Diagnosis = "취약"
            }
        } else {
            $serviceDetails += @{
                ServiceName = $service
                Status = "Stopped or Not Installed"
                Diagnosis = "양호"
            }
        }
    }
    return $serviceDetails
}

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-034"
    위험도 = "중간"
    진단항목 = "불필요한 서비스 활성화 상태"
    진단결과 = Check-UnnecessaryServices
    대응방안 = "불필요한 서비스는 비활성화하십시오."
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePath

# 결과 파일 출력
Get-Content $LogFilePath | Write-Output
