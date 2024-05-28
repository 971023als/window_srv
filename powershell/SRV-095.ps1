$TMP1 = "$(SCRIPTNAME).log"
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-095] 존재하지 않는 소유자 및 그룹 권한을 가진 파일 또는 디렉터리 존재"

Add-Content -Path $TMP1 -Value "[양호]: 시스템에 존재하지 않는 소유자나 그룹 권한을 가진 파일 또는 디렉터리가 없는 경우"
Add-Content -Path $TMP1 -Value "[취약]: 시스템에 존재하지 않는 소유자나 그룹 권한을 가진 파일 또는 디렉터리가 있는 경우"

BAR

# 소유자나 그룹이 존재하지 않는 파일 또는 디렉터리 검색
$itemsWithInvalidOwnerOrGroup = Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue | Where-Object {
    $_ | Get-Acl | ForEach-Object {
        $owner = $_.Owner
        $group = $_.Group
        # 소유자나 그룹이 SID 형태인 경우, 해당 계정이 실제 존재하는지 확인
        $ownerExists = [System.Security.Principal.SecurityIdentifier]::new($owner).Translate([System.Security.Principal.NTAccount]) -ne $null
        $groupExists = [System.Security.Principal.SecurityIdentifier]::new($group).Translate([System.Security.Principal.NTAccount]) -ne $null
        -not $ownerExists -or -not $groupExists
    }
}

if ($itemsWithInvalidOwnerOrGroup) {
    foreach ($item in $itemsWithInvalidOwnerOrGroup) {
        Add-Content -Path $TMP1 -Value "WARN: 소유자나 그룹이 존재하지 않는 항목이 있습니다: $($item.FullName)"
    }
} else {
    Add-Content -Path $TMP1 -Value "OK: 시스템에 소유자나 그룹이 존재하지 않는 파일 또는 디렉터리가 존재하지 않습니다."
}

Get-Content -Path $TMP1

Write-Host "`n"
