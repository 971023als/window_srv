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

# IIS 웹 사이트 설정 검사 및 수정
Import-Module WebAdministration
Get-Website | ForEach-Object {
    $siteName = $_.Name
    $path = "IIS:\Sites\$siteName"
    $maxAllowedContentLength = 31457280 # 30 MB in bytes
    
    # 현재 설정 조회
    $currentSetting = Get-WebConfigurationProperty -pspath $path -filter "system.webServer/security/requestFiltering/requestLimits" -name "maxAllowedContentLength"
    
    if ($currentSetting.Value -ne $maxAllowedContentLength) {
        # 설정 변경
        Set-WebConfigurationProperty -pspath $path -filter "system.webServer/security/requestFiltering/requestLimits" -name "maxAllowedContentLength" -value $maxAllowedContentLength
        "CHANGE: $siteName 사이트의 파일 업로드 크기 제한을 30MB로 설정했습니다." | Out-File -FilePath $TMP1 -Append
    } else {
        "OK: $siteName 사이트는 이미 파일 업로드를 30MB로 제한합니다." | Out-File -FilePath $TMP1 -Append
    }
}

# 결과 출력
Get-Content -Path $TMP1 | Write-Host

Write-Host "`n스크립트 완료. 설정이 업데이트되었습니다."
