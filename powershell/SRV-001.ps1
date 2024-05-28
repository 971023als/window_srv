# 변수 설정
$LogFilePath = "$($MyInvocation.MyCommand.Name).json"
$SNMPServiceName = "SNMP"
$SNMPRegPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities'

# SNMP 상태 확인 및 설정 검사
function Get-SNMPStatus {
    $service = Get-Service -Name $SNMPServiceName -ErrorAction SilentlyContinue
    if ($service -eq $null -or $service.Status -ne 'Running') {
        @{
            Running = $false
            Message = "SNMP 서비스가 실행 중이지 않습니다."
            DiagnosisResult = "취약"
        }
    } else {
        $communityStatus = Check-SNMPCommunity
        @{
            Running = $true
            Message = "SNMP 서비스가 실행 중입니다."
            CommunityStatus = $communityStatus
            DiagnosisResult = if ($communityStatus.Vulnerable) { "취약" } else { "양호" }
        }
    }
}

# SNMP 커뮤니티 스트링 설정 확인
function Check-SNMPCommunity {
    $snmpCommunities = Get-ItemProperty -Path $SNMPRegPath -ErrorAction SilentlyContinue
    if ($snmpCommunities -eq $null) {
        @{
            Found = $false
            Message = "SNMP Community 스트링 설정을 찾을 수 없습니다."
            Vulnerable = $true
        }
    } else {
        $vulnerable = $false
        $vulnerableCommunities = @()
        foreach ($community in $snmpCommunities.PSObject.Properties.Name) {
            if ($community -eq 'public' -or $community -eq 'private') {
                $vulnerable = $true
                $vulnerableCommunities += $community
            }
        }
        @{
            Found = $true
            Vulnerable = $vulnerable
            VulnerableCommunities = $vulnerableCommunities
        }
    }
}

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-001"
    위험도 = "중간"
    진단항목 = "SNMP 서비스 Get Community 스트링 설정"
    현황 = (Get-SNMPStatus)
    대응방안 = "SNMP Community 스트링을 복잡하고 예측 불가능하게 설정"
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePath

# 결과 파일 출력
Get-Content $LogFilePath | Write-Output
