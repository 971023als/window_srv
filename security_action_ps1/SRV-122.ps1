# 결과 파일 정의
$TMP1 = "$(Get-Location)\$(SCRIPTNAME)_log.txt"
Remove-Item -Path $TMP1 -ErrorAction Ignore
New-Item -Path $TMP1 -ItemType File

# 시작 정보 출력
@"
CODE [SRV-122] UMASK 설정 미흡

[양호]: 시스템 전체 UMASK 설정이 022 또는 더 엄격한 경우
[취약]: 시스템 전체 UMASK 설정이 022보다 덜 엄격한 경우
"@ | Out-File -FilePath $TMP1

# 시스템 드라이브의 기본 NTFS 권한 검사 및 수정
$systemDrive = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -ne $null } | Select-Object -First 1
$rootPath = $systemDrive.Root
$acl = Get-Acl -Path $rootPath

# 보안 정책 검사 및 권한 수정
$hasWeakPermissions = $false
$identityReferences = @("Everyone", "Authenticated Users")
foreach ($identityReference in $identityReferences) {
    $permissions = $acl.Access | Where-Object { $_.IdentityReference -eq $identityReference -and $_.FileSystemRights -eq "FullControl" }
    if ($permissions) {
        $hasWeakPermissions = $true
        foreach ($permission in $permissions) {
            $acl.RemoveAccessRule($permission)
            "REMOVED: 시스템 드라이브에서 $identityReference에게 부여된 FullControl 권한이 제거되었습니다." | Out-File -FilePath $TMP1 -Append
        }
        Set-Acl -Path $rootPath -AclObject $acl
    }
}

if (-not $hasWeakPermissions) {
    "OK: 시스템 전체 UMASK 설정이 적절하게 관리되고 있습니다." | Out-File -FilePath $TMP1 -Append
} else {
    "UPDATED: 시스템 드라이브의 NTFS 권한이 엄격하게 수정되었습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1
