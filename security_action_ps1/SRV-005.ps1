# 로그 파일 설정
$TMP1 = "{0}.log" -f $MyInvocation.MyCommand.Name
# 로그 파일 초기화
"" | Set-Content $TMP1

# 로그 파일에 정보 추가
@"
------------------------------------------------
CODE [SRV-005] SMTP 서비스의 expn/vrfy 명령어 실행 제한 미비
------------------------------------------------
[양호]: SMTP 서비스가 expn 및 vrfy 명령어 사용을 제한하고 있는 경우
[취약]: SMTP 서비스가 expn 및 vrfy 명령어 사용을 제한하지 않는 경우
------------------------------------------------
"@ | Out-File -FilePath $TMP1 -Append

# Windows 환경에서 SMTP 서비스 확인
$smtpService = Get-Service -Name 'SMTPSVC' -ErrorAction SilentlyContinue
if ($smtpService.Status -eq 'Running') {
    "SMTP 서비스가 실행 중입니다." | Out-File -FilePath $TMP1 -Append
    # Exchange 서버의 expn/vrfy 명령어 사용 제한 설정 안내
    @"
Exchange 서버에서 EXPN 및 VRFY 명령어 사용을 제한하려면, Exchange 관리 셸을 사용하여 다음 명령어를 실행하세요:

Set-ReceiveConnector "<ConnectorName>" -ProtocolLoggingLevel verbose
(이 명령어는 로깅 수준을 조정합니다. EXPN 및 VRFY 사용을 직접적으로 제한하지는 않지만, 모든 SMTP 통신을 로깅하여 분석할 수 있게 합니다.)

또한, Exchange 관리 센터에서 메일 흐름 규칙을 설정하여 특정 조건에 따라 EXPN 및 VRFY 명령어를 사용한 메시지를 차단할 수 있습니다.

자세한 설정 방법은 Exchange 서버 문서를 참조하거나, IT 보안 전문가에게 문의하세요.
"@ | Out-File -FilePath $TMP1 -Append
} else {
    "SMTP 서비스가 비활성화되어 있거나 실행 중이지 않습니다." | Out-File -FilePath $TMP1 -Append
}

"------------------------------------------------" | Out-File -FilePath $TMP1 -Append

# 결과 파일 출력
Get-Content $TMP1 | Write-Output
