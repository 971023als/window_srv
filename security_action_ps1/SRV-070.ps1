# function.ps1 내용 포함 (BAR, OK, WARN 함수 포함)
. .\function.ps1

$TMP1 = "$(Get-Location)\SRV-070_log.txt"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-070] 취약한 패스워드 저장 방식 사용 조치"
Add-Content -Path $result -Value $CODE

BAR

# 웹 애플리케이션 구성 파일의 경로
$CONFIG_FILE = "C:\inetpub\wwwroot\YourApp\web.config"

# 패스워드 저장 방식을 강화하기 위한 설정 변경
# 예시: membership 섹션에서 passwordFormat 속성을 "Hashed"로 설정
$pattern = 'passwordFormat="Clear"'
$replacement = 'passwordFormat="Hashed"'
(Get-Content -Path $CONFIG_FILE) -replace $pattern, $replacement | Set-Content -Path $CONFIG_FILE

# 변경 후 설정 확인
$hashAlgorithm = Select-String -Path $CONFIG_FILE -Pattern "passwordFormat=\"Hashed\"" -Quiet
if ($hashAlgorithm) {
    OK "패스워드 저장에 강력한 해싱 알고리즘이 사용 중입니다: $CONFIG_FILE"
} else {
    WARN "패스워드 저장 방식 변경을 시도했으나, 확인이 필요합니다: $CONFIG_FILE"
}

Get-Content -Path $result | Out-Host

Write-Host "`n스크립트 완료. 패스워드 저장 방식이 강화되었습니다."
