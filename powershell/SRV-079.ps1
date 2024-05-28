# function.ps1 내용 포함 (적절한 경로 지정 필요)
. .\function.ps1

$TMP1 = "$(SCRIPTNAME).log"
# TMP1 파일 초기화
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-079] 익명 사용자에게 부적절한 권한(Everyone) 적용"

$result = "결과 파일 경로를 지정해야 함"
Add-Content -Path $result -Value "[양호]: 익명 사용자에게 부적절한 권한이 적용되지 않은 경우"
Add-Content -Path $result -Value "[취약]: 익명 사용자에게 부적절한 권한이 적용된 경우"

BAR

# 시스템 전체를 검색할 수 있으나, 성능상의 이유로 시스템의 특정 부분을 타겟으로 할 수도 있습니다.
# 예: C:\ 드라이브 내의 모든 파일 및 폴더에 대한 권한 검사
$worldWritableFiles = Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue | Where-Object {
    try {
        $acl = Get-Acl -Path $_.FullName
        $acl.Access | Where-Object { $_.FileSystemRights -match "Write" -and $_.IdentityReference -eq "Everyone" }
    } catch {
        $false
    }
}

if ($worldWritableFiles) {
    Add-Content -Path $TMP1 -Value "WARN: world writable 설정이 되어 있는 파일이 있습니다."
} else {
    Add-Content -Path $TMP1 -Value "※ U-15 결과 : 양호(Good)"
}

Get-Content -Path $result

Write-Host "`n"
