# function.ps1 내용 포함 (적절한 경로 지정 필요)
. .\function.ps1

$TMP1 = "$(SCRIPTNAME).log"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-072] 기본 관리자 계정명(Administrator) 존재"

$result = "결과 파일 경로를 지정해야 함" # 이전 예제에서 $result 경로를 지정하지 않았으므로, 실제 사용시 경로를 지정해야 함
Add-Content -Path $result -Value "[양호]: 기본 'Administrator' 계정이 존재하지 않는 경우"
Add-Content -Path $result -Value "[취약]: 기본 'Administrator' 계정이 존재하는 경우"

BAR

# 'Administrator' 계정 확인
$accountExists = Get-LocalUser | Where-Object { $_.Name -eq "Administrator" }
if ($accountExists) {
    Add-Content -Path $TMP1 -Value "WARN: 기본 'Administrator' 계정이 존재합니다."
} else {
    Add-Content -Path $TMP1 -Value "OK: 기본 'Administrator' 계정이 존재하지 않습니다."
}

Get-Content -Path $result

Write-Host "`n"
