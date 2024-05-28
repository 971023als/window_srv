# 변수 설정
$LogFilePath = "$($MyInvocation.MyCommand.Name).json"
$NFSProcessNames = "nfs|rpc.statd|statd|rpc.lockd|lockd"

# NFS 서비스 관련 데몬의 실행 여부 확인
function Get-NFSDaemonStatus {
    $nfsDaemonCount = Get-Process | Where-Object { $_.ProcessName -match $NFSProcessNames } | Measure-Object
    if ($nfsDaemonCount.Count -gt 0) {
        @{
            Running = $true
            Message = "불필요한 NFS 서비스 관련 데몬이 실행 중입니다."
            DiagnosisResult = "취약"
        }
    } else {
        @{
            Running = $false
            Message = "불필요한 NFS 서비스 관련 데몬이 비활성화 되어 있습니다."
            DiagnosisResult = "양호"
        }
    }
}

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-015"
    위험도 = "중간"
    진단항목 = "NFS 서비스 실행 여부"
    진단결과 = "(변수: 양호, 취약) "
    현황 = (Get-NFSDaemonStatus)
    대응방안 = "불필요한 NFS 서비스 관련 데몬을 비활성화 하세요."
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePath

# 결과 파일 출력
Get-Content $LogFilePath | Write-Output
