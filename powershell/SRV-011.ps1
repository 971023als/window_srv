# 변수 설정
$LogFilePathFTP = "$($MyInvocation.MyCommand.Name)_FTP.json"
$FTPUsersFile = "C:\Windows\System32\inetsrv\config\applicationHost.config" # 예시 경로

# FTP 사용자 제한 설정 확인 함수
function Get-FTPAdminAccessRestrictionStatus {
    if (Test-Path $FTPUsersFile) {
        $content = Get-Content $FTPUsersFile -Raw
        if ($content -match 'system\.applicationHost\/sites\/site\/ftpServer\/security\/authorization\[userType=\'Allow\' and users=\'administrators\']') {
            @{
                FileExists = $true
                AdminAccessRestricted = $false
                Message = "WARN: FTP 서비스에서 관리자 계정의 접근이 제한되지 않습니다."
                DiagnosisResult = "취약"
            }
        } else {
            @{
                FileExists = $true
                AdminAccessRestricted = $true
                Message = "OK: FTP 서비스에서 관리자 계정의 접근이 제한됩니다."
                DiagnosisResult = "양호"
            }
        }
    } else {
        @{
            FileExists = $false
            AdminAccessRestricted = "Not Applicable"
            Message = "WARN: FTP 사용자 제한 설정 파일($FTPUsersFile)이 존재하지 않습니다."
            DiagnosisResult = "취약"
        }
    }
}

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-011"
    위험도 = "중간"
    진단항목 = "시스템 관리자 계정의 FTP 사용 제한 미비"
    현황 = (Get-FTPAdminAccessRestrictionStatus)
    대응방안 = "FTP 서비스에서 시스템 관리자 계정의 접근을 엄격히 제한"
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePathFTP

# 결과 파일 출력
Get-Content $LogFilePathFTP | Write-Output
