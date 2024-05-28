# 임시 로그 파일 생성
$TMP1 = "$([System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Name)).log"
"" | Out-File -FilePath $TMP1

# 메시지 구분자 함수
function BAR {
    "------------------------------------------------" | Out-File -FilePath $TMP1 -Append
}

BAR
"CODE [SRV-040] 웹 서비스 디렉터리 리스팅 방지 설정 미흡" | Out-File -FilePath $TMP1 -Append

@"
[양호]: 웹 서비스 디렉터리 리스팅이 적절하게 방지된 경우
[취약]: 웹 서비스 디렉터리 리스팅 방지 설정이 미흡한 경우
"@ | Out-File -FilePath $TMP1 -Append

BAR

# 디렉터리 브라우징 설정 확인
Import-Module WebAdministration
$sites = Get-Website
foreach ($site in $sites) {
    $directoryBrowsing = Get-WebConfigurationProperty -pspath "IIS:\Sites\$($site.name)" -filter 'system.webServer/directoryBrowse' -name 'enabled'
    if ($directoryBrowsing.Value -eq $true) {
        "WARN: 웹 사이트 '$($site.name)'에서 디렉터리 브라우징이 활성화되어 있습니다." | Out-File -FilePath $TMP1 -Append
    } else {
        "OK: 웹 사이트 '$($site.name)'에서 디렉터리 브라우징이 비활성화되어 있습니다." | Out-File -FilePath $TMP1 -Append
    }
}

BAR

# 결과 출력
Get-Content -Path $TMP1 | Write-Host
