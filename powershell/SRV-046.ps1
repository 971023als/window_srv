# 로그 파일 생성 및 초기화
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

# 메시지 출력
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append
"코드 [SRV-046] 웹 서비스 경로 설정 미흡" | Out-File -FilePath $TMP1 -Append
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append
"[양호]: 웹 서비스의 파일 업로드 및 다운로드 크기가 적절하게 제한됨" | Out-File -FilePath $TMP1 -Append
"[취약]: 웹 서비스의 파일 업로드 및 다운로드 크기가 제한되지 않음" | Out-File -FilePath $TMP1 -Append
"------------------------------------------------" | Out-File -FilePath $TMP1 -Append

# IIS 설정 확인
Import-Module WebAdministration
Get-Website | ForEach-Object {
    $siteName = $_.Name
    $configPath = "IIS:\Sites\$siteName"
    $requestFiltering = Get-WebConfigurationProperty -pspath $configPath -filter "system.webServer/security/requestFiltering/requestLimits" -name "maxAllowedContentLength"

    $maxSize = $requestFiltering.Value / 1024 / 1024 # 바이트에서 MB로 변환
    if ($maxSize -lt 30) { # 예시 임계값 30MB
        "OK: $siteName 사이트는 파일 업로드를 $maxSize MB로 제한합니다." | Out-File -Append -FilePath $TMP1
    } else {
        "WARN: $siteName 사이트는 파일 업로드 제한이 높음 ($maxSize MB) 또는 설정되지 않음." | Out-File -Append -FilePath $TMP1
    }
}

"------------------------------------------------" | Out-File -FilePath $TMP1 -Append
Get-Content -Path $TMP1 | Write-Output

Write-Host "`n스크립트 완료."
