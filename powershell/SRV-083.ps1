$TMP1 = "$(SCRIPTNAME).log"
Clear-Content -Path $TMP1

BAR

$CODE = "[SRV-083] 시스템 스타트업 스크립트 권한 설정 미흡"

Add-Content -Path $TMP1 -Value "[양호]: 시스템 스타트업 스크립트의 권한이 적절히 설정된 경우"
Add-Content -Path $TMP1 -Value "[취약]: 시스템 스타트업 스크립트의 권한이 적절히 설정되지 않은 경우"

BAR

# Windows 서비스의 권한 설정 확인
$services = Get-WmiObject -Class Win32_Service
foreach ($service in $services) {
    $servicePath = $service.PathName.Trim('"')
    if (Test-Path $servicePath) {
        $acl = Get-Acl $servicePath
        $owner = $acl.Owner
        if ($owner -eq 'BUILTIN\Administrators' -or $owner -eq 'NT AUTHORITY\SYSTEM') {
            OK "서비스 $($service.Name)의 실행 파일 권한이 적절합니다. (소유자: $owner)"
        } else {
            WARN "서비스 $($service.Name)의 실행 파일 권한이 적절하지 않습니다. (소유자: $owner)"
        }
    }
}

# 스케줄된 작업의 권한 설정 확인 (예시, 실제 구현 필요)
# Windows 환경에서 스케줄된 작업의 파일 권한을 직접적으로 확인하는 것은 복잡할 수 있으며,
# 일반적으로 작업 스케줄러 GUI나 schtasks 명령어를 통해 관리됩니다.

Get-Content -Path $TMP1

Write-Host "`n"
