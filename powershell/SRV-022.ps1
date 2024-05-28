# 변수 설정
$LogFilePath = "$($MyInvocation.MyCommand.Name).json"

# 계정의 비밀번호 설정 상태 검사
function Check-AccountPasswordSettings {
    $accounts = Get-WmiObject -Class Win32_UserAccount -Filter "LocalAccount=True"
    $results = @()

    foreach ($account in $accounts) {
        if (-not $account.PasswordRequired) {
            $results += @{
                Username = $account.Name
                PasswordRequired = $false
                Message = "비밀번호가 설정되지 않은 계정: $($account.Name)"
                DiagnosisResult = "취약"
            }
        } else {
            $results += @{
                Username = $account.Name
                PasswordRequired = $true
                Message = "비밀번호가 설정된 계정: $($account.Name)"
                DiagnosisResult = "양호"
            }
        }
    }

    if ($results.Where({ $_.PasswordRequired -eq $false }).Count -gt 0) {
        $overallResult = "취약"
    } else {
        $overallResult = "양호"
    }

    @{
        Accounts = $results
        OverallResult = $overallResult
    }
}

# JSON 데이터 구성
$jsonData = @{
    분류 = "시스템 보안"
    코드 = "SRV-022"
    위험도 = "중간"
    진단항목 = "계정의 비밀번호 미설정, 빈 암호 사용 관리 미흡"
    진단결과 = "(변수: 양호, 취약) "
    현황 = (Check-AccountPasswordSettings)
    대응방안 = "모든 계정에 강력한 비밀번호를 설정하고 빈 비밀번호 사용을 금지하세요."
}

# JSON 파일로 결과 저장
$jsonData | ConvertTo-Json -Depth 5 | Set-Content $LogFilePath

# 결과 파일 출력
Get-Content $LogFilePath | Write-Output
