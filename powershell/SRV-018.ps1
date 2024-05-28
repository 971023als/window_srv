# 변수 설정
$LogFilePath = "$($MyInvocation.MyCommand.Name).json"
$NFSExportsFile = "/etc/exports"
$SMBConfFile = "/etc/samba/smb.conf"

# 공유 활성화 상태 검사
function Check-ShareActivation {
    Param (
        [string]$file,
        [string]$serviceName
    )
    
    if (Test-Path $file) {
        $content = Get-Content $file
        if ($content -match "^\s*/") {
            @{
                Service = $serviceName
                ShareEnabled = $true
                Message = "$serviceName 서비스에서 불필요한 공유가 활성화되어 있습니다: $file"
                DiagnosisResult = "취약"
            }
        } else {
            @{
                Service = $serviceName
                ShareEnabled = $false
                Message = "$serviceName 서비스에서 불필요한 공유가 비활성화되어 있습니다: $file"
                DiagnosisResult = "양호"
            }
        }
    } else {
        @{
            Service = $serviceName
            FileFound = $false
            Message = "$serviceName 서비스 설정 파일($file)을 찾을 수 없습니다."
            DiagnosisResult = "정보 미확인"
        }
    }
}

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-018"
    위험도 = "중간"
    진단항목 = "하드디스크 기본 공유 활성화 상태"
    진단결과 = "(변수: 양호, 취약, 정보 미확인) "
    NFS현황 = (Check-ShareActivation -file $NFSExportsFile -serviceName "NFS")
    SMBCIFS현황 = (Check-ShareActivation -file $SMBConfFile -serviceName "SMB/CIFS")
    대응방안 = "NFS와 SMB/CIFS에서 불필요한 하드디스크 기본 공유를 비활성화하세요."
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePath

# 결과 파일 출력
Get-Content $LogFilePath | Write-Output
