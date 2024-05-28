# function.ps1 내용 포함 (적절한 경로 지정 필요)
. .\function.ps1

$TMP1 = "$(SCRIPTNAME).log"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-070] 취약한 패스워드 저장 방식 사용"

$result = "결과 파일 경로를 지정해야 함" # 이전 예제에서 $result 경로를 지정하지 않았으므로, 실제 사용시 경로를 지정해야 함
Add-Content -Path $result -Value "[양호]: 패스워드 저장에 강력한 해싱 알고리즘을 사용하는 경우"
Add-Content -Path $result -Value "[취약]: 패스워드 저장에 취약한 해싱 알고리즘을 사용하는 경우"

BAR

# 패스워드 해싱 알고리즘 확인
$PAM_FILE = "/etc/pam.d/common-password"

# MD5, DES와 같이 취약한 알고리즘을 확인합니다
if (Select-String -Path $PAM_FILE -Pattern "md5|des" -Quiet) {
    Add-Content -Path $TMP1 -Value "WARN: 취약한 패스워드 해싱 알고리즘이 사용 중입니다: $PAM_FILE"
} else {
    Add-Content -Path $TMP1 -Value "OK: 강력한 패스워드 해싱 알고리즘이 사용 중입니다: $PAM_FILE"
}

Get-Content -Path $result

Write-Host "`n"
