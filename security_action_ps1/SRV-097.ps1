function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

$SCRIPTNAME = $MyInvocation.MyCommand.Name
$global:TMP1 = "$(Get-Location)\${SCRIPTNAME}_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[SRV-097] FTP 서비스 디렉터리 접근권한 설정 미흡"

Add-Content -Path $global:TMP1 -Value "[양호]: FTP 서비스 디렉터리의 접근 권한이 적절하게 설정된 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: FTP 서비스 디렉터리의 접근 권한이 적절하지 않게 설정된 경우"

BAR

# FTP 서비스 상태 확인
$ftpService = Get-Service -Name 'ftpsvc' -ErrorAction SilentlyContinue

if ($ftpService -and $ftpService.Status -eq 'Running') {
    Add-Content -Path $global:TMP1 -Value "WARN: FTP 서비스가 실행 중입니다."
} else {
    Add-Content -Path $global:TMP1 -Value "OK: FTP 서비스가 비활성화되어 있습니다."
}

# FTP 서비스 디렉터리 권한 설정 검사 및 수정
$ftpDirectory = "C:\inetpub\ftproot"
if (Test-Path $ftpDirectory) {
    $acl = Get-Acl -Path $ftpDirectory
    $accessRules = $acl.Access | Where-Object { $_.FileSystemRights -match 'Write' -and $_.IdentityReference.Value -eq 'Everyone' }
    if ($accessRules) {
        foreach ($rule in $accessRules) {
            $acl.RemoveAccessRule($rule)
            Set-Acl -Path $ftpDirectory -AclObject $acl
        }
        Add-Content -Path $global:TMP1 -Value "FIXED: $ftpDirectory 디렉터리에서 Everyone에게 쓰기 권한을 제거하였습니다."
    } else {
        Add-Content -Path $global:TMP1 -Value "OK: $ftpDirectory 디렉터리의 접근 권한이 적절하게 설정되어 있습니다."
    }
} else {
    Add-Content -Path $global:TMP1 -Value "OK: FTP 서비스 디렉터리($ftpDirectory)가 존재하지 않습니다."
}

Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n스크립트 완료."
