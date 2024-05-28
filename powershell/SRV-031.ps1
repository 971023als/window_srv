# 변수 설정
$LogFilePath = "$($MyInvocation.MyCommand.Name).json"
$RegistryPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters'

# 네트워크 공유의 열거 제한 설정 검사
function Get-SMBExposureStatus {
    $restrictNullSessAccess = Get-ItemPropertyValue -Path $RegistryPath -Name 'RestrictNullSessAccess' -ErrorAction SilentlyContinue
    if ($null -ne $restrictNullSessAccess -and $restrictNullSessAccess -eq 1) {
        @{
            ExposureLimited = $true
            Message = "SMB 서비스에서 계정 목록 및 네트워크 공유 이름이 적절하게 보호되고 있습니다."
            DiagnosisResult = "양호"
        }
    } else {
        @{
            ExposureLimited = $false
            Message = "SMB 서비스에서 계정 목록 또는 네트워크 공유 이름이 노출될 수 있습니다."
            DiagnosisResult = "취약"
        }
    }
}

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-031"
    위험도 = "중간"
    진단항목 = "SMB 서비스 계정 목록 및 네트워크 공유 이름 노출"
    진단결과 = "(변수: 양호, 취약)"
    현황 = (Get-SMBExposureStatus)
    대응방안 = "SMB 서비스의 네트워크 공유 열거를 제한하도록 설정하십시오."
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePath

# 결과 파일 출력
Get-Content $LogFilePath | Write-Output
