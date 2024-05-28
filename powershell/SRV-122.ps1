# 결과 파일 정의
$TMP1 = "$(SCRIPTNAME).log"
Remove-Item -Path $TMP1 -ErrorAction Ignore
New-Item -Path $TMP1 -ItemType File

# 시작 정보 출력
@"
CODE [SRV-122] UMASK 설정 미흡

[양호]: 시스템 전체 UMASK 설정이 022 또는 더 엄격한 경우
[취약]: 시스템 전체 UMASK 설정이 022보다 덜 엄격한 경우
"@ | Out-File -FilePath $TMP1

# Windows의 경우, 파일 시스템 권한을 기반으로 'UMASK' 설정을 비슷하게 적용할 수 있음
# 예를 들어, NTFS 권한 설정을 검사하여 기본적인 보안 구성을 확인할 수 있음

# 시스템 드라이브의 기본 NTFS 권한 검사
$systemDrive = Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Used -ne $null } | Select-Object -First 1
$rootPermissions = Get-Acl -Path $systemDrive.Root | Select-Object -ExpandProperty Access

# 보안 정책 검사 예시 (NTFS 권한이 Everyone 또는 Authenticated Users에게 FullControl을 부여하지 않는지 확인)
$hasWeakPermissions = $false
foreach ($permission in $rootPermissions) {
    if (($permission.IdentityReference -eq "Everyone" -or $permission.IdentityReference -eq "Authenticated Users") -and $permission.FileSystemRights -eq "FullControl") {
        $hasWeakPermissions = $true
        "WARN: 시스템 드라이브에 Everyone 또는 Authenticated Users에게 FullControl 권한이 부여되어 있습니다." | Out-File -FilePath $TMP1 -Append
        break
    }
}

if (-not $hasWeakPermissions) {
    "OK: 시스템 전체 UMASK 설정이 적절하게 관리되고 있습니다." | Out-File -FilePath $TMP1 -Append
} else {
    "WARN: 시스템 전체 UMASK 설정이 적절하게 관리되지 않고 있습니다." | Out-File -FilePath $TMP1 -Append
}

# 결과 파일 출력
Get-Content -Path $TMP1
