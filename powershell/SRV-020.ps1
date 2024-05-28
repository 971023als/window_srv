# 변수 설정
$LogFilePath = "$($MyInvocation.MyCommand.Name).json"

# 공유 접근 통제 검사
function Check-AccessControl {
    Param (
        [string]$serviceName,
        [string]$shareType
    )
    
    $result = @()

    if ($shareType -eq "SMB") {
        $shares = Get-SmbShare -ErrorAction SilentlyContinue
        $looseShares = $shares | Where-Object { $_.Name -like "*everyone*" -or $_.Name -like "*public*" }

        if ($looseShares) {
            foreach ($share in $looseShares) {
                $result += @{
                    ShareName = $share.Name
                    ShareType = "SMB"
                    Message = "$serviceName 서비스에서 느슨한 공유 접근 통제가 발견됨: $($share.Name)"
                    DiagnosisResult = "취약"
                }
            }
        } else {
            $result += @{
                ShareType = "SMB"
                Message = "$serviceName 서비스에서 공유 접근 통제가 적절함"
                DiagnosisResult = "양호"
            }
        }
    } elseif ($shareType -eq "NFS") {
        # NFS 공유 검사의 구현은 여러분의 환경에 따라 다를 수 있습니다.
        $result += @{
            ShareType = "NFS"
            Message = "Windows에서 NFS 공유 접근 통제 검사는 지원되지 않을 수 있습니다."
            DiagnosisResult = "정보 미확인"
        }
    }

    return $result
}

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-020"
    위험도 = "중간"
    진단항목 = "공유에 대한 접근 통제 미비"
    진단결과 = "(변수: 양호, 취약, 정보 미확인)"
    SMB공유현황 = (Check-AccessControl -serviceName "SMB/CIFS" -shareType "SMB")
    NFS공유현황 = (Check-AccessControl -serviceName "NFS" -shareType "NFS")
    대응방안 = "적절한 공유 접근 통제 설정을 통해 보안을 강화하세요."
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePath

# 결과 파일 출력
Get-Content $LogFilePath | Write-Output
