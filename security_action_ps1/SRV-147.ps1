# 로그 파일 경로 설정
$ScriptName = "SCRIPTNAME"
$TMP1 = "$ScriptName.log"

# 로그 파일 초기화
"" | Set-Content -Path $TMP1

# 로그 파일에 정보 출력
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-147] 불필요한 SNMP 서비스 실행" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append
"[양호]: SNMP 서비스가 비활성화되어 있는 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: SNMP 서비스가 활성화되어 있는 경우" | Out-File -FilePath $TMP1 -Append
"----------------------------------------" | Out-File -FilePath $TMP1 -Append

# SNMP 서비스 상태 확인
$service = Get-Service -Name SNMP -ErrorAction SilentlyContinue

if ($service -and $service.Status -eq 'Running') {
    "WARN: SNMP 서비스가 활성화되어 있습니다." | Out-File -FilePath $TMP1 -Append
} else {
    "OK: SNMP 서비스가 비활성화되어 있습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1 | Write-Output
