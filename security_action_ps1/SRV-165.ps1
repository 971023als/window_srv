# 필요한 외부 스크립트 또는 모듈 호출 (여기서는 가정된 예시입니다)
# . .\function.ps1

# 스크립트 이름으로 로그 파일 이름 설정
$SCRIPTNAME = $MyInvocation.MyCommand.Name.Replace('.ps1', '')
$TMP1 = "$SCRIPTNAME.log"

# 로그 파일 초기화
"" | Set-Content -Path $TMP1

# 로그 파일에 코드와 기준 정보 기록
@"
----------------------------------------
CODE [SRV-165] 불필요하게 Shell이 부여된 계정 존재
[양호]: 불필요하게 Shell이 부여된 계정이 존재하지 않는 경우
[취약]: 불필요하게 Shell이 부여된 계정이 존재하는 경우
----------------------------------------
"@ | Out-File -FilePath $TMP1 -Append

# 모든 사용자 계정 나열 (PowerShell 방식)
"모든 사용자 계정:" | Out-File -FilePath $TMP1 -Append
Get-LocalUser | ForEach-Object {
    $account = $_.Name
    "계정: $account" | Out-File -FilePath $TMP1 -Append
}

# 결과 확인 메시지
"결과를 확인하세요." | Out-File -FilePath $TMP1 -Append

# 결과 표시
Get-Content -Path $TMP1 | Write-Output

Write-Host "`nScript complete."
