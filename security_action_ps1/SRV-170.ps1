# 결과 파일 정의
$TMP1 = "$env:SCRIPTNAME.log"
# 결과 파일 초기화
"" | Set-Content -Path $TMP1

# 구분선 함수
Function Bar {
    "----------------------------------------" | Out-File -FilePath $TMP1 -Append
}

Bar

# 코드 및 상태 정보 출력
@"
CODE [SRV-170] SMTP 서비스 정보 노출
[양호]: SMTP 서비스에서 버전 정보 및 기타 세부 정보가 노출되지 않는 경우
[취약]: SMTP 서비스에서 버전 정보 및 기타 세부 정보가 노출되는 경우
"@ | Out-File -FilePath $TMP1 -Append

Bar

# SMTP 서비스 설정 확인 로직 (Windows 환경에 맞게 조정 필요)
# Windows에서는 IIS를 통한 SMTP 서비스 관리가 일반적이며, PowerShell을 통한 직접적인 확인이 제한적일 수 있습니다.
# 이 부분은 시스템 관리자가 직접 SMTP 서비스의 설정을 검토하거나, 관리 도구를 통해 확인해야 할 수 있습니다.

# 예시 메시지
"INFO: SMTP 서비스의 정보 노출 관련 설정은 IIS 관리 콘솔 또는 해당 SMTP 서버의 구성 파일을 통해 확인해야 합니다." | Out-File -FilePath $TMP1 -Append

# 결과 파일 출력
Get-Content -Path $TMP1 | Write-Output

Write-Host "`nScript complete."
