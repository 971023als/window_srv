$TMP1 = "$(SCRIPTNAME).log"
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-093] 불필요한 world writable 파일 존재"

Add-Content -Path $TMP1 -Value "[양호]: 시스템에 불필요한 world writable 파일이 존재하지 않는 경우"
Add-Content -Path $TMP1 -Value "[취약]: 시스템에 불필요한 world writable 파일이 존재하는 경우"

BAR

# 시스템의 모든 파일을 대상으로 'Everyone'에게 쓰기 권한이 부여된 파일 검색
$worldWritableFiles = Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue | Where-Object {
    try {
        $acl = Get-Acl $_.FullName
        $acl.Access | Where-Object {
            $_.FileSystemRights -match "Write" -and $_.IdentityReference -eq "Everyone"
        }
    } catch {
        $false
    }
}

if ($worldWritableFiles) {
    foreach ($file in $worldWritableFiles) {
        Add-Content -Path $TMP1 -Value "WARN: world writable 설정이 되어 있는 파일이 있습니다. 파일: $($file.FullName)"
    }
} else {
    Add-Content -Path $TMP1 -Value "OK: 시스템에 world writable 파일이 존재하지 않습니다."
}

Get-Content -Path $TMP1

Write-Host "`n"
