# 결과 파일 정의
$TMP1 = "$(Get-Location)\SCRIPTNAME.log"
Remove-Item -Path $TMP1 -ErrorAction Ignore
New-Item -Path $TMP1 -ItemType File

"CODE [SRV-131] SU 명령 사용가능 그룹 제한 미비" | Out-File -FilePath $TMP1

# 관리자 그룹 멤버 확인 및 권장되지 않는 사용자 제거
$adminGroupMembers = Get-LocalGroupMember -Group "Administrators"
$notRecommendedUsers = @("UserNotRecommended1", "UserNotRecommended2") # 예시 사용자 이름

foreach ($member in $adminGroupMembers) {
    if ($member.Name -in $notRecommendedUsers) {
        Remove-LocalGroupMember -Group "Administrators" -Member $member.Name -ErrorAction SilentlyContinue
        "REMOVED: $($member.Name) 사용자가 관리자 그룹에서 제거되었습니다." | Out-File -FilePath $TMP1 -Append
    }
}

# 변경 후 관리자 그룹 멤버 재확인
$updatedAdminGroupMembers = Get-LocalGroupMember -Group "Administrators" | Select-Object -ExpandProperty Name

# 결과 출력
if ($updatedAdminGroupMembers) {
    "UPDATED: 관리자 그룹에는 다음 사용자가 포함되어 있습니다: $($updatedAdminGroupMembers -join ', ')" | Out-File -FilePath $TMP1 -Append
} else {
    "WARN: 관리자 그룹에 사용자가 포함되어 있지 않습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1
