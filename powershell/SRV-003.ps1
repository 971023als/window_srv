# 변수 설정
$LogFilePathACL = "$($MyInvocation.MyCommand.Name)_ACL.json"
$SNMPServiceName = "SNMP"
$SNMPRegPathACL = 'HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers'

# SNMP 접근 통제 설정 확인 및 상태 검사
function Get-SNMPAccessControlStatus {
    $service = Get-Service -Name $SNMPServiceName -ErrorAction SilentlyContinue
    if ($service -eq $null -or $service.Status -ne 'Running') {
        @{
            Running = $false
            Message = "SNMP 서비스가 실행 중이지 않습니다."
            DiagnosisResult = "취약"
        }
    } else {
        $accessControlStatus = Check-SNMPAccessControl
        @{
            Running = $true
            Message = "SNMP 서비스가 실행 중입니다."
            AccessControlStatus = $accessControlStatus
            DiagnosisResult = if ($accessControlStatus.Vulnerable) { "취약" } else { "양호" }
        }
    }
}

# SNMP 접근 통제 설정 확인
function Check-SNMPAccessControl {
    $snmpACLs = Get-ItemProperty -Path $SNMPRegPathACL -ErrorAction SilentlyContinue
    if ($snmpACLs -eq $null) {
        @{
            Found = $false
            Message = "SNMP 접근 통제 설정이 발견되지 않았습니다."
            Vulnerable = $true
        }
    } else {
        $aclCount = 0
        foreach ($acl in $snmpACLs.PSObject.Properties) {
            if ($acl.Name -notmatch '^(PSPath|PSParentPath|PSChildName|PSDrive|PSProvider)$') {
                $aclCount++
            }
        }
        @{
            Found = $true
            Vulnerable = $aclCount -eq 0
            PermittedManagers = $aclCount
        }
    }
}

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-003"
    위험도 = "중간"
    진단항목 = "SNMP 접근 통제 설정"
    현황 = (Get-SNMPAccessControlStatus)
    대응방안 = "적절한 SNMP 접근 통제 설정"
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePathACL

# 결과 파일 출력
Get-Content $LogFilePathACL | Write-Output
