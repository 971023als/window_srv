function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

$SCRIPTNAME = $MyInvocation.MyCommand.Name
$global:TMP1 = "$(Get-Location)\${SCRIPTNAME}_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[SRV-096] 사용자 환경파일의 소유자 또는 권한 설정 미흡"

Add-Content -Path $global:TMP1 -Value "[양호]: 사용자 환경 파일의 소유자가 해당 사용자이고, 권한이 적절하게 설정된 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: 사용자 환경 파일의 소유자가 해당 사용자가 아니거나, 권한이 부적절하게 설정된 경우"

BAR

# 사용자 프로필 디렉터리 검사 및 권한 수정
$userProfiles = Get-ChildItem -Path "C:\Users" -Directory
$startFiles = @(".profile", ".cshrc", ".login", ".kshrc", ".bash_profile", ".bashrc", ".bash_login")

foreach ($profile in $userProfiles) {
    $userName = $profile.Name
    foreach ($file in $startFiles) {
        $filePath = Join-Path -Path $profile.FullName -ChildPath $file
        if (Test-Path $filePath) {
            $acl = Get-Acl $filePath
            $fileOwner = $acl.Owner
            # 소유자가 적절한지 확인하고, 필요한 경우 수정
            if ($fileOwner -notmatch $userName) {
                $userObj = New-Object System.Security.Principal.NTAccount($userName)
                $acl.SetOwner($userObj)
                Add-Content -Path $global:TMP1 -Value "UPDATED: $($filePath) 파일의 소유자를 $($userName)으로 변경하였습니다."
            }
            # Everyone의 쓰기 권한 제거
            $everyonePermissions = $acl.Access | Where-Object { $_.IdentityReference.Value -eq "Everyone" -and $_.FileSystemRights -match "Write" }
            if ($everyonePermissions) {
                foreach ($permission in $everyonePermissions) {
                    $acl.RemoveAccessRule($permission)
                    Add-Content -Path $global:TMP1 -Value "REMOVED: $($filePath) 파일에서 Everyone 그룹의 쓰기 권한을 제거하였습니다."
                }
                Set-Acl -Path $filePath -AclObject $acl
            } else {
                Add-Content -Path $global:TMP1 -Value "OK: $($filePath) 파일의 소유자 및 권한 설정이 적절합니다."
            }
        }
    }
}

Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n스크립트 완료."
