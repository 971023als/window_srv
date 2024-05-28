# function.ps1 내용 포함 (적절한 경로 지정 필요)
. .\function.ps1

$TMP1 = "$(Get-Location)\$(SCRIPTNAME)_log.txt"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-073] 관리자 그룹에 불필요한 사용자 존재 조치"
Add-Content -Path $TMP1 -Value $CODE

BAR

# 관리자 그룹 이름을 정의합니다 (Windows 환경에서는 주로 'Administrators')
$admin_group = "Administrators"

# 관리자 그룹의 멤버 확인
$admin_members = Get-LocalGroupMember -Group $admin_group | Select-Object -ExpandProperty Name

# 관리자 그룹에서 제거해야 할 불필요한 사용자 목록 (실제 환경에 따라 수정 필요)
$unauthorized_users = @("testuser", "anotherUser") # 예시 사용자 목록

# 관리자 그룹 내 불필요한 사용자 제거
foreach ($user in $unauthorized_users) {
    if ($admin_members -contains $user) {
        Remove-LocalGroupMember -Group $admin_group -Member $user -ErrorAction SilentlyContinue
        if ($?) {
            OK "관리자 그룹($admin_group)에서 불필요한 사용자가 제거되었습니다: $user"
        } else {
            WARN "관리자 그룹($admin_group)에서 사용자를 제거하는 데 실패했습니다: $user"
        }
    }
}

Get-Content -Path $TMP1 | Out-Host

Write-Host "`n스크립트 완료. 관리자 그룹에서 불필요한 사용자가 제거되었습니다."
