$TMP1 = "$(SCRIPTNAME).log"
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-097] FTP 서비스 디렉터리 접근권한 설정 미흡"

Add-Content -Path $TMP1 -Value "[양호]: FTP 서비스 디렉터리의 접근 권한이 적절하게 설정된 경우"
Add-Content -Path $TMP1 -Value "[취약]: FTP 서비스 디렉터리의 접근 권한이 적절하지 않게 설정된 경우"

BAR

# FTP 서비스 상태 확인
$ftpService = Get-Service -Name 'ftpsvc' -ErrorAction SilentlyContinue

if ($ftpService -and $ftpService.Status -eq 'Running') {
    Add-Content -Path $TMP1 -Value "WARN: FTP 서비스가 실행 중입니다."
} else {
    Add-Content -Path $TMP1 -Value "OK: FTP 서비스가 비활성화되어 있습니다."
}

# FTP 서비스 디렉터리 권한 설정 검사 (예제로 C:\inetpub\ftproot를 사용)
$ftpDirectory = "C:\inetpub\ftproot"
if (Test-Path $ftpDirectory) {
    $acl = Get-Acl -Path $ftpDirectory
    $accessRules = $acl.Access | Where-Object { $_.FileSystemRights -match 'Write' -and $_.IdentityReference -eq 'Everyone' }
    if ($accessRules) {
        Add-Content -Path $TMP1 -Value "WARN: $ftpDirectory 디렉터리에 Everyone에게 쓰기 권한이 부여되어 있습니다."
    } else {
        Add-Content -Path $TMP1 -Value "OK: $ftpDirectory 디렉터리의 접근 권한이 적절하게 설정되어 있습니다."
    }
} else {
    Add-Content -Path $TMP1 -Value "OK: FTP 서비스 디렉터리($ftpDirectory)가 존재하지 않습니다."
}

Get-Content -Path $TMP1

Write-Host "`n"
