# 로그 파일 생성 및 초기화
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

# 메시지 출력
"코드 [SRV-060] 웹 서비스의 기본 계정(아이디 또는 비밀번호) 미변경 조치" | Out-File -FilePath $TMP1 -Append

# 웹 서비스 설정 파일의 경로
$CONFIG_FILE = "C:\path\to\web_service\config.txt"

# 새로운 계정 정보
$newUsername = "newAdmin"
$newPassword = "newPassword123!"

# 설정 파일에서 기본 계정 정보 변경
(Get-Content -Path $CONFIG_FILE) -replace 'username=admin', "username=$newUsername" -replace 'password=password', "password=$newPassword" | Set-Content -Path $CONFIG_FILE

# 변경 확인
$pattern = "username=$newUsername password=$newPassword"
$match = Select-String -Path $CONFIG_FILE -Pattern $pattern

if ($match) {
    "OK: 웹 서비스의 기본 계정(아이디 또는 비밀번호)이 성공적으로 변경됨" | Out-File -FilePath $TMP1 -Append
} else {
    "경고: 웹 서비스의 기본 계정(아이디 또는 비밀번호) 변경 실패" | Out-File -FilePath $TMP1 -Append
}

# 결과 표시
Get-Content -Path $TMP1 | Write-Output

Write-Host "`n스크립트 완료. 변경 사항을 확인하세요."
