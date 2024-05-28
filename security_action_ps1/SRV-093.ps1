function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

$SCRIPTNAME = $MyInvocation.MyCommand.Name
$global:TMP1 = "$(Get-Location)\${SCRIPTNAME}_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[SRV-093] 불필요한 world writable 파일 존재"

Add-Content -Path $global:TMP1 -Value "[양호]: 시스템에 불필요한 world writable 파일이 존재하지 않는 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: 시스템에 불필요한 world writable 파일이 존재하는 경우"

BAR

# 시스템의 모든 파일을 대상으로 'Everyone'에게 쓰기 권한이 부여된 파일 검색 및 권한 수정
$worldWritableFiles = Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue | Where-Object {
    $acl = Get-Acl $_.FullName -ErrorAction SilentlyContinue
    $accessRights = $acl.Access | Where-Object {
        $_.FileSystemRights -match "Write" -and $_.IdentityReference.Value -eq "Everyone"
    }
    return $accessRights
}

if ($worldWritableFiles) {
    foreach ($file in $worldWritableFiles) {
        $acl = Get-Acl $file.FullName
        foreach ($accessRight in $acl.Access | Where-Object {$_.IdentityReference.Value -eq "Everyone" -and $_.FileSystemRights -match "Write"}) {
            $acl.RemoveAccessRule($accessRight)
            Set-Acl -Path $file.FullName -AclObject $acl
        }
        Add-Content -Path $global:TMP1 -Value "FIXED: world writable 설정이 제거되었습니다. 파일: $($file.FullName)"
    }
} else {
    Add-Content -Path $global:TMP1 -Value "OK: 시스템에 world writable 파일이 존재하지 않습니다."
}

Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n스크립트 완료."
