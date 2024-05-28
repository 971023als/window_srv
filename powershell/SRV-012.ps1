# 변수 설정
$LogFilePathNetrc = "$($MyInvocation.MyCommand.Name)_Netrc.json"

# .netrc 파일 검사 및 권한 확인 함수
function Get-NetrcFileStatus {
    $netrcFiles = Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue -Filter ".netrc" -Force
    if ($netrcFiles.Count -eq 0) {
        @{
            FilesPresent = $false
            Message = "OK: 시스템에 .netrc 파일이 존재하지 않습니다."
            DiagnosisResult = "양호"
        }
    } else {
        $fileDetails = $netrcFiles | ForEach-Object {
            @{
                FilePath = $_.FullName
                Permissions = (Get-Acl $_.FullName).AccessToString
            }
        }
        @{
            FilesPresent = $true
            Message = "WARN: 시스템 전체에서 .netrc 파일이 존재합니다."
            FileDetails = $fileDetails
            DiagnosisResult = "취약"
        }
    }
}

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-012"
    위험도 = "중간"
    진단항목 = ".netrc 파일 내 중요 정보 노출"
    현황 = (Get-NetrcFileStatus)
    대응방안 = "시스템 전체에서 .netrc 파일을 제거하거나 적절한 권한 설정 적용"
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePathNetrc

# 결과 파일 출력
Get-Content $LogFilePathNetrc | Write-Output
