# 로그 파일 생성 및 초기화
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

# 메시지 출력
"코드 [SRV-045] 웹 서비스 프로세스 권한 제한 미비" | Out-File -FilePath $TMP1 -Append
"[양호]: 웹 서비스 프로세스가 과도한 권한으로 실행되지 않음" | Out-File -FilePath $TMP1 -Append
"[취약]: 웹 서비스 프로세스가 과도한 권한으로 실행됨" | Out-File -FilePath $TMP1 -Append

# 서비스 이름 지정 및 서비스 계정 변경
$SERVICE_NAME = "W3SVC"
$NEW_ACCOUNT = "NT AUTHORITY\NetworkService"
$NEW_ACCOUNT_PASSWORD = $null # NetworkService 계정에는 비밀번호가 필요 없음

# 서비스 계정 변경
$service = Get-WmiObject -Class Win32_Service -Filter "Name = '$SERVICE_NAME'"
$result = $service.Change($null, $null, $null, $null, $null, $null, $NEW_ACCOUNT, $NEW_ACCOUNT_PASSWORD)

if ($result.ReturnValue -eq 0) {
    "서비스 '$SERVICE_NAME'의 실행 계정이 '$NEW_ACCOUNT'로 변경되었습니다." | Out-File -FilePath $TMP1 -Append
} else {
    "오류: 서비스 '$SERVICE_NAME'의 실행 계정 변경 실패. 오류 코드: $($result.ReturnValue)" | Out-File -FilePath $TMP1 -Append
}

# 결과 출력
Get-Content -Path $TMP1 | Write-Host

Write-Host "`n스크립트 완료. 변경 사항이 성공적으로 적용되었는지 확인하세요."
