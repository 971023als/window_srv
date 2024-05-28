# 로그 파일 설정
$TMP1 = "$($MyInvocation.MyCommand.Name).log"
# 로그 파일 초기화
"" | Set-Content $TMP1

# 로그 파일에 정보 추가
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-002] SNMP 서비스 Set Community 스트링 설정 오류" | Out-File -FilePath $TMP1 -Append
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append
"[양호]: SNMP Set Community 스트링이 복잡하고 예측 불가능하게 설정된 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: SNMP Set Community 스트링이 기본값이거나 예측 가능하게 설정된 경우" | Out-File -FilePath $TMP1 -Append
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append

# SNMP 서비스 실행 중인지 확인
$service = Get-Service -Name SNMP -ErrorAction SilentlyContinue
if ($service -eq $null -or $service.Status -ne 'Running') {
    "SNMP 서비스가 실행 중이지 않습니다." | Out-File -FilePath $TMP1 -Append
} else {
    $snmpRegPathSet = 'HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\ValidCommunities'
    $snmpCommunitiesSet = Get-ItemProperty -Path $snmpRegPathSet -ErrorAction SilentlyContinue
    if ($snmpCommunitiesSet -eq $null) {
        "SNMP Set Community 스트링 설정을 찾을 수 없습니다." | Out-File -FilePath $TMP1 -Append
    } else {
        foreach ($community in $snmpCommunitiesSet.PSObject.Properties) {
            # 쓰기 권한을 가진 Community 스트링 확인
            if ($community.Value -eq 4) {
                # 복잡하고 예측 불가능한 새 Community 스트링 생성
                $newComplexString = "ComplexSet$(Get-Random -Maximum 99999999)"
                # 새 Community 스트링 설정
                Set-ItemProperty -Path $snmpRegPathSet -Name $newComplexString -Value 4
                # 기존 Community 스트링 제거
                Remove-ItemProperty -Path $snmpRegPathSet -Name $community.Name

                "변경됨: SNMP Set Community 스트링을 '$newComplexString'로 변경하여 보안을 강화했습니다." | Out-File -FilePath $TMP1 -Append
                break # 첫 번째 취약한 설정을 변경한 후 중단
            }
        }
    }
}

"------------------------------------------------" | Out-File -FilePath $TMP1 -Append

# 결과 파일 출력
Get-Content $TMP1 | Write-Output
