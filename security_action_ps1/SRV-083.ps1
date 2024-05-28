function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

function OK($message) {
    Add-Content -Path $global:TMP1 -Value "OK: $message"
}

function WARN($message) {
    Add-Content -Path $global:TMP1 -Value "WARN: $message"
}

$SCRIPTNAME = $MyInvocation.MyCommand.Name
$global:TMP1 = "$(Get-Location)\${SCRIPTNAME}_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[SRV-083] 시스템 스타트업 스크립트 권한 설정 미흡"

Add-Content -Path $global:TMP1 -Value "[양호]: 시스템 스타트업 스크립트의 권한이 적절히 설정된 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: 시스템 스타트업 스크립트의 권한이 적절히 설정되지 않은 경우"

BAR

# Windows 서비스의 실행 파일 권한 설정 확인 및 수정
$services = Get-WmiObject -Class Win32_Service
foreach ($service in $services) {
    $servicePath = $service.PathName -replace '^"(.+)"$', '$1'
    if ($servicePath -and (Test-Path $servicePath)) {
        $acl = Get-Acl $servicePath
        $owner = $acl.Owner
        if ($owner -match 'BUILTIN\\Administrators' -or $owner -match 'NT AUTHORITY\\SYSTEM') {
            OK "서비스 $($service.Name)의 실행 파일 권한이 적절합니다. (소유자: $owner)"
        } else {
            # 권한 수정
            $newOwner = New-Object System.Security.Principal.NTAccount('BUILTIN', 'Administrators')
            $acl.SetOwner($newOwner)
            Set-Acl -Path $servicePath -AclObject $acl
            WARN "서비스 $($service.Name)의 실행 파일 권한이 수정되었습니다. 새 소유자: BUILTIN\Administrators"
        }
    }
}

Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n스크립트 완료."
