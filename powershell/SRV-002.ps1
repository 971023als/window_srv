# 변수 설정
$LogFilePathSet = "$($MyInvocation.MyCommand.Name)_Set.json"
$SNMPServiceName = "SNMP"
$SNMPRegPathSet = 'HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities'

# SNMP 상태 확인 및 Set Community 설정 검사
function Get-SNMPSetStatus {
    $service = Get-Service -Name $SNMPServiceName -ErrorAction SilentlyContinue
    if ($service -eq $null -or $service.Status -ne 'Running') {
        @{
            Running = $false
            Message = "SNMP 서비스가 실행 중이지 않습니다."
            DiagnosisResult = "취약"
        }
    } else {
        $setCommunityStatus = Check-SNMPSetCommunity
        @{
            Running = $true
            Message = "SNMP 서비스가 실행 중입니다."
            SetCommunityStatus = $setCommunityStatus
            DiagnosisResult = if ($setCommunityStatus.Vulnerable) { "취약" } else { "양호" }
        }
    }
}

# SNMP Set Community 스트링 설정 확인
function Check-SNMPSetCommunity {
    $snmpCommunitiesSet = Get-ItemProperty -Path $SNMPRegPathSet -ErrorAction SilentlyContinue
    if ($snmpCommunitiesSet -eq $null) {
        @{
            Found = $false
            Message = "SNMP Set Community 스트링 설정을 찾을 수 없습니다."
            Vulnerable = $true
        }
    } else {
        $isVulnerableSet = $false
        $vulnerableSetCommunities = @()
        foreach ($community in $snmpCommunitiesSet.PSObject.Properties) {
            if ($community.Value -eq 4) {  # '4' 가 쓰기 권한을 나타내는 값
                $isVulnerableSet = $true
                $vulnerableSetCommunities += $community.Name
            }
        }
        @{
            Found = $true
            Vulnerable = $isVulnerableSet
            VulnerableCommunities = $vulnerableSetCommunities
        }
    }
}

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-002"
    위험도 = "중간"
    진단항목 = "SNMP 서비스 Set Community 스트링 설정"
    현황 = (Get-SNMPSetStatus)
    대응방안 = "SNMP Set Community 스트링을 복잡하고 예측 불가능하게 설정"
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePathSet

# 결과 파일 출력
Get-Content $LogFilePathSet | Write-Output
