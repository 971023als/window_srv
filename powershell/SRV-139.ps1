# 결과 파일 정의
$TMP1 = "$(Get-Date -Format 'yyyyMMddHHmmss')_SystemResourceOwnershipPermissions.log"

# 중요 시스템 자원 파일 목록
$systemResources = @(
    "C:\Windows\System32\drivers\etc\hosts",
    "C:\Path\To\Another\Important\File"
)

foreach ($resource in $systemResources) {
    if (Test-Path $resource) {
        $acl = Get-Acl $resource
        $owner = $acl.Owner
        $permissions = $acl.AccessToString

        # 예시로, 소유자가 'SYSTEM'이고 권한이 'FullControl'인지 검사
        if ($owner -eq "NT AUTHORITY\SYSTEM" -and $permissions.Contains("FullControl")) {
            "OK: $resource 은 적절한 소유자($owner) 및 권한을 가집니다." | Out-File -FilePath $TMP1 -Append
        } else {
            "WARN: $resource 은 부적절한 소유자($owner) 또는 권한을 가집니다." | Out-File -FilePath $TMP1 -Append
        }
    } else {
        "INFO: $resource 파일이 존재하지 않습니다." | Out-File -FilePath $TMP1 -Append
    }
}

# 결과 파일 출력
Get-Content -Path $TMP1
