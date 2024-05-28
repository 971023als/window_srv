# 임시 로그 파일 생성
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

# 메시지 구분자 함수
function BAR {
    "------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

BAR
"CODE [SRV-043] 웹 서비스 경로 내 불필요한 파일 존재" | Out-File -FilePath $TMP1 -Append

@"
[양호]: 웹 서비스 경로 내 불필요한 파일이 존재하지 않음
[취약]: 웹 서비스 경로 내 불필요한 파일이 존재함
"@ | Out-File -FilePath $TMP1 -Append

BAR

# 기본 IIS 웹 서비스 경로 설정
$WebServicePath = "C:\inetpub\wwwroot"

# 웹 서비스 경로 내 흔히 발견되는 불필요한 파일 목록 검사
"$(Get-Date) $WebServicePath 내 흔히 발견되는 불필요한 파일 검사 중:" | Out-File -FilePath $TMP1 -Append
Get-ChildItem -Path $WebServicePath -Recurse -Include "*.bak", "*.tmp", "*test*", "*example*" | ForEach-Object {
    $_.FullName | Out-File -FilePath $TMP1 -Append
}

# 주의: 이 스크립트는 흔한 패턴을 기반으로 파일을 나열합니다. 수동으로 검토해 주세요.
"주의: 나열된 파일을 수동으로 검토하여 필요한 파일인지 확인해 주세요." | Out-File -FilePath $TMP1 -Append

BAR

# 결과 출력
Get-Content -Path $TMP1 | Write-Output

Write-Host `n"스크립트 완료."
