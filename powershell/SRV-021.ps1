# 변수 설정
$LogFilePath = "$($MyInvocation.MyCommand.Name).json"
$ftpusersFiles = @(
    "/etc/ftpusers",
    "/etc/pure-ftpd/ftpusers",
    "/etc/wu-ftpd/ftpusers",
    "/etc/vsftpd/ftpusers",
    "/etc/proftpd/ftpusers",
    "/etc/ftpd/ftpusers",
    "/etc/vsftpd.ftpusers",
    "/etc/vsftpd.user_list",
    "/etc/vsftpd/user_list"
)

# FTP 서비스 접근 제어 설정 검사
function Check-FTPAccessControl {
    $results = @()

    foreach ($file in $ftpusersFiles) {
        if (Test-Path $file) {
            $fileInfo = Get-Item $file
            $fileOwner = $fileInfo.GetAccessControl().Owner
            $filePermissions = (Get-Acl $file).Access
            
            foreach ($permission in $filePermissions) {
                if ($fileOwner -notmatch "BUILTIN\\Administrators|NT SERVICE\\TrustedInstaller" -or 
                    $permission.FileSystemRights -match "FullControl|Modify") {
                    $results += @{
                        FilePath = $file
                        Owner = $fileOwner
                        Permission = $permission.FileSystemRights
                        DiagnosisResult = "취약"
                        Message = "ftpusers 파일의 소유자가 관리자가 아니거나, 권한이 640 이상입니다."
                    }
                } else {
                    $results += @{
                        FilePath = $file
                        Owner = $fileOwner
                        Permission = $permission.FileSystemRights
                        DiagnosisResult = "양호"
                        Message = "ftpusers 파일의 소유자가 관리자이고, 권한이 적절하게 설정됨."
                    }
                }
            }
        }
    }

    if ($results.Count -eq 0) {
        $results += @{
            FilePath = "N/A"
            DiagnosisResult = "정보 미확인"
            Message = "ftp 접근 제어 파일이 없습니다."
        }
    }

    return $results
}

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-021"
    위험도 = "중간"
    진단항목 = "FTP 서비스 접근 제어 설정 미비"
    진단결과 = "(변수: 양호, 취약, 정보 미확인) "
    현황 = (Check-FTPAccessControl)
    대응방안 = "ftpusers 파일의 소유자를 관리자로 설정하고, 권한을 640 이하로 제한하세요."
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePath

# 결과 파일 출력
Get-Content $LogFilePath | Write-Output
