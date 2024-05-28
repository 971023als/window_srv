# 결과 파일 정의
$TMP1 = "{0}.log" -f $MyInvocation.MyCommand.Name
# 결과 파일 초기화
"" | Set-Content $TMP1

# 로그 파일에 정보 추가
@"
------------------------------------------------
CODE [SRV-006] SMTP 서비스 로그 수준 설정 미흡
------------------------------------------------
[양호]: SMTP 서비스의 로그 수준이 적절하게 설정되어 있는 경우
[취약]: SMTP 서비스의 로그 수준이 낮거나, 로그가 충분히 수집되지 않는 경우
------------------------------------------------
"@ | Out-File -FilePath $TMP1 -Append

# SMTP 로그 수준을 'High'로 설정
try {
    # Exchange Transport 서버의 로그 수준 설정
    Set-TransportServer -Identity YourServerName -LogLevel High

    "SMTP 서비스의 로그 수준을 'High'로 설정하였습니다." | Out-File -FilePath $TMP1 -Append
} catch {
    "SMTP 서비스의 로그 수준 설정 중 오류가 발생하였습니다: $_" | Out-File -FilePath $TMP1 -Append
}

"------------------------------------------------" | Out-File -FilePath $TMP1 -Append

# 결과 파일 출력
Get-Content $TMP1 | Write-Output
