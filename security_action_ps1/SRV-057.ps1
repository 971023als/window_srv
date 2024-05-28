# 로그 파일 생성 및 초기화
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

# 메시지 출력
"코드 [SRV-057] 웹 서비스 경로 내 접근 통제 미흡" | Out-File -FilePath $TMP1 -Append
"[양호]: 웹 서비스 경로 내 파일에 대한 접근 권한이 적절하게 설정됨" | Out-File -FilePath $TMP1 -Append
"[취약]: 웹 서비스 경로 내 파일에 대한 접근 권한이 적절하게 설정되지 않음" | Out-File -FilePath $TMP1 -Append

# 웹 서비스 경로 설정
$WEB_SERVICE_PATH = "C:\Path\To\Web\Service"

# 웹 서비스 경로 내 파일의 권한 목록
"$(Get-Date) - $WEB_SERVICE_PATH 내 파일에 대한 권한 목록:" | Out-File -FilePath $TMP1 -Append
Get-ChildItem -Path $WEB_SERVICE_PATH -Recurse -File | ForEach-Object {
    $file = $_.FullName
    $acl = Get-Acl -Path $file
    "$file 권한:" | Out-File -FilePath $TMP1 -Append
    $acl.Access | ForEach-Object { $_ | Out-File -FilePath $TMP1 -Append }
}

# 관리자에게의 주의 사항
"주의: 나열된 권한을 수동으로 검토하여 적절하게 설정되었는지 확인해 주세요." | Out-File -FilePath $TMP1 -Append

# 결과 표시
Get-Content -Path $TMP1 | Write-Output

Write-Host "`n스크립트 완료."
