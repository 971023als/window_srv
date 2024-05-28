# function.ps1 내용 포함 (적절한 경로 지정 필요)
. .\function.ps1

$TMP1 = "$(SCRIPTNAME).log"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-073] 관리자 그룹에 불필요한 사용자 존재"

$result = "결과 파일 경로를 지정해야 함" # 이전 예제에서 $result 경로를 지정하지 않았으므로, 실제 사용시 경로를 지정해야 함
Add-Content -Path $result -Value "[양호]: 관리자 그룹에 불필요한 사용자가 없는 경우"
Add-Content -Path $result -Value "[취약]: 관리자 그룹에 불필요한 사용자가 존재하는 경우"

BAR

# 관리자 그룹 이름을 정의합니다 (Windows 환경에서는 주로 'Administrators')
$admin_group = "Administrators"

# 관리자 그룹의 멤버 확인
$admin_members = Get-LocalGroupMember -Group $admin_group | Select-Object -ExpandProperty Name

# 예상되지 않은 사용자가 관리자 그룹에 있는지 확인
# 여기서는 예시로 'testuser'를 사용하지만, 실제 환경에 맞게 수정 필요
if ($admin_members -contains "testuser") {
  Add-Content -Path $TMP1 -Value "WARN: 관리자 그룹($admin_group)에 불필요한 사용자(testuser)가 포함되어 있습니다."
} else {
  Add-Content -Path $TMP1 -Value "OK: 관리자 그룹($admin_group)에 불필요한 사용자가 없습니다."
}

Get-Content -Path $result

Write-Host "`n"
