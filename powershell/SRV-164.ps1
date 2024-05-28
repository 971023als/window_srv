# 필요한 외부 스크립트 또는 모듈 호출 (function.ps1이라고 가정)
. .\function.ps1

# 결과를 저장할 로그 파일 정의
$TMP1 = "$env:SCRIPTNAME.log"
# 로그 파일 초기화
"" | Set-Content -Path $TMP1

# 로그 파일에 정보 출력
@"
----------------------------------------
CODE [SRV-164] 구성원이 존재하지 않는 GID 존재
----------------------------------------
[양호]: 시스템에 구성원이 존재하지 않는 그룹(GID)가 존재하지 않는 경우
[취약]: 시스템에 구성원이 존재하지 않는 그룹(GID)이 존재하는 경우
----------------------------------------
"@ | Out-File -FilePath $TMP1 -Append

# Windows의 모든 로컬 그룹 및 그룹 구성원 확인
$groups = Get-LocalGroup
foreach ($group in $groups) {
    $members = Get-LocalGroupMember -Group $group.Name -ErrorAction SilentlyContinue
    if (-not $members) {
        "구성원이 없는 그룹: $($group.Name)" | Out-File -FilePath $TMP1 -Append
    }
}

"결과를 확인하세요." | Out-File -FilePath $TMP1 -Append

# 결과 표시
Get-Content -Path $TMP1 | Write-Output

Write-Host "`nScript complete."
