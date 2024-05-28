# 로그 파일 생성 및 초기화
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

# 메시지 출력
"코드 [SRV-047] 웹 서비스 경로 내 불필요한 링크 파일 존재" | Out-File -FilePath $TMP1 -Append
"[양호]: 웹 서비스 경로 내 불필요한 심볼릭 링크 파일이 존재하지 않음" | Out-File -FilePath $TMP1 -Append
"[취약]: 웹 서비스 경로 내 불필요한 심볼릭 링크 파일이 존재함" | Out-File -FilePath $TMP1 -Append

# IIS 웹 서비스 경로 설정
$IIS_WEB_SERVICE_PATH = "C:\inetpub\wwwroot"

# IIS 웹 서비스 경로 내 심볼릭 링크(.lnk 및 기타 링크 파일) 검색 및 삭제
"$(Get-Date) - $( $IIS_WEB_SERVICE_PATH ) 내 심볼릭 링크 파일 검사 및 삭제 중:" | Out-File -FilePath $TMP1 -Append
$LinkFiles = Get-ChildItem -Path $IIS_WEB_SERVICE_PATH -Include "*.lnk", "*.url" -Recurse

foreach ($File in $LinkFiles) {
    Remove-Item $File.FullName -Force
    "$($File.FullName) 삭제됨" | Out-File -FilePath $TMP1 -Append
}

if ($LinkFiles.Count -eq 0) {
    "불필요한 심볼릭 링크 파일이 존재하지 않습니다." | Out-File -FilePath $TMP1 -Append
} else {
    "삭제된 심볼릭 링크 파일 수: $($LinkFiles.Count)" | Out-File -FilePath $TMP1 -Append
}

# 관리자에게의 주의사항
"주의: 삭제 작업은 신중을 기하여 수행되었습니다. 삭제된 파일 목록을 검토해 주세요." | Out-File -FilePath $TMP1 -Append

# 결과 표시
Get-Content -Path $TMP1 | Write-Output

Write-Host "`n스크립트 완료. 불필요한 심볼릭 링크 파일이 삭제되었습니다."
