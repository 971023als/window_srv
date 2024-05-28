function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

$SCRIPTNAME = $MyInvocation.MyCommand.Name
$global:TMP1 = "$(Get-Location)\${SCRIPTNAME}_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[SRV-084] 시스템 주요 파일 권한 설정 미흡"

Add-Content -Path $global:TMP1 -Value "[양호]: 시스템 주요 파일의 권한이 적절하게 설정된 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: 시스템 주요 파일의 권한이 적절하게 설정되지 않은 경우"

BAR

# PATH 환경 변수 검사 및 수정
$cleanedPath = ($env:PATH -split ";" | Where-Object { $_ -notmatch "\.;" -and $_ -notmatch "::" }) -join ";"
if ($env:PATH -ne $cleanedPath) {
    [Environment]::SetEnvironmentVariable("PATH", $cleanedPath, [System.EnvironmentVariableTarget]::Machine)
    Add-Content -Path $global:TMP1 -Value "FIXED: PATH 환경 변수에서 잘못된 항목을 제거하였습니다."
} else {
    Add-Content -Path $global:TMP1 -Value "OK: PATH 환경 변수 검사 결과 문제가 없습니다."
}

BAR

# 사용자 홈 디렉터리 내 설정 파일의 권한 검사 및 수정
$userDirectories = Get-ChildItem -Path C:\Users -Directory
foreach ($dir in $userDirectories) {
    $profilePaths = @(".profile", ".bashrc", ".bash_profile", ".bash_login")
    foreach ($profilePath in $profilePaths) {
        $fullPath = Join-Path -Path $dir.FullName -ChildPath $profilePath
        if (Test-Path $fullPath) {
            $acl = Get-Acl $fullPath
            $everyoneAccessRules = $acl.Access | Where-Object { $_.FileSystemRights -match "Write" -and $_.IdentityReference.Value -eq "Everyone" }
            if ($everyoneAccessRules) {
                foreach ($rule in $everyoneAccessRules) {
                    $acl.RemoveAccessRule($rule)
                }
                Set-Acl -Path $fullPath -AclObject $acl
                Add-Content -Path $global:TMP1 -Value "FIXED: $($fullPath) 파일에서 'Everyone'의 쓰기 권한을 제거하였습니다."
            }
        }
    }
}

BAR

Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n스크립트 완료."
