$TMP1 = "$(SCRIPTNAME).log"
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-082] 시스템 주요 디렉터리 권한 설정 미흡"

Add-Content -Path $TMP1 -Value "[양호]: 시스템 주요 디렉터리의 권한이 적절히 설정된 경우"
Add-Content -Path $TMP1 -Value "[취약]: 시스템 주요 디렉터리의 권한이 적절히 설정되지 않은 경우"

BAR

# PATH 환경 변수 내에 "." 또는 "::"이 포함되어 있는지 확인
if ($env:PATH -match "\.;" -or $env:PATH -match "::") {
    Add-Content -Path $TMP1 -Value "WARN: PATH 환경 변수 내에 '.' 또는 '::'이 포함되어 있습니다."
} else {
    Add-Content -Path $TMP1 -Value "OK: PATH 환경 변수 내에 '.' 또는 '::'이 포함되어 있지 않습니다."
}

# 사용자 홈 디렉터리 내 설정 파일의 권한 확인
$userProfiles = Get-ChildItem -Path "C:\Users" -Directory
foreach ($profile in $userProfiles) {
    $userFiles = Get-ChildItem -Path $profile.FullName -File -Include ".profile", ".bashrc", ".bash_profile", ".bash_login" -ErrorAction SilentlyContinue
    foreach ($file in $userFiles) {
        $acl = Get-Acl -Path $file.FullName
        if ($acl.Access | Where-Object { $_.FileSystemRights -match "Write" -and $_.IdentityReference -eq "Everyone" }) {
            Add-Content -Path $TMP1 -Value "WARN: $($file.FullName) 파일에 Everyone 그룹에 쓰기 권한이 부여되어 있습니다."
        }
    }
}

Get-Content -Path $TMP1

Write-Host "`n"
