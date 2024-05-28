# 변수 설정
$LogFilePath = "$($MyInvocation.MyCommand.Name).json"
$RpcServiceNames = @("rpc.cmsd", "rpc.ttdbserverd", "sadmind", "rusersd", "walld", "sprayd", "rstatd", "rpc.nisd", "rexd", "rpc.pcnfsd", "rpc.statd", "rpc.ypupdated", "rpc.rquotad", "kcms_server", "cachefsd")

# RPC 서비스 활성화 여부 확인
function Get-RPCServiceStatus {
    $serviceActive = $False
    $activeServices = @()

    foreach ($service in $RpcServiceNames) {
        $status = Get-Service -Name $service -ErrorAction SilentlyContinue
        if ($status -and $status.Status -eq 'Running') {
            $serviceActive = $True
            $activeServices += $service
        }
    }

    if ($serviceActive) {
        @{
            Running = $true
            ActiveServices = $activeServices
            Message = "불필요한 RPC 서비스가 활성화 되어 있습니다."
            DiagnosisResult = "취약"
        }
    } else {
        @{
            Running = $false
            Message = "불필요한 RPC 서비스가 비활성화 되어 있습니다."
            DiagnosisResult = "양호"
        }
    }
}

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-016"
    위험도 = "중간"
    진단항목 = "RPC 서비스 실행 여부"
    진단결과 = "(변수: 양호, 취약) "
    현황 = (Get-RPCServiceStatus)
    대응방안 = "불필요한 RPC 서비스를 비활성화 하세요."
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePath

# 결과 파일 출력
Get-Content $LogFilePath | Write-Output
