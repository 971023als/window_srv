# 스크립트 이름과 로그 파일 설정
$SCRIPTNAME = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)
$TMP1 = "$SCRIPTNAME.log"

# 로그 파일 초기화
"" | Set-Content -Path $TMP1

# 로그 파일에 헤더 및 정보 추가
"BAR" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-174] 불필요한 DNS 서비스 실행" | Out-File -FilePath $TMP1 -Append
"[양호]: DNS 서비스가 비활성화되어 있는 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: DNS 서비스가 활성화되어 있는 경우" | Out-File -FilePath $TMP1 -Append
"BAR" | Out-File -FilePath $TMP1 -Append

# DNS 서비스 상태 확인 (여기서는 "Dnscache" 서비스를 예로 들었습니다. 실제 서비스 이름에 맞게 조정해야 합니다.)
$serviceStatus = Get-Service -Name "Dnscache" -ErrorAction SilentlyContinue

if ($serviceStatus.Status -eq 'Running') {
    "WARN DNS 서비스(Dnscache)가 활성화되어 있습니다." | Out-File -FilePath $TMP1 -Append
} else {
    "OK DNS 서비스(Dnscache)가 비활성화되어 있습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1 | Write-Output
