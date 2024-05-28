$TMP1 = "$(SCRIPTNAME).log"
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-084] 시스템 주요 파일 권한 설정 미흡"

Add-Content -Path $TMP1 -Value "[양호]: 시스템 주요 파일의 권한이 적절하게 설정된 경우"
Add-Content -Path $TMP1 -Value "[취약]: 시스템 주요 파일의 권한이 적절하게 설정되지 않은 경우"

BAR

# PATH 환경 변수 검사
if ($env:PATH -match "\.;" -or $env:PATH -match "::") {
    Add-Content -Path $TMP1 -Value "WARN: PATH 환경 변수 내에 '.' 또는 '::'이 포함되어 있습니다."
} else {
    Add-Content -Path $TMP1 -Value "OK: PATH 환경 변수 검사 결과 문제가 없습니다."
}

# 사용자 홈 디렉터리 내 설정 파일의 권한 검사
$userDirectories = Get-ChildItem -Path C:\Users -Directory
foreach ($dir in $userDirectories) {
    $profilePaths = @(".profile", ".bashrc", ".bash_profile", ".bash_login")
    foreach ($profilePath in $profilePaths) {
        $fullPath = Join-Path -Path $dir.FullName -ChildPath $profilePath
        if (Test-Path $fullPath) {
            $acl = Get-Acl $fullPath
            foreach ($access in $acl.Access) {
                if ($access.FileSystemRights -match "Write" -and $access.IdentityReference.Value -eq "Everyone") {
                    Add-Content -Path $TMP1 -Value "WARN: $($fullPath) 파일에 'Everyone'이 쓰기 권한을 가지고 있습니다."
                }
            }
        }
    }
}

Get-Content -Path $TMP1

Write-Host "`n"
