function BAR {
    Add-Content -Path $global:TMP1 -Value ("-" * 50)
}

$SCRIPTNAME = $MyInvocation.MyCommand.Name
$global:TMP1 = "$(Get-Location)\${SCRIPTNAME}_log.txt"
Clear-Content -Path $global:TMP1

BAR

$CODE = "[SRV-108] 로그에 대한 접근통제 및 관리 미흡"

Add-Content -Path $global:TMP1 -Value "[양호]: 로그 파일의 접근 통제 및 관리가 적절하게 설정되어 있는 경우"
Add-Content -Path $global:TMP1 -Value "[취약]: 로그 파일의 접근 통제 및 관리가 적절하게 설정되어 있지 않은 경우"

BAR

# 로그 파일의 접근 권한 설정 확인 및 조정
$eventLogPaths = @("C:\Windows\System32\winevt\Logs\Application.evtx", "C:\Windows\System32\winevt\Logs\Security.evtx", "C:\Windows\System32\winevt\Logs\System.evtx")
$desiredPermission = "BUILTIN\Administrators"

foreach ($logPath in $eventLogPaths) {
    if (Test-Path $logPath) {
        $acl = Get-Acl $logPath
        $adminPermissions = $acl.Access | Where-Object { $_.IdentityReference.Value -eq $desiredPermission -and $_.FileSystemRights -match "FullControl" }
        
        if ($null -eq $adminPermissions) {
            # 권한 설정이 적절하지 않은 경우, 수정
            $permission = New-Object System.Security.AccessControl.FileSystemAccessRule($desiredPermission, "FullControl", "Allow")
            $acl.SetAccessRule($permission)
            Set-Acl -Path $logPath -AclObject $acl
            Add-Content -Path $global:TMP1 -Value "UPDATED: $logPath 로그 파일의 접근 권한이 적절하게 조정되었습니다."
        } else {
            Add-Content -Path $global:TMP1 -Value "OK: $logPath 로그 파일의 접근 권한이 이미 적절합니다."
        }
    } else {
        Add-Content -Path $global:TMP1 -Value "WARN: 로그 파일($logPath)이 존재하지 않습니다."
    }
}

Get-Content -Path $global:TMP1 | Out-Host

Write-Host "`n스크립트 완료."
