# 스크립트 이름과 로그 파일 설정
$SCRIPTNAME = $MyInvocation.MyCommand.Name.Replace(".ps1", "")
$TMP1 = "$SCRIPTNAME.log"

# 로그 파일 초기화
"" | Set-Content -Path $TMP1

# 로그 파일에 헤더 및 정보 추가
"BAR" | Out-File -FilePath $TMP1 -Append
"CODE [SRV-171] FTP 서비스 정보 노출" | Out-File -FilePath $TMP1 -Append
"[양호]: FTP 서버에서 버전 정보 및 기타 세부 정보가 노출되지 않는 경우" | Out-File -FilePath $TMP1 -Append
"[취약]: FTP 서버에서 버전 정보 및 기타 세부 정보가 노출되는 경우" | Out-File -FilePath $TMP1 -Append
"BAR" | Out-File -FilePath $TMP1 -Append

# FTP 서비스 실행 상태 확인
$serviceStatus = Get-Service -Name 'ftpsvc' -ErrorAction SilentlyContinue

# 서비스 상태에 따른 메시지 출력
if ($serviceStatus.Status -eq 'Running') {
    "FTP 서비스가 실행 중입니다." | Out-File -FilePath $TMP1 -Append
    "[주의] FTP 서버의 버전 정보 및 세부 정보 노출 여부를 수동으로 확인해야 합니다." | Out-File -FilePath $TMP1 -Append
} else {
    "FTP 서비스가 실행되지 않습니다." | Out-File -FilePath $TMP1 -Append
}

"BAR" | Out-File -FilePath $TMP1 -Append

# 결과 표시
Get-Content -Path $TMP1 | Write-Host

Write-Host "`n스크립트 완료."
