# 로그 파일 설정
$TMP1 = "$($MyInvocation.MyCommand.Name).log"
# 로그 파일 초기화
"" | Set-Content $TMP1

# 로그 파일에 정보 추가
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-003] SNMP 접근 통제 미설정" | Out-File -FilePath $TMP1 -Append
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append
"[양호]: SNMP 접근 제어가 적절하게 설정된 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: SNMP 접근 제어가 설정되지 않거나 미흡한 경우" | Out-File -FilePath $TMP1 -Append
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append

# SNMP 서비스 실행 중인지 확인
$service = Get-Service -Name SNMP -ErrorAction SilentlyContinue
if ($service -eq $null -or $service.Status -ne 'Running') {
    "SNMP 서비스가 실행 중이지 않습니다." | Out-File -FilePath $TMP1 -Append
} else {
    $snmpRegPathACL = 'HKLM:\SYSTEM\CurrentControlSet\Services\SNMP\Parameters\PermittedManagers'
    $snmpACLs = Get-ItemProperty -Path $snmpRegPathACL -ErrorAction SilentlyContinue

    # SNMP 접근 통제 설정이 발견되지 않았거나 설정이 미흡한 경우, 새로운 접근 통제 설정 추가
    if ($snmpACLs -eq $null -or $snmpACLs.PSObject.Properties.Count -le 5) { # 기본 속성을 제외하고 항목 수 확인
        # 여기서는 예시로 '192.168.1.1'을 허용 목록에 추가합니다. 실제 환경에 맞게 조정하세요.
        $newManagerIP = "192.168.1.1"
        $index = 1 # 시작 인덱스 설정. 실제 환경에 따라 조정할 수 있습니다.
        Set-ItemProperty -Path $snmpRegPathACL -Name "1" -Value $newManagerIP
        
        "설정됨: SNMP 접근 통제에 '$newManagerIP'를 추가하여 보안을 강화했습니다." | Out-File -FilePath $TMP1 -Append
    } else {
        "양호: SNMP 접근 제어가 이미 적절하게 설정되었습니다." | Out-File -FilePath $TMP1 -Append
    }
}

"------------------------------------------------" | Out-File -FilePath $TMP1 -Append

# 결과 파일 출력
Get-Content $TMP1 | Write-Output
