# function.ps1 내용 포함 (적절한 경로 지정 필요)
. .\function.ps1

$TMP1 = "$(Get-Location)\$(SCRIPTNAME)_log.txt"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-079] 익명 사용자에게 부적절한 권한(Everyone) 적용 조치"
Add-Content -Path $TMP1 -Value $CODE

BAR

# C:\ 드라이브 내의 모든 파일 및 폴더에 대한 권한 변경
$worldWritableFiles = Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue | Where-Object {
    $acl = Get-Acl -Path $_.FullName
    $accessRules = $acl.Access | Where-Object { $_.FileSystemRights -match "Write" -and $_.IdentityReference.Value -eq "Everyone" }
    return $accessRules
}

foreach ($file in $worldWritableFiles) {
    $acl = Get-Acl -Path $file.FullName
    $acl.Access | Where-Object { $_.FileSystemRights -match "Write" -and $_.IdentityReference.Value -eq "Everyone" } | ForEach-Object {
        $acl.RemoveAccessRule($_) | Out-Null
    }
    Set-Acl -Path $file.FullName -AclObject $acl
    OK "Everyone 쓰기 권한이 제거된 항목: $($file.FullName)"
}

if (-not $worldWritableFiles) {
    OK "Everyone 쓰기 권한이 설정된 항목이 없습니다."
}

Get-Content -Path $TMP1 | Out-Host

Write-Host "`n스크립트 완료. 'Everyone' 그룹에 부여된 부적절한 권한을 제거했습니다."
