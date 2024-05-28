# 결과 파일 정의
$TMP1 = "SCRIPTNAME.log"
"CODE [SRV-131] SU 명령 사용가능 그룹 제한 미비" | Out-File -FilePath $TMP1

# 관리자 그룹 멤버 확인
$adminGroupMembers = Get-LocalGroupMember -Group "Administrators" | Select-Object -ExpandProperty Name

# 결과 출력
if ($adminGroupMembers) {
    "OK: 관리자 그룹에는 다음 사용자가 포함되어 있습니다: $($adminGroupMembers -join ', ')" | Out-File -FilePath $TMP1 -Append
} else {
    "WARN: 관리자 그룹에 사용자가 포함되어 있지 않습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1
