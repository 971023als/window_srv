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

# 웹 서비스 경로 내 흔히 발견되는 불필요한 파일 목록 검사 및 삭제
"$(Get-Date) $WebServicePath 내 흔히 발견되는 불필요한 파일 검사 및 삭제 중:" | Out-File -FilePath $TMP1 -Append
$UnnecessaryFiles = Get-ChildItem -Path $WebServicePath -Recurse -Include "*.bak", "*.tmp", "*test*", "*example*"

foreach ($file in $UnnecessaryFiles) {
    Remove-Item $file.FullName -Force
    "$($file.FullName) 삭제됨" | Out-File -FilePath $TMP1 -Append
}

if ($UnnecessaryFiles.Count -eq 0) {
    "불필요한 파일이 존재하지 않습니다." | Out-File -FilePath $TMP1 -Append
} else {
    "삭제된 불필요한 파일 수: $($UnnecessaryFiles.Count)" | Out-File -FilePath $TMP1 -Append
}

BAR

# 결과 출력 및 로그 파일 삭제
Get-Content -Path $TMP1 | Write-Output
Remove-Item $TMP1 -Force

Write-Host `n"스크립트 완료. 불필요한 파일이 삭제되었습니다."
