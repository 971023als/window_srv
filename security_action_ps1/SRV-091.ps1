function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

$SCRIPTNAME = $MyInvocation.MyCommand.Name
$global:TMP1 = "$(Get-Location)\${SCRIPTNAME}_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[SRV-091] 불필요하게 넓은 권한이 설정된 파일 존재"

Add-Content -Path $global:TMP1 -Value "[양호]: 중요 파일 및 디렉터리에 적절한 권한이 설정된 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: 중요 파일 및 디렉터리에 너무 넓은 권한이 설정된 경우"

BAR

# 중요 디렉터리 및 파일 권한 검사 예시
$importantPaths = @("C:\Windows\System32", "C:\Program Files")

foreach ($path in $importantPaths) {
    $acl = Get-Acl $path
    foreach ($ace in $acl.Access) {
        if ($ace.FileSystemRights -eq "FullControl" -and $ace.IdentityReference -notmatch "^(BUILTIN\\Administrators|NT AUTHORITY\\SYSTEM)$") {
            Add-Content -Path $global:TMP1 -Value "WARN: '$path'에 너무 넓은 권한이 설정되어 있습니다. (권한: $($ace.FileSystemRights), 계정: $($ace.IdentityReference))"
        }
    }
}

# 사용자 정의 중요 파일 및 디렉터리에 대한 추가 검사를 여기에 구현할 수 있습니다.

Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n스크립트 완료."
