# 로그 파일 설정
$TMP1 = "$($MyInvocation.MyCommand.Name).log"
# 로그 파일 초기화
"" | Set-Content $TMP1

# 로그 파일에 정보 추가
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-001] SNMP 서비스 Get Community 스트링 설정 오류" | Out-File -FilePath $TMP1 -Append
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append
"[양호]: SNMP Community 스트링이 복잡하고 예측 불가능하게 설정된 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: SNMP Community 스트링이 기본값이거나 예측 가능하게 설정된 경우" | Out-File -FilePath $TMP1 -Append
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append

# SNMP 서비스 실행 상태 확인
$service = Get-Service -Name SNMP -ErrorAction SilentlyContinue
if ($service -eq $null -or $service.Status -ne 'Running') {
    "SNMP 서비스가 실행 중이지 않습니다. 설정 변경을 위해 서비스를 시작하세요." | Out-File -FilePath $TMP1 -Append
} else {
    $snmpRegPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities'
    $snmpCommunities = Get-ItemProperty -Path $snmpRegPath -ErrorAction SilentlyContinue
    if ($snmpCommunities -eq $null) {
        "SNMP Community 스트링 설정을 찾을 수 없습니다. SNMP 서비스를 확인하세요." | Out-File -FilePath $TMP1 -Append
    } else {
        $defaultCommunities = @('public', 'private')
        foreach ($community in $snmpCommunities.PSObject.Properties.Name) {
            if ($defaultCommunities -contains $community) {
                # 새롭고 복잡한 Community 스트링 생성 예시 (실제 운영 환경에서는 더 복잡하고 예측 불가능하게 설정해야 함)
                $newCommunity = "NewComplexString$(Get-Random)"
                Set-ItemProperty -Path $snmpRegPath -Name $newCommunity -Value 4 -ErrorAction SilentlyContinue
                Remove-ItemProperty -Path $snmpRegPath -Name $community -ErrorAction SilentlyContinue
                "변경: 기본 SNMP Community 스트링($community)을 양호한 값으로 변경하였습니다. 새로운 값: $newCommunity" | Out-File -FilePath $TMP1 -Append
            }
        }
    }
}

# 결과 파일 출력
Get-Content $TMP1 | Write-Output
