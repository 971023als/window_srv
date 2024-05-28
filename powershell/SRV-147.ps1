# 결과 파일 경로 설정
$TMP1 = "$(Get-Date -Format 'yyyyMMddHHmmss')_SNMPServiceCheck.log"

# 결과 파일에 헤더 추가
"SNMP 서비스 실행 상태 확인" | Out-File -FilePath $TMP1
"=================================" | Out-File -FilePath $TMP1 -Append

# SNMP 서비스 상태 확인
$snmpService = Get-Service -Name 'SNMP*' -ErrorAction SilentlyContinue

# 결과 평가 및 로그 파일에 기록
if ($snmpService -and $snmpService.Status -eq 'Running') {
    "WARN: SNMP 서비스를 사용하고 있습니다." | Out-File -FilePath $TMP1 -Append
} else {
    "OK: SNMP 서비스가 비활성화되어 있습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 내용 출력
Get-Content -Path $TMP1 | Write-Output
