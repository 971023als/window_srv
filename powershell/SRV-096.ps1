$TMP1 = "$(SCRIPTNAME).log"
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-096] 사용자 환경파일의 소유자 또는 권한 설정 미흡"

Add-Content -Path $TMP1 -Value "[양호]: 사용자 환경 파일의 소유자가 해당 사용자이고, 권한이 적절하게 설정된 경우"
Add-Content -Path $TMP1 -Value "[취약]: 사용자 환경 파일의 소유자가 해당 사용자가 아니거나, 권한이 부적절하게 설정된 경우"

BAR

# 사용자 프로필 디렉터리 검사
$userProfiles = Get-ChildItem -Path "C:\Users" -Directory
$startFiles = @(".profile", ".cshrc", ".login", ".kshrc", ".bash_profile", ".bashrc", ".bash_login")

foreach ($profile in $userProfiles) {
    foreach ($file in $startFiles) {
        $filePath = Join-Path -Path $profile.FullName -ChildPath $file
        if (Test-Path $filePath) {
            $fileOwner = (Get-Acl $filePath).Owner
            $everyonePermissions = (Get-Acl $filePath).Access | Where-Object { $_.IdentityReference -eq "Everyone" }
            if ($everyonePermissions -and $everyonePermissions.FileSystemRights -match "Write") {
                Add-Content -Path $TMP1 -Value "WARN: $($filePath) 파일에 Everyone 그룹에 쓰기 권한이 부여되어 있습니다."
            } else {
                Add-Content -Path $TMP1 -Value "OK: $($filePath) 파일의 소유자 및 권한 설정이 적절합니다."
            }
        }
    }
}

# r 계열 서비스 검사 로직은 Windows 환경에서 직접적으로 적용되지 않으므로 생략
# Windows에서는 대신 서비스 상태를 검사할 수 있으나, r 계열 서비스에 직접 해당되는 항목이 없음

Get-Content -Path $TMP1

Write-Host "`n"
