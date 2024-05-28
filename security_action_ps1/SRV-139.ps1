# 스크립트 이름 정의
$ScriptName = "CheckSystemOwnership"

# 로그 파일 경로 설정
$LogFile = "$ScriptName.log"

# 로그 파일 초기화
"" | Set-Content -Path $LogFile

# 로그 파일에 정보 출력
"----------------------------------------" | Out-File -FilePath $LogFile -Append
"CODE [SRV-139] 시스템 자원 소유권 변경 권한 설정 미흡" | Out-File -FilePath $LogFile -Append
"----------------------------------------" | Out-File -FilePath $LogFile -Append
"[양호]: 중요 시스템 자원의 소유권 변경 권한이 제한되어 있는 경우" | Out-File -FilePath $LogFile -Append
"[취약]: 중요 시스템 자원의 소유권 변경 권한이 제한되어 있지 않은 경우" | Out-File -FilePath $LogFile -Append
"----------------------------------------" | Out-File -FilePath $LogFile -Append

# 타겟 경로 설정
$targetPath = "C:\Windows\System32"

# 파일 권한 확인 및 로그 파일에 출력
$acl = Get-Acl -Path $targetPath
$acl.Access | Out-File -FilePath $LogFile -Append

# 권한 분석 로직
$expectedOwners = @('BUILTIN\Administrators', 'NT AUTHORITY\SYSTEM')
$actualOwners = $acl.Access | Where-Object { $_.FileSystemRights -match 'FullControl' } | Select-Object -ExpandProperty IdentityReference
$isCompliant = $actualOwners | ForEach-Object { $_.Value } | Where-Object { $_ -in $expectedOwners } | Measure-Object

if ($isCompliant.Count -eq $expectedOwners.Count) {
    "권한 설정이 양호합니다." | Out-File -FilePath $LogFile -Append
} else {
    "권한 설정이 취약합니다. 수정이 필요합니다." | Out-File -FilePath $LogFile -Append
}

# 로그 파일 출력
Get-Content -Path $LogFile | Write-Output
