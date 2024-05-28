# 결과 파일 초기화
$TMP1 = "$(Split-Path -Leaf $MyInvocation.MyCommand.Definition).log"
"" | Set-Content $TMP1

Function BAR {
    "-------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

Function CODE {
    Param ([string]$message)
    $message | Out-File -FilePath $TMP1 -Append
}

Function WARN {
    Param ([string]$message)
    "WARN: $message" | Out-File -FilePath $TMP1 -Append
}

Function OK {
    Param ([string]$message)
    "OK: $message" | Out-File -FilePath $TMP1 -Append
}

BAR

CODE "[SRV-016] 불필요한 RPC서비스 활성화"

@"
[양호]: 불필요한 RPC 서비스가 비활성화 되어 있는 경우
[취약]: 불필요한 RPC 서비스가 활성화 되어 있는 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# RPC 관련 서비스 목록
$rpcServices = @("RpcSs", "DcomLaunch", "RpcEptMapper")

# 서비스 활성화 여부 확인
foreach ($service in $rpcServices) {
    $status = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($status -and $status.Status -eq 'Running') {
        WARN "불필요한 RPC 서비스 [$service]가 활성화 되어 있습니다. 고려하여 비활성화하세요."
    } else {
        OK "RPC 서비스 [$service]가 비활성화 되어 있습니다."
    }
}

BAR

Get-Content $TMP1 | Write-Output
