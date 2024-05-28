# 로그 파일 생성 및 초기화
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

# 메시지 출력
"코드 [SRV-060] 웹 서비스의 기본 계정(아이디 또는 비밀번호) 미변경" | Out-File -FilePath $TMP1 -Append
"[양호]: 웹 서비스의 기본 계정(아이디 또는 비밀번호)이 변경됨" | Out-File -FilePath $TMP1 -Append
"[취약]: 웹 서비스의 기본 계정(아이디 또는 비밀번호)이 변경되지 않음" | Out-File -FilePath $TMP1 -Append

# 웹 서비스 설정 파일의 예시 경로
$CONFIG_FILE = "C:\path\to\web_service\config.txt"

# 기본 계정 확인
$pattern = "username=admin password=password"
$match = Select-String -Path $CONFIG_FILE -Pattern $pattern

if ($match) {
    "경고: 웹 서비스의 기본 계정(아이디 또는 비밀번호)이 변경되지 않음" | Out-File -FilePath $TMP1 -Append
} else {
    "OK: 웹 서비스의 기본 계정(아이디 또는 비밀번호)이 변경됨" | Out-File -FilePath $TMP1 -Append
}

# 결과 표시
Get-Content -Path $TMP1 | Write-Output

Write-Host "`n스크립트 완료."
