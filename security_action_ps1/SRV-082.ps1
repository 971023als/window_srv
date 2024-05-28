function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

$SCRIPTNAME = $MyInvocation.MyCommand.Name
$global:TMP1 = "$(Get-Location)\${SCRIPTNAME}_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[SRV-082] 시스템 주요 디렉터리 권한 설정 미흡"

Add-Content -Path $global:TMP1 -Value "[양호]: 시스템 주요 디렉터리의 권한이 적절히 설정된 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: 시스템 주요 디렉터리의 권한이 적절히 설정되지 않은 경우"

BAR

# PATH 환경 변수 수정
$originalPath = $env:PATH
$newPath = ($env:PATH -split ";" | Where-Object { $_ -ne "." -and $_ -ne "" }) -join ";"
if ($originalPath -ne $newPath) {
    [Environment]::SetEnvironmentVariable("PATH", $newPath, [System.EnvironmentVariableTarget]::Machine)
    Add-Content -Path $global:TMP1 -Value "FIXED: PATH 환경 변수에서 잘못된 항목을 제거하였습니다."
} else {
    Add-Content -Path $global:TMP1 -Value "OK: PATH 환경 변수 내에 '.' 또는 '::'이 포함되어 있지 않습니다."
}

BAR

# 사용자 홈 디렉터리 내 설정 파일의 권한 수정
$userProfiles = Get-ChildItem -Path "C:\Users" -Directory
foreach ($profile in $userProfiles) {
    $userFiles = Get-ChildItem -Path $profile.FullName -File -Include ".profile", ".bashrc", ".bash_profile", ".bash_login" -ErrorAction SilentlyContinue
    foreach ($file in $userFiles) {
        $acl = Get-Acl -Path $file.FullName
        $everyone = New-Object System.Security.Principal.SecurityIdentifier("S-1-1-0")
        $aclAccess = $acl.Access | Where-Object { $_.IdentityReference -eq $everyone -and $_.FileSystemRights -match "Write" }
        if ($aclAccess) {
            $acl.RemoveAccessRuleAll($aclAccess)
            Set-Acl -Path $file.FullName -AclObject $acl
            Add-Content -Path $global:TMP1 -Value "FIXED: $($file.FullName) 파일에서 Everyone 그룹의 쓰기 권한을 제거하였습니다."
        }
    }
}

BAR

Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n스크립트 완료."
