# 로그 파일 생성 및 초기화
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

# 메시지 구분자 및 코드 정보 출력
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append
"코드 [SRV-044] 웹 서비스 파일 업로드 및 다운로드 크기 제한 미설정" | Out-File -FilePath $TMP1 -Append
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append
@"
[양호]: 웹 서비스에서 파일 업로드 및 다운로드 크기가 적절하게 제한됨
[취약]: 웹 서비스에서 파일 업로드 및 다운로드 크기가 제한되지 않음
"@ | Out-File -FilePath $TMP1 -Append
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append

# IIS 웹 사이트 설정 검사
Import-Module WebAdministration
Get-Website | ForEach-Object {
    $siteName = $_.Name
    $requestFiltering = Get-WebConfigurationProperty -pspath "IIS:\Sites\$siteName" -filter "system.webServer/security/requestFiltering/requestLimits" -name "maxAllowedContentLength"
    
    $maxSizeMB = $requestFiltering.Value / 1024 / 1024 # 바이트에서 MB로 변환
    if ($maxSizeMB -lt 30) { # 예시 임계값 30MB
        "OK: $siteName 사이트는 파일 업로드를 $maxSizeMB MB로 제한합니다." | Out-File -FilePath $TMP1 -Append
    } else {
        "WARN: $siteName 사이트는 파일 업로드 제한이 높음 ($maxSizeMB MB) 또는 설정되지 않음." | Out-File -FilePath $TMP1 -Append
    }
}

# 결과 출력
Get-Content -Path $TMP1 | Write-Host

Write-Host "`n스크립트 완료."
