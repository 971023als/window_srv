# FTP 관련 설정 파일의 경로를 배열로 정의
$ftpUsersFiles = @(
    "C:\Path\To\ftpusers",
    "C:\Other\Path\To\ftpusers" # Windows 환경에 맞는 실제 경로로 변경
)

# 파일 존재 여부 및 권한 확인
foreach ($file in $ftpUsersFiles) {
    if (Test-Path $file) {
        $fileInfo = Get-Item $file
        $acl = Get-Acl $file
        $owner = $acl.Owner
        $permissions = $acl.Access | Where-Object { $_.FileSystemRights -match "FullControl|Modify|Write" }

        if ($owner -eq "BUILTIN\Administrators" -or $owner -eq "NT AUTHORITY\SYSTEM") {
            if ($permissions.Count -eq 0) {
                Write-Host "파일 $file 의 소유자가 시스템 또는 관리자이고, 쓰기 권한이 제한되어 있습니다. - 양호"
            } else {
                Write-Host "파일 $file 의 쓰기 권한이 부적절하게 설정되어 있습니다. - 취약"
            }
        } else {
            Write-Host "파일 $file 의 소유자가 시스템 또는 관리자가 아닙니다. - 취약"
        }
    } else {
        Write-Host "파일 $file 은 존재하지 않습니다."
    }
}

# 주의: Windows 환경에서 FTP 서비스 구성은 서비스 제공자(IIS, FileZilla Server 등)에 따라 다르며, 
# ftpusers와 같은 특정 파일 대신 서비스 구성 콘솔이나 관리 도구를 통해 접근 제어를 설정할 수 있습니다.
