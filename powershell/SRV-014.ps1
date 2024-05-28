# 결과 파일 초기화
$LogFilePath = "$($MyInvocation.MyCommand.Name).log"

# 로깅 함수 정의
function Write-Log {
    Param (
        [string]$message,
        [string]$type = 'INFO'
    )
    "$type: $message" | Out-File -FilePath $LogFilePath -Append
}

function Check-NFSAccess {
    $nfsProcesses = Get-Process | Where-Object { $_.ProcessName -match "nfs|rpc.statd|statd|rpc.lockd|lockd" } | Measure-Object
    $exportsExist = Test-Path "/etc/exports"
    if ($nfsProcesses.Count -gt 0 -and $exportsExist) {
        $exportsContent = Get-Content "/etc/exports"
        $allCount = ($exportsContent | Where-Object { $_ -match "/" -and $_ -match "\*" }).Count
        $insecureCount = ($exportsContent | Where-Object { $_ -match "/" -and $_ -match "insecure" }).Count
        $directoryCount = ($exportsContent | Where-Object { $_ -match "/" }).Count
        $squashCount = ($exportsContent | Where-Object { $_ -match "/" -and $_ -match "root_squash|all_squash" }).Count

        $accessStatus = @{
            AllAccess = $allCount -gt 0
            InsecureOptions = $insecureCount -gt 0
            MissingSquash = $directoryCount -ne $squashCount
        }

        return $accessStatus
    } else {
        return @{
            NFSRunning = $false
        }
    }
}

# JSON 데이터 구성 및 로깅
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-014"
    위험도 = "중간"
    진단항목 = "NFS 접근통제 설정"
    진단결과 = "(변수: 양호, 취약) "
    현황 = (Check-NFSAccess)
    대응방안 = "불필요한 NFS 서비스를 사용하지 않거나, 불가피하게 사용 시 everyone 공유를 제한"
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePath

# 결과 파일 출력
Get-Content $LogFilePath | Write-Output
