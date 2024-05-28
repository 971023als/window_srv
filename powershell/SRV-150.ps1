# 로컬 관리자 그룹 멤버 확인
$adminGroupMembers = Get-LocalGroupMember -Group "Administrators"

# 결과 파일 경로 설정
$TMP1 = "$(Get-Date -Format 'yyyyMMddHHmmss')_LocalLogonPolicyCheck.log"

# 결과 파일에 헤더 추가
"로컬 로그온 허용 정책 확인" | Out-File -FilePath $TMP1
"====================================" | Out-File -FilePath $TMP1 -Append

# 관리자 그룹 멤버 출력
"로컬 'Administrators' 그룹 멤버:" | Out-File -FilePath $TMP1 -Append
$adminGroupMembers | ForEach-Object {
    $_.Name | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 내용 출력
Get-Content -Path $TMP1 | Write-Output

# 추가 안내 메시지
"`n추가 확인이 필요한 경우, secpol.msc 또는 그룹 정책 편집기(GPEDIT.MSC)를 통해 '로컬 정책 > 보안 옵션'에서 로컬 로그온 관련 정책을 확인하세요." | Out-File -FilePath $TMP1 -Append
