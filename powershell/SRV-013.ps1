# 변수 설정
$LogFilePathFTPAnon = "$($MyInvocation.MyCommand.Name)_FTPAnon.json"

# 익명 계정 접속 제한 설정 확인 함수
function Get-FTPAnonymousAccessRestrictionStatus {
    $ftpUserExists = Get-Content -Path "C:\Windows\System32\drivers\etc\passwd" | Where-Object { $_ -match "^(ftp|anonymous)" }

    if ($ftpUserExists) {
        $fileDetails = @()

        # ProFTPD 설정 파일 검사
        $proftpdConfFiles = Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue -Filter "proftpd.conf"
        foreach ($file in $proftpdConfFiles) {
            $content = Get-Content -Path $file.FullName
            if ($content -match '<Anonymous' -and $content -notmatch 'DenyAll') {
                $fileDetails += @{
                    FilePath = $file.FullName
                    Message = "Anonymous FTP access is not properly restricted."
                }
            }
        }

        # VsFTPD 설정 파일 검사
        $vsftpdConfFiles = Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue -Filter "vsftpd.conf"
        foreach ($file in $vsftpdConfFiles) {
            $content = Get-Content -Path $file.FullName
            $anonymousEnable = $content | Where-Object { $_ -match 'anonymous_enable' }
            if ($anonymousEnable -match 'yes') {
                $fileDetails += @{
                    FilePath = $file.FullName
                    Message = "Anonymous FTP access is enabled."
                }
            }
        }

        if ($fileDetails.Count -eq 0) {
            @{
                AnonymousFTPBlocked = $true
                Message = "Anonymous FTP access is properly restricted."
                DiagnosisResult = "양호"
            }
        } else {
            @{
                AnonymousFTPBlocked = $false
                FileDetails = $fileDetails
                DiagnosisResult = "취약"
            }
        }
    } else {
        @{
            AnonymousFTPBlocked = $true
            Message = "No anonymous FTP users found."
            DiagnosisResult = "양호"
        }
    }
}

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-013"
    위험도 = "중간"
    진단항목 = "Anonymous 계정의 FTP 서비스 접속 제한 미비"
    현황 = (Get-FTPAnonymousAccessRestrictionStatus)
    대응방안 = "FTP 서비스에서 익명 계정의 접근을 엄격히 제한"
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePathFTPAnon

# 결과 파일 출력
Get-Content $LogFilePathFTPAnon | Write-Output
